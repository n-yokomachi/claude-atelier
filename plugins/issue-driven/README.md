# issue-driven

A 5-phase skill pipeline that applies the thinking process from Kazuto Ataka's *Issue-Driven* (『イシューからはじめよ』) to technical content creation (blog posts, conference decks, LT slides). Distributed as a Claude Code plugin.

## Overview

Technical-output creation is broken into 5 phases, each provided as an independent skill. Each skill takes the previous phase's output (aggregated in `./issue-driven-state.md`) as input and appends its own deliverable to the same file.

```
[Plan]   /issue-driven:issue-finding         → Issue summary
              ↓
[Design] /issue-driven:issue-decomposition   → Storyline + main message
              ↓
[Show]   /issue-driven:storyboarding         → Storyboard sheet
              ↓
[Verify] /issue-driven:analysis-execution    → Verification result summary
              ↓
[Finish] /issue-driven:output-crafting       → Final output (blog/deck/lt)
```

## Skill roles

| Phase | Skill | Role | Gate function |
|-------|-------|------|--------------|
| 1. Plan | `issue-finding` | Identify "what question is worth answering" | Block topics without primary-source basis or comprehensive-survey topics |
| 2. Design | `issue-decomposition` | Decompose into sub-issues and design the storyline | Block writing without structure |
| 3. Show | `storyboarding` | Design how each sub-issue is shown | Block divergent verification |
| 4. Verify | `analysis-execution` | Implement / measure / draw per the storyboard | Block exhaustive grinding |
| 5. Finish | `output-crafting` | Format-specific finishing | Enforce message-driven output |

## Usage patterns

### Pattern 1: Sequential (recommended)

Run from planning to finishing for a new piece. Each skill, on completion, asks the user "proceed to next phase?" and invokes the next skill via the Skill tool on confirmation.

### Pattern 2: Partial execution

If planning is already done, start from a downstream phase. The downstream skill checks the state file for the prerequisite phase's section and instructs the user to back-fill if missing.

### Pattern 3: Upstream return

If a downstream phase reveals the upstream premise has collapsed (e.g., verification result diverges from hypothesis), don't hesitate to return upstream. Each skill's "Upstream-return signals" section lists the criteria.

## State management

The whole workflow uses `./issue-driven-state.md` in the working directory as a shared state file.

- Each skill appends / updates its own phase section (`## Phase N: ...`).
- Downstream skills check upstream sections as a precondition.
- Working in a different project directory naturally isolates state.

Final outputs are saved as separate files in the same directory:

- `./output-blog.md`
- `./output-deck.md`
- `./output-lt.md`

## Design notes

- **Each skill is a gate**: Each holds a precondition that must be satisfied before downstream work begins.
- **Anti-patterns are explicit**: Each phase calls out the failure modes it tends to fall into and instructs to avoid them.
- **Format-specific optimization**: Blog / deck / LT each have their own conventions (the `output-crafting` flows are split into `references/{blog,deck,lt}.md`).
- **Discipline of narrowing**: Every phase explicitly lists "what NOT to do".
- **Handoff via state file**: Removes manual copy-paste from the user.

## Applicable surfaces

- Qiita / Zenn or similar technical blogs
- SpeakerDeck-style conference decks
- LT / short-form slides
- Combinations of the above (one source material → multiple formats)

## Directory layout

```
issue-driven/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── CHANGELOG.md
├── skills/
│   ├── issue-finding/SKILL.md
│   ├── issue-decomposition/SKILL.md
│   ├── storyboarding/SKILL.md
│   ├── analysis-execution/SKILL.md
│   └── output-crafting/
│       ├── SKILL.md
│       └── references/
│           ├── blog.md
│           ├── deck.md
│           └── lt.md
└── tests/
    └── README.md
```

## Development workflow

Plugin skills are **copied** at install time into `~/.claude/plugins/cache/claude-atelier/issue-driven/<version>/`, not symlinked. Edits to source `SKILL.md` files do not auto-reflect.

To reflect edits:

```bash
claude plugin marketplace update claude-atelier
claude plugin install issue-driven@claude-atelier --scope local
```

Then restart Claude Code.

## Source

The conceptual basis is Kazuto Ataka's *『イシューからはじめよ — 知的生産の「シンプルな本質」』* (Eiji Press). This workflow is an adaptation of that framework to the context of technical content creation.
