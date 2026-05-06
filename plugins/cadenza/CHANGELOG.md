# Changelog

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
