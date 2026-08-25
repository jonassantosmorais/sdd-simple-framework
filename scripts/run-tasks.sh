#!/usr/bin/env bash
# Dispatch every pending task_NN.md in .sdd/tasks/<slug>/ to the sdd-execute-task skill,
# respecting the dependency waves declared in _tasks.md's graph.edges.
#
# This is the batch-execution replacement for a CLI dispatcher: no daemon, no run registry —
# just `claude -p` invoked once per ready task, one wave at a time. Tasks within a wave run in
# parallel background jobs; the script waits for the whole wave before starting the next one.
#
# Usage:
#   scripts/run-tasks.sh <slug> [--dir .sdd/tasks] [--agent-cmd "claude -p"] [--auto-commit]
#
# Requirements: bash, the `claude` CLI (or another headless-invokable agent CLI passed via
# --agent-cmd) on PATH, and a `_tasks.md` written by sdd-create-tasks in the canonical shape.

set -euo pipefail

SLUG=""
TASKS_ROOT=".sdd/tasks"
AGENT_CMD="claude -p"
AUTO_COMMIT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir) TASKS_ROOT="$2"; shift 2 ;;
    --agent-cmd) AGENT_CMD="$2"; shift 2 ;;
    --auto-commit) AUTO_COMMIT="1"; shift ;;
    -*) echo "Unknown flag: $1" >&2; exit 1 ;;
    *) SLUG="$1"; shift ;;
  esac
done

if [[ -z "$SLUG" ]]; then
  echo "Usage: $0 <slug> [--dir .sdd/tasks] [--agent-cmd \"claude -p\"] [--auto-commit]" >&2
  exit 1
fi

WORKFLOW_DIR="${TASKS_ROOT}/${SLUG}"
MANIFEST="${WORKFLOW_DIR}/_tasks.md"

if [[ ! -f "$MANIFEST" ]]; then
  echo "No _tasks.md found at ${MANIFEST}" >&2
  exit 1
fi

# --- Parse the canonical _tasks.md frontmatter -----------------------------------------------
# Assumes the exact shape sdd-create-tasks writes:
#   graph:
#     nodes:
#       - id: task_01
#         file: task_01.md
#     edges:
#       - from: task_01
#         to: task_02

mapfile -t NODE_IDS < <(grep -oE '^\s*- id: (task_[0-9]+)' "$MANIFEST" | sed -E 's/.*id: //')
declare -A EDGE_FROM_OF_TO=()   # to -> space-separated list of from ids
for id in "${NODE_IDS[@]}"; do EDGE_FROM_OF_TO["$id"]=""; done

# Read edges as consecutive "from:"/"to:" line pairs.
last_from=""
while IFS= read -r line; do
  if [[ "$line" =~ from:\ (task_[0-9]+) ]]; then
    last_from="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ to:\ (task_[0-9]+) ]]; then
    to="${BASH_REMATCH[1]}"
    EDGE_FROM_OF_TO["$to"]="${EDGE_FROM_OF_TO[$to]:-} ${last_from}"
  fi
done < <(sed -n '/^graph:/,/^---/p' "$MANIFEST")

task_status() {
  local file="$1"
  grep -m1 -oE '^status:\s*\S+' "$file" | awk '{print $2}'
}

echo "Workflow: ${SLUG} (${#NODE_IDS[@]} tasks)"

remaining=("${NODE_IDS[@]}")
while [[ ${#remaining[@]} -gt 0 ]]; do
  wave=()
  still_remaining=()
  for id in "${remaining[@]}"; do
    file="${WORKFLOW_DIR}/${id}.md"
    status="$(task_status "$file" || echo "unknown")"
    if [[ "$status" == "completed" ]]; then
      continue
    fi
    deps_done="true"
    for dep in ${EDGE_FROM_OF_TO[$id]:-}; do
      dep_file="${WORKFLOW_DIR}/${dep}.md"
      dep_status="$(task_status "$dep_file" || echo "unknown")"
      if [[ "$dep_status" != "completed" ]]; then
        deps_done="false"
        break
      fi
    done
    if [[ "$deps_done" == "true" ]]; then
      wave+=("$id")
    else
      still_remaining+=("$id")
    fi
  done

  if [[ ${#wave[@]} -eq 0 ]]; then
    if [[ ${#still_remaining[@]} -gt 0 ]]; then
      echo "Stuck: ${still_remaining[*]} still pending but no ready task — check for a cycle or an unfinished dependency outside this run." >&2
      exit 1
    fi
    break
  fi

  echo "Wave: ${wave[*]}"
  pids=()
  for id in "${wave[@]}"; do
    task_file="${WORKFLOW_DIR}/${id}.md"
    prompt="Use the sdd-execute-task skill to execute ${task_file} end to end, uninterrupted. \
PRD directory: ${WORKFLOW_DIR}. Task graph manifest: ${MANIFEST}. \
Auto-commit: $( [[ -n "$AUTO_COMMIT" ]] && echo enabled || echo disabled )."
    echo "  -> ${id}"
    ( $AGENT_CMD "$prompt" > "${WORKFLOW_DIR}/${id}.run.log" 2>&1 ) &
    pids+=($!)
  done

  fail=0
  for pid in "${pids[@]}"; do
    wait "$pid" || fail=1
  done
  if [[ "$fail" -ne 0 ]]; then
    echo "One or more tasks in this wave exited non-zero — check *.run.log under ${WORKFLOW_DIR}." >&2
    exit 1
  fi

  for id in "${wave[@]}"; do
    file="${WORKFLOW_DIR}/${id}.md"
    status="$(task_status "$file" || echo "unknown")"
    if [[ "$status" != "completed" ]]; then
      echo "${id} finished its run but status is '${status}', not 'completed' — check ${WORKFLOW_DIR}/${id}.run.log." >&2
      exit 1
    fi
  done

  remaining=("${still_remaining[@]}")
done

echo "All tasks completed for ${SLUG}."
