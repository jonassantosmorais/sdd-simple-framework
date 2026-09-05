# User Stories Template

Structure for `_user_stories.md` — the canonical user-story catalog that ships alongside `_prd.md`. Every story, acceptance criterion, and edge case for the feature lives here and only here; the PRD's User Stories section is an index into this file. Downstream consumers depend on it: `_techspec.md` maps stories to components, `_tests.md` builds its coverage matrix on story IDs, and review rounds validate the implementation against the acceptance criteria recorded here.

## ID Rules

- Stories are `US-NNN` (zero-padded, sequential). Acceptance criteria and edge cases are numbered within their story and referenced externally as `US-NNN.AC-N` and `US-NNN.EC-N`.
- IDs are permanent once written: downstream documents reference them, so never renumber or reuse an ID. Retire a dropped story by marking it `(withdrawn)` in the index instead of deleting the number.

## Document Skeleton

The generated document's headers and prose MUST be written in Portuguese (pt-BR), following this skeleton (already translated):

```markdown
# Histórias de Usuário: [Nome da Funcionalidade]

Catálogo canônico de comportamento para [funcionalidade]. Complementa `_prd.md`; consumido por
`_techspec.md` (mapeamento de componentes) e `_tests.md` (matriz de cobertura).

## Personas

- **[Nome da persona]** — [quem é, seu contexto, o que precisa desta funcionalidade]

## Índice de Histórias

| ID     | Área da Funcionalidade | Persona   | História                  |
|--------|-------------------------|-----------|----------------------------|
| US-001 | [área]                  | [persona] | [resumo da história em uma linha] |

## [Área da Funcionalidade 1]

### US-001: [Título curto]

**Como** [persona], **eu quero** [capacidade], **para que** [resultado].

Critérios de aceite:

- AC-1: Dado [contexto inicial], quando [ação], então [resultado observável].
- AC-2: Dado [contexto], quando [ação], então [resultado observável].

Casos extremos:

- EC-1: [condição] → [comportamento esperado observado pelo usuário].
- EC-2: [condição] → [comportamento esperado].
```

## Edge-Case Sweep

Probe every story against every class below and record each finding as an `EC` entry with its expected behavior. Skip a class for a story only after actually probing it — most "cannot apply" verdicts turn out wrong, and an unswept class is how unhandled behavior reaches production.

| Class | Probe |
| --- | --- |
| Invalid input | Malformed, wrong type, out of range, unparseable, hostile. |
| Empty / missing | Empty collections, blank strings, absent optional data, first-run state. |
| Limits | Maximum sizes, quotas, truncation, pagination boundaries, rate limits. |
| Permissions | Unauthorized user, expired session, insufficient role, cross-tenant access. |
| Concurrency | Same action twice in flight, two actors on one resource, stale reads. |
| Interruption | Cancel mid-flow, connection loss, process restart, partial completion. |
| Repetition | Retry after success, duplicate submission, replay — is the action idempotent? |
| Ordering | Steps out of order, prerequisite skipped, back-navigation, deep links. |
| State transitions | Action on deleted/closed/archived entities, invalid state jumps. |
| Scale | Behavior at zero items, at typical volume, and at 100× typical volume. |

## Writing Rules

- Describe behavior the user observes, never implementation ("sees the last saved draft", not "reads from the drafts table").
- One story per capability. Splitting keeps acceptance criteria testable; merging stories to shorten the catalog hides behavior.
- Every AC must be checkable against the shipped product — someone can mark it true or false by using the feature.
- Every EC states condition **and** expected behavior ("upload over the size limit → rejected with a size-limit message", never just "large uploads").
- Give secondary personas (admin, operator, integrator) their own stories — most unhandled edge cases live in their flows.
