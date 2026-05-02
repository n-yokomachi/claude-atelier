---
name: storyboarding
description: Design how each sub-issue in the storyline will be shown (code snippets, diagrams, benchmarks, comparison tables, etc.). Triggers on phrases like "how should I include diagrams", "what should the code examples look like", "design the section visuals", "図をどう入れるか", "コード例はどうするか", "セクションごとの見せ方を決めたい". Corresponds to the "storyboarding" phase from Kazuto Ataka's *Issue-Driven*. Acts as a gate before any analysis or implementation begins.
---

# Storyboarding

Design "what to show" for each sub-issue in the storyline. Before any analysis or implementation, build the goal image (final form) as a storyboard.

## Purpose

A core concept from the book: **work backwards from the final output**. By creating the completion image first:

- Minimize rework in the analysis / implementation phase
- Concentrate effort on exactly the verification that's needed
- Ensure persuasive grounds are gathered without gaps

## Prerequisites

The `## Phase 2: Issue Decomposition` section must exist in `./issue-driven-state.md`. If not, instruct the user to run `issue-driven:issue-decomposition` first.

## Execution flow

### Step 1: Choose how to show each sub-issue

For each sub-issue, pick the most persuasive form. Options for technical output:

| Form | Best for | Cautions |
|------|----------|----------|
| Code snippet | Implementation, API usage, syntactic differences | Show working code, keep minimal |
| Architecture diagram | System structure, data flow, responsibility separation | Match abstraction levels |
| Sequence diagram | Time-ordered behavior, API call order | Limit involved elements |
| Benchmark numbers / charts | Quantitative perf / cost comparison | Specify measurement conditions |
| Comparison table | Multi-option evaluation, before/after | Align axes with reader's interests |
| Screenshot | UI, logs, execution results | Mask confidential info |
| ASCII / Mermaid | Lightweight structural diagrams | Switch to images if too complex |
| Failure log / error reproduction | Sharing pitfalls | Specify reproduction conditions |

### Step 2: Fix visualization / data specs

For each chosen form, fix the concrete spec:

- **Code**: Language, dependency versions, executability, approximate line count
- **Diagram**: Elements included / excluded, labels, emphasized parts
- **Numbers**: Measurement target, conditions, sample size, comparison target
- **Table**: Row / column items, number of evaluation axes

At this stage, **do not implement or measure yet**. Only design what to show.

### Step 3: Format-specific optimization

Adjust the storyboard based on the intended output format(s) confirmed in Phase 1.

#### blog (Qiita / Zenn)

- Section = sub-issue mapping for headings
- Code blocks should run as-is (copy-paste runnable)
- Diagrams support the prose (prose is primary)
- Aim for one main visual per section

#### deck (SpeakerDeck)

- One slide, one message
- Storyboard per slide (title + visual + caption)
- Minimal text; verbal narration is the supplement
- Include agenda and transition slides in the storyboard

#### lt (short-form)

- Slide count derived from time budget (rule of thumb: 30s–1min per slide)
- Main-message slide always stands alone
- Code is image-based (IDE-style screenshot, Carbon, etc.)
- Cut what can be cut (impact over coverage)

For multiple formats derived from the same material, build separate storyboards per format (even if much overlaps, separate them explicitly).

### Step 4: Build the storyboard sheet

For each sub-issue, list:

```
[Sub-issue N]
├ Form: [code / diagram / number / table / etc.]
├ Spec: [concrete content]
├ Required verification: [what to implement / measure to produce this visual]
└ Skipped verification: [what's NOT needed for this visual, to be omitted in analysis]
```

Explicitly listing "skipped verification" is the heart of this phase. Without it, the analysis phase devolves into comprehensive grinding.

### Step 5: Storyboard review

Check the assembled storyboard:

- Lined up, do the storyboards make the storyline visually traceable?
- Are the "decisive" visuals supporting the main message included?
- Does each visual answer "So what?" (not just decoration)?
- Are any storyboards too costly to produce? (If so, can they be replaced with a different form?)

## Output format

Append the confirmed content to `./issue-driven-state.md`:

```markdown
## Phase 3: Storyboarding (✅ Done YYYY-MM-DD)

### Intended output format(s)
[One or more of: blog, deck, lt]

### Storyboard list

#### Sub-issue 1: [name]
- **Form**: [chosen form]
- **Spec**: [concrete content]
- **Required verification**: [what to implement / measure]
- **Skipped verification**: [what to omit]

#### Sub-issue 2: [name]
...

### Total verification work (handed off to next phase)
[Combined list of all required verifications]

### Cut verification
[List of what was deliberately not included]
```

## Anti-patterns (always avoid)

- **Moving to analysis without deciding the form**: If "what to show" isn't decided, the analysis phase diverges.
- **Decorative visuals**: No "filler" visuals. Every visual must contribute to the argument.
- **Comprehensive verification plan**: "Just measure all combinations to be safe" is the dog's path. Verify only what the storyboard demands.
- **Treating the storyboard as final, then improvising during implementation**: If you change something, return to the storyboard and update it.

## Upstream-return signals

Return upstream if any of the following apply:

- No matter the form, no decisive visual emerges to support the main message → storyline is weak (`issue-driven:issue-decomposition`).
- Required verification is so vast it isn't realistically buildable → issue narrowing was insufficient (`issue-driven:issue-finding`).

## Transition to next phase

Once `./issue-driven-state.md` is written, ask the user:

> ✅ Phase 3 (Storyboarding) is complete. Proceed to `analysis-execution` (verification work)?

- **Proceed**: Invoke `issue-driven:analysis-execution` via the Skill tool.
- **Hold**: Wait for revision instructions.
- **Return upstream**: Invoke the corresponding upstream skill if a return signal applies.
