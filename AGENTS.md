# AGENTS.md template

Copy the relevant parts of this file into your own project's `CLAUDE.md`/`AGENTS.md` once you've
installed the `skills/` and `agents/` from this package. Replace the bracketed placeholders.

---

## Spec-Driven Development Pipeline

This project uses the SDD skill pipeline for any non-trivial change. See `skills/sdd/SKILL.md`
for the full reference.

- **MUST** run the project's full verification command (`[e.g. make verify / npm run verify]`)
  before any completion claim — use the `sdd-final-verify` skill, no exceptions.
- **MUST** follow the pipeline in order for new features: `sdd-idea` (optional) -> `sdd-create-prd`
  -> `sdd-create-techspec` -> `sdd-create-tasks` -> `sdd-execute-task` -> `sdd-review` ->
  `sdd-fix-reviews`.
- **NEVER** invoke `sdd-execute-task` on a task whose `_tasks.md` dependencies haven't completed.
- **NEVER** hand-edit task file frontmatter without re-checking
  `skills/sdd-create-tasks/references/task-context-schema.md`'s Manual Validation checklist
  afterward.
- Planning artifacts live under `.docs/tasks/<slug>/`. Do not hand-roll a different location.

## Language

- **MUST** write all generated documentation (PRDs, TechSpecs, tasks, ADRs, user stories, test contracts, review issues) and all code comments in Portuguese (pt-BR), 100% — no mixed-language prose.
- **NEVER** translate identifiers (variable/function/class/file names), frontmatter keys and enum values (`status`, `type`, `complexity`, `severity`, etc.), commands, or third-party code — only prose and comments change language.

## Build & Verification

```bash
[fill in: format command]
[fill in: lint command]
[fill in: test command]
[fill in: build command]
[fill in: single gate command that runs all of the above, if one exists]
```

## Coding Style

[fill in: project-specific conventions — error handling, logging, concurrency discipline, etc.
Compozy's own CLAUDE.md is a reasonable model for a Go project; adapt per language.]

## Git Commands Restriction

- **NEVER** run `git restore`, `git checkout`, `git reset`, `git clean`, `git rm`, or any other
  destructive git command **without explicit user permission**.
- If the worktree contains unexpected edits, read them and work around them; do not revert them.
