# Changelog

## [0.3.0] - 2026-05-07

### Changed

- **`output-crafting` now produces a single, format-agnostic Markdown file** (`./.cadenza/output.md`) instead of multiple format-specific files. Platform-specific finishing (Zenn frontmatter, SpeakerDeck/Marp directives, LT-specific compression) is now downstream of the cadenza workflow.
- **`issue-finding`**: removed Step 6 (intended output format selection) — the workflow is now format-agnostic at the planning phase.
- **`issue-decomposition`**: storyline pattern recommendation no longer references intended output format.
- **`storyboarding`**: Step 3 reframed from blog/deck/lt to dominant output style (long-form prose / slide presentation / short-form). The platform-specific finishing notes have been removed.
- **`output-proofread`** / **`output-review`**: path references updated from `./.cadenza/output-blog.md` etc. to `./.cadenza/output.md`.
- This repository is now self-contained as a Claude Code marketplace. A top-level `.claude-plugin/marketplace.json` allows direct install via `claude plugin marketplace add github.com/n-yokomachi/cadenza`.
- Added top-level `LICENSE` (MIT) and OSS-facing `README.md`.

### Removed

- `skills/output-crafting/references/{blog,deck,lt}.md`: format-specific finishing references. Equivalent functionality moved out of the OSS plugin.

## [0.2.0] - 2026-05-06

### Changed

- **Renamed plugin from `issue-driven` to `cadenza`** to make the project's identity independent of any specific book or framework, and to reframe the README around "inspiration from issue-first thinking traditions" rather than direct attribution.
- Workflow state and output artifacts now live under `./.cadenza/` (previously `./.issue-driven/`). The directory rename matches the new plugin name.
- Skill descriptions no longer reference any specific author or book; they describe each phase's role in the cadenza workflow directly.
- README rewritten with an `Inspiration` section that frames the phased structure as a reinterpretation of issue-first thinking, with no claim of implementation or endorsement.
- License clarified as MIT at the repository root.

### Added

- `output-proofread` skill (AI-driven exhaustive accuracy + language audit).
- `output-review` skill (author-led review-cycle support).

## [0.1.0] - 2026-05-02

### Added

- Initial release.
- Five skills covering the full pipeline: `issue-finding`, `issue-decomposition`, `storyboarding`, `analysis-execution`, `output-crafting`.
- Shared state file convention for cross-skill handoff.
- Format-specific references for `output-crafting` (`blog.md`, `deck.md`, `lt.md`).
- Auto-chained transition: each skill prompts the user to proceed to the next phase and invokes the next skill via the Skill tool on confirmation.
- "Upstream-return signal" section in every skill for principled retreat to upstream phases.
- All skill content authored in English (mixed-language descriptions retain Japanese trigger phrases for natural Japanese-speaking user invocation).
