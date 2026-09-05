# Task File Template

Use this structure for every individual task file. The file must start with YAML frontmatter containing the parseable metadata. Frontmatter keys and enum values (`status`, `type`, `complexity` and their values) MUST stay in English — the pipeline scripts match them literally. All prose, headers, and the `<critical>`/`<requirements>` block content MUST be written in Portuguese (pt-BR), using the exact section headers below, translated, as shown.

```markdown
---
status: pending
title: [Título da tarefa]
type: [one of frontend, backend, docs, test, infra, refactor, chore, bugfix, or a project-specific [tasks].types override]
complexity: [low, medium, high, critical]
---

# Tarefa N: [Título]

## Visão Geral
[2-3 sentences: what slice of the system this task delivers and why it matters in the context of the project.]

<critical>
- SEMPRE LEIA o PRD, o TechSpec e seus catálogos (`_user_stories.md`, `_tests.md`) antes de começar
- CONSULTE O TECHSPEC para detalhes de implementação — não duplique aqui
- FOQUE NO "O QUÊ" — descreva o que precisa ser feito, não como
- MINIMIZE CÓDIGO — mostre código apenas para ilustrar a estrutura atual ou pontos problemáticos
- TESTES OBRIGATÓRIOS — implemente todo caso de teste atribuído em ## Testes
</critical>

<requirements>
- [Requirement 1 — specific technical requirement using MUST/SHOULD language]
- [Requirement 2 — e.g., "MUST authenticate users via JWT tokens"]
- [Requirement 3]
</requirements>

## Subtarefas
- [ ] N.1 [Subtask description — WHAT to accomplish]
- [ ] N.2 [Subtask description]
- [ ] N.3 [Subtask description]

## Detalhes de Implementação
[File paths to create or modify and integration points.
Reference the TechSpec implementation section for code patterns and interface designs.]

### Arquivos Relevantes
- `path/to/file` — [brief reason this file is relevant]

### Arquivos Dependentes
- `path/to/dependency` — [brief reason this file is affected]

### ADRs Relacionadas
- [ADR-NNN: Título](../adrs/adr-NNN.md) — Relevance to this task

## Entregáveis
- [Concrete output 1]
- [Concrete output 2]
- Every test case assigned in `## Testes` implemented and passing **(OBRIGATÓRIO)**

## Testes

Cases assigned from `_tests.md`, the test contract — read each ID's full definition there before writing tests.

- [ ] UT-NNN, UT-NNN, UT-NNN — [component/behavior these cover]
- [ ] IT-NNN — [flow these cover]
- [ ] E2E-NNN — [journey this covers]

[When the workflow has no `_tests.md`, list concrete cases inline instead — exact input, condition, and expected result per case.]

## Critérios de Sucesso
- Every assigned test case implemented and passing
- [Measurable outcome 1]
- [Measurable outcome 2]
```

## Guidelines

- Write one subtask per coherent unit of work — WHAT to accomplish, not HOW; robust tasks typically carry 5-12.
- Sizing, independence, and test-assignment rules live in SKILL.md; the `<critical>` block above ships verbatim (in Portuguese) in every generated task file.
