---
name: output-crafting
description: Finish the format-specific final output (blog post, conference deck, LT slides) based on verification results. Triggers on phrases like "write the article", "build the slides", "post to Qiita / Zenn", "upload to SpeakerDeck", "記事を書く", "スライドを作る", "Qiita/Zennに投稿する", "SpeakerDeckにアップする". Corresponds to the "output" phase from Kazuto Ataka's *Issue-Driven*.
---

# Output Crafting

Finish the format-specific final output based on the confirmed storyline and verification results.

## Purpose

The book's final phase. **Be message-driven and shape the output so the reader grasps the essence in the shortest path.** The standard is "what gets through", not "what I want to say".

## Prerequisites

`./.issue-driven/state.md` must contain Phase 1 through Phase 4 sections. If any are missing, instruct the user to invoke the corresponding skill first.

## Format-agnostic finishing principles

Apply regardless of format:

### 1. Message-driven

- Every element (paragraph, slide, diagram) ties to the main message or a sub-issue.
- Have the courage to cut what doesn't tie.
- "Would be nice to have" / "It was interesting" are not adopted.

### 2. Visible structure

- Make the structure explicit so the reader knows where they are.
- Blog: heading hierarchy, table of contents, section-opening summaries.
- Slides: agenda, chapter dividers, current-position indicator.

### 3. Polished title and opening

- The title must convey the issue and the value gained.
- The opening must make "for whom / about what" clear.
- Design so the reader doesn't bounce in the first few seconds.

## Format-specific finishing flow

Based on the intended output format(s) confirmed in Phase 1, read the corresponding reference and follow it:

| Format | Reference |
|--------|-----------|
| `blog` (Qiita / Zenn) | [references/blog.md](./references/blog.md) |
| `deck` (SpeakerDeck) | [references/deck.md](./references/deck.md) |
| `lt` (short-form) | [references/lt.md](./references/lt.md) |

For multiple formats derived from the same material, read each reference and produce a separate file per format (even when reusing material, the final files are distinct artifacts).

## Output format

Generate the final artifact. Use a standard technical-writing tone in the artifact (the conversational persona used in chat does not carry into the final artifact).

### blog

- Markdown file (Qiita / Zenn flavor)
- Save as `./.issue-driven/output-blog.md` in the working directory

### deck

- Structured outline (Markdown) for each slide
- Format suitable for transcription into slide tools
- Save as `./.issue-driven/output-deck.md` in the working directory

### lt

- Pared-down outline of slides
- Draft of promotional posts (SNS, etc.)
- Save as `./.issue-driven/output-lt.md` in the working directory

After generating, append to the end of `./.issue-driven/state.md`:

```markdown
## Phase 5: Output Crafting (✅ Done YYYY-MM-DD)

### Generated outputs
- [ ] blog: ./.issue-driven/output-blog.md
- [ ] deck: ./.issue-driven/output-deck.md
- [ ] lt: ./.issue-driven/output-lt.md

### Pre-publish final check
- [ ] Main message in issue summary matches main message in final output
- [ ] Storyline is preserved in the final output
- [ ] Verification grounds are traceable for the reader
```

## Anti-patterns (always avoid)

- **Including all verification results**: Don't pack in material beyond what the storyboard scope decided.
- **Deciding the title last as an afterthought**: The title is the entry point. Spend time on the title-design step in the format-specific reference.
- **Composition that dilutes the main message**: Topics tend to multiply during finishing. Always reconfirm the tie to the main message.
- **Ignoring format conventions**: Match the reader profile and reading habits of Qiita / Zenn / SpeakerDeck respectively.

## Upstream-return signals

Return upstream if any of the following apply:

- Material is insufficient at finishing time → `issue-driven:analysis-execution` for additional verification.
- The link between main message and sub-issues feels weak → `issue-driven:issue-decomposition` to redesign.
- After finishing, "what am I actually saying?" is blurry → `issue-driven:issue-finding` to redefine the issue.

## Workflow complete

When this phase is done, the workflow that started at `issue-driven:issue-finding` is complete. Before publishing the final output, always run the pre-publish final check above.
