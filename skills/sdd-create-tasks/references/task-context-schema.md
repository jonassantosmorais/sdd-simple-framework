# Task Metadata Schemas

Task metadata is plain YAML frontmatter, read directly by the agent running each skill — there is
no compiled parser behind it. Keep it exactly to this shape so every skill in the pipeline can
read it reliably.

## `_tasks.md` Graph Manifest

The `_tasks.md` file owns dependency relationships for the whole task suite. It must start with frontmatter shaped like:

```yaml
schema_version: "sdd.tasks/v1"
workflow: feature-name
graph:
  nodes:
    - id: task_01
      file: task_01.md
  edges:
    - from: task_01
      to: task_02
```

Graph rules:

- `schema_version` MUST be `sdd.tasks/v1`.
- `workflow` MUST match the feature/task directory name.
- `graph.nodes` MUST include every generated task exactly once.
- Node `id` values MUST be canonical `task_NN` identities.
- Node `file` values MUST match the node id, e.g. `task_01.md`.
- `graph.edges` stores dependency relationships only. Each edge means `from` must finish before `to` can start.
- Use `edges: []` when there are no dependencies.
- The graph MUST be acyclic.

## Individual Task Frontmatter

Individual task files own task metadata only. They do not own graph topology.

### Required Fields

- `status`: Task lifecycle state.
- `title`: Human-readable task title. It must match the first H1 in the task body.
- `type`: Allowed work type slug. Use `[tasks].types` from `.docs/config.toml` when configured; otherwise use the built-in defaults `frontend`, `backend`, `docs`, `test`, `infra`, `refactor`, `chore`, `bugfix`.
- `complexity`: Risk rating. Must be one of: `low`, `medium`, `high`, `critical`. Complexity rates implementation risk (regression surface, concurrency, cross-task coordination), not size — a large but well-specified task can be `low`, and a high rating is never a reason to split the task.

Do not include `dependencies` in individual task frontmatter. Dependencies belong only in `_tasks.md` under `graph.edges`.

## Status Values

Valid `status` values:

- `pending` - task has not been started.
- `in_progress` - task is currently being worked on.
- `completed` - task is finished and verified.

## File Naming

Task files must match the pattern `task_\d+\.md` with zero-padded numbers:
- `task_01.md`, `task_02.md`, `task_10.md`, `task_99.md`

The leading underscore prefix is reserved for meta documents:
- `_prd.md` - Product Requirements Document
- `_user_stories.md` - User-story catalog (companion to the PRD)
- `_techspec.md` - Technical Specification
- `_tests.md` - Test contract (companion to the TechSpec)
- `_tasks.md` - Task graph manifest

## Manual Validation

There is no `tasks validate` command in this framework — the agent that generates or edits
`_tasks.md`/`task_NN.md` is responsible for checking these invariants itself before handing off
(see `sdd-create-tasks` SKILL.md step 8):

- Every file matches `task_\d+\.md` and starts with valid YAML frontmatter.
- `status`, `title`, `type`, and `complexity` are all present and `type`/`complexity` use only
  the allowed values.
- `title` matches the first H1 in the file body.
- `_tasks.md` frontmatter parses, `schema_version` is `sdd.tasks/v1`, `graph.nodes` lists every
  task file exactly once, and `graph.edges` references only ids that exist in `graph.nodes`.
- The dependency graph is acyclic (no `task_NN` reachable from itself by following edges).
