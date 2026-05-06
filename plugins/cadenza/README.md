# cadenza

A 5-phase skill pipeline for technical content creation (blog posts, conference decks, LT slides). Each phase acts as a gate, enforcing think-before-write discipline. Distributed as a Claude Code plugin.

The name **cadenza** comes from the classical-music term for the structured-yet-expressive solo passage in a concerto — a fitting metaphor for a workflow where each phase is a disciplined step, and the final output is the author's own voice.

## Overview

Technical-output creation is broken into 5 phases, each provided as an independent skill. Each skill takes the previous phase's output (aggregated in `./.cadenza/state.md`) as input and appends its own deliverable to the same file.

```
[Plan]   /cadenza:issue-finding         → Issue summary
              ↓
[Design] /cadenza:issue-decomposition   → Storyline + main message
              ↓
[Show]   /cadenza:storyboarding         → Storyboard sheet
              ↓
[Verify] /cadenza:analysis-execution    → Verification result summary
              ↓
[Finish] /cadenza:output-crafting       → Final output (blog/deck/lt)
```

Two additional review skills run after `output-crafting`:

- `/cadenza:output-proofread` — AI-driven exhaustive accuracy + language audit
- `/cadenza:output-review` — author-led review-cycle support

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

The whole workflow uses `./.cadenza/state.md` in the working directory as a shared state file. All workflow artifacts are isolated under `./.cadenza/`.

- Each skill appends / updates its own phase section (`## Phase N: ...`).
- Downstream skills check upstream sections as a precondition.
- Working in a different project directory naturally isolates state.

Final outputs are saved alongside the state file:

- `./.cadenza/output-blog.md`
- `./.cadenza/output-deck.md`
- `./.cadenza/output-lt.md`

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
cadenza/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── CHANGELOG.md
├── skills/
│   ├── issue-finding/SKILL.md
│   ├── issue-decomposition/SKILL.md
│   ├── storyboarding/SKILL.md
│   ├── analysis-execution/SKILL.md
│   ├── output-crafting/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── blog.md
│   │       ├── deck.md
│   │       └── lt.md
│   ├── output-proofread/SKILL.md
│   └── output-review/SKILL.md
└── tests/
    └── README.md
```

## Development workflow

Plugin skills are **copied** at install time into `~/.claude/plugins/cache/claude-atelier/cadenza/<version>/`, not symlinked. Edits to source `SKILL.md` files do not auto-reflect.

To reflect edits:

```bash
claude plugin marketplace update claude-atelier
claude plugin install cadenza@claude-atelier --scope local
```

Then restart Claude Code.

## Inspiration

The phased structure of this workflow draws on the issue-first thinking tradition that has been popularized in Japanese knowledge-work literature — most notably in Kazuto Ataka's *『イシューからはじめよ』* (Eiji Press, 2010). That tradition established the now-common idea that the quality of an output is gated more by the quality of the question being answered than by the effort spent on the answer.

This plugin is **not an implementation of any specific book or framework**, and is not affiliated with or endorsed by any author or publisher. It is an independent reinterpretation that takes the general principle — *narrow the question before writing the answer* — and adapts it to the specific context of technical content creation (blog posts, decks, LTs), expressed as a Claude Code skill pipeline.

For readers interested in the broader thinking-method literature, the Ataka book is one well-known starting point, alongside English-language traditions such as Minto's pyramid principle and the McKinsey "Sky-Rain-Umbrella" framing.

## License

MIT. See [`LICENSE`](../../LICENSE) at the repository root.
