# Idea Template

Use this template to structure every idea in `.docs/tasks/<slug>/_idea.md`. Fill each section based on research and brainstorming outcomes. Leave placeholder guidance in sections where information is insufficient and note them in Open Questions. The generated document's headers, tables, and prose MUST be written in Portuguese (pt-BR) — use the exact section headers below, translated, as shown.

## Visão Geral

High-level overview of the feature idea. Describe:

- What problem it solves
- Who it is for
- Why it is valuable
- How ambitious the V1 should be

## Problema

The real problem the user or business faces:

- 2-4 paragraphs with concrete scenarios and data
- Why the current solution is insufficient
- Include market data as a "### Dados de Mercado" subsection when available from research

## Funcionalidades Principais

Main features grouped by priority:

| #   | Funcionalidade | Prioridade              | Descrição                                                    |
| --- | -------------- | ------------------------ | ------------------------------------------------------------ |
| F1  | {Nome}         | {Crítica/Alta/Média}     | {Concise description of the feature with expected behavior}  |
| F2  | {Nome}         | {Crítica/Alta/Média}     | {Description}                                                |

Rules:

- Number features with a 2-letter prefix (e.g., F1, F2)
- Order by priority (Crítica > Alta > Média)
- Each feature described in 1-2 lines with concrete behavior
- Minimum 3 features, maximum 10

## KPIs

Quantifiable measures of success from business analysis:

| KPI                   | Meta                       | Como Medir                     |
| --------------------- | --------------------------- | -------------------------------- |
| {Observable metric}   | {Numeric value with unit}   | {Concrete measurement method}    |

Rules:

- Minimum 3 KPIs, maximum 6
- Targets must be numeric and measurable (e.g., "> 30%", "< 200ms", "-80%")
- "Como Medir" must be concrete and implementable

## Avaliação da Funcionalidade

Score from the business analysis phase:

| Critério              | Pergunta                                             | Pontuação |
| ---------------------- | ----------------------------------------------------- | --------- |
| **Impacto**            | How much more valuable does this make the product?    | {score}   |
| **Alcance**            | What % of users would this affect?                    | {score}   |
| **Frequência**         | How often would users encounter this value?           | {score}   |
| **Diferenciação**      | Does this set us apart or just match competitors?      | {score}   |
| **Defensabilidade**    | Is this easy to copy or does it compound over time?    | {score}   |
| **Viabilidade**        | Can we actually build this?                            | {score}   |

Tipo de alavancagem: {Vitória Rápida / Aposta Estratégica / Funcionalidade Composta}

## Percepções do Conselho

Key findings from the multi-advisor debate:

- **Abordagem recomendada:** {summary of the council recommendation}
- **Principais trade-offs:** {list of trade-offs surfaced}
- **Riscos identificados:** {list of risks and mitigations}
- **Meta estendida (V2+):** {optional more ambitious version for later}

## Fora de Escopo (V1)

Explicitly excluded features and boundaries:

- **{Excluded feature}** — {short justification for why it is out of V1 scope}

Rules:

- Minimum 3 exclusions
- Each item must have a justification
- Helps prevent scope creep and align expectations

## Registros de Decisão de Arquitetura

ADRs documenting key decisions made during idea creation:

- [ADR-NNN: Título](adrs/adr-NNN.md) — One-line summary of the decision

## Questões Abertas

Remaining items that need clarification:

- Unclear requirements
- Edge cases requiring stakeholder input
- Dependencies on decisions not yet made

## Seções Opcionais

Include these between mandatory sections when the content justifies it:

### Resumo / Diferencial

Short paragraph describing the competitive angle of the proposed solution. Use when the feature has a clear differentiator vs the market.

### Integração com Funcionalidades Existentes

| Ponto de Integração         | Como                              |
| ---------------------------- | ---------------------------------- |
| {Existing feature/module}   | {How the new feature connects}     |

Use when the feature modifies or extends already implemented features.

### Subfuncionalidades

- **{Name}** — {Brief description of the sub-scope}

Use when the feature is large enough to be split into multiple ideas or PRDs.

### Estimativa de Custo

| Tipo        | Volume             | Custo Estimado          |
| ----------- | ------------------ | ------------------------ |
| {Resource}  | {Expected volume}  | {Monthly/annual cost}    |

Use for features with relevant operational costs (paid APIs, cloud storage, etc.).
