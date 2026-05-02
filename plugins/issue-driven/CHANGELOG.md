# Changelog

## [0.1.0] - 2026-05-02

### Added

- Initial release of the `issue-driven` plugin.
- Five skills covering the full pipeline: `issue-finding`, `issue-decomposition`, `storyboarding`, `analysis-execution`, `output-crafting`.
- Shared state file convention (`./issue-driven-state.md`) for cross-skill handoff.
- Format-specific references for `output-crafting` (`blog.md`, `deck.md`, `lt.md`).
- Auto-chained transition: each skill prompts the user to proceed to the next phase and invokes the next skill via the Skill tool on confirmation.
- "Upstream-return signal" section in every skill (not only `analysis-execution`) for principled retreat to upstream phases.
- All skill content authored in English (mixed-language descriptions retain Japanese trigger phrases for natural Japanese-speaking user invocation).
