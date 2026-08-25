# Review Issue Template

Canonical format for `issue_NNN.md` files inside a `reviews-NNN/` review round directory.

```
---
provider: manual
pr:
round: <N>
round_created_at: <UTC timestamp in RFC3339 format>
status: pending
file: path/to/file.go
line: 42
severity: high
author: sdd-review
provider_ref:
---

# Issue NNN: <title>

## Review Comment

<detailed review body>

## Triage

- Decision: `UNREVIEWED`
- Notes:
```

Field rules:

- `provider`: always `manual` for review rounds produced by `sdd-review`.
- `pr`: empty unless the user supplies a PR number for reference.
- `round`: matches the `reviews-NNN` directory number as a plain integer (not zero-padded).
- `round_created_at`: identical RFC3339 timestamp across every issue file in the same round.
- `status`: `pending` at creation; `sdd-fix-reviews` transitions it to `valid`/`invalid`, then `resolved`.
- `file` / `line`: repository-relative path and best-known line number.
- `severity`: exactly one of `critical`, `high`, `medium`, `low`.
- `author`: the tool or agent that generated the issue (`sdd-review` for this pipeline).
- `provider_ref`: empty for manual reviews; reserved for future external-provider integrations.
