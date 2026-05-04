# Output Crafting Reference: Blog (Qiita / Zenn)

Finishing flow for technical blog output.

## Step A-0: Voice / style mimicry (run this FIRST when the author has prior published articles)

Technical blogs carry a personal voice that readers come to expect. When the author has prior published articles, **mimic that voice rather than producing generic technical writing**.

### When to run this step

Always run if any of the following apply:

- The author asks for the output to match their existing blog style
- The author has a portfolio of prior posts on the same platform (Qiita / Zenn / dev.to / personal blog)
- The output is being published under the author's name on a platform where readers know them

Skip only when the author explicitly asks for generic / neutral writing, or when no prior articles exist.

### Procedure

1. **Locate prior articles**: Ask the author for the directory or list of prior published articles. Common locations: a `zenn` / `qiita` / `articles` directory, a personal blog repo, or links to published URLs.
2. **Sample at least 3 articles**: Prefer ones close in topic / format to the current output. Read them in full (not just headings).
3. **Extract a voice/style profile** along the dimensions below. Write the profile to `./.issue-driven/voice-style-notes.md` in the working directory.
4. **Honor the profile during writing**: Refer back to the profile at every section. When in doubt, copy the cadence of the closest sample article.

### Voice/style profile dimensions to extract

| Dimension | What to capture |
|-----------|-----------------|
| **Frontmatter convention** | Required fields, emoji choice habits, topic-tag patterns |
| **First-person pronoun** | 「私」/「僕」/「we」/ omitted, etc. |
| **Sentence ending** | 「〜です・ます」/ 「〜だ・である」/ casual mix; declarative vs. softened (「〜と思います」「〜かもしれません」) |
| **Tone register** | Formal / friendly-peer / energetic / reserved; ratio of casual interjections |
| **Section structure conventions** | Standard chapters the author always uses (e.g. 「はじめに」「おわりに」「参考」), order, depth of nesting |
| **Opening pattern** | Length of intro, where the repo URL goes, how related past articles are linked, AdventCalendar-style notices |
| **Closing pattern** | How articles wrap (「〜やってみました」「参考になれば幸いです」「教えてください」 vs hard conclusion); whether links/refs go last |
| **Code block convention** | Language tag + filename (e.g. `bash: Terminal`), preface text before code, after-code reaction sentences |
| **Image / diagram convention** | Hosting (CDN URL pattern), caption style, mix of screenshots vs ASCII diagrams vs Mermaid |
| **Table usage frequency** | When tables appear (comparison / metrics / scope), table density |
| **Platform-specific syntax** | Zenn `:::message` / `:::details` / `@[speakerdeck]`; Qiita `:::note` / GHA-style; dev.to liquid tags |
| **Emphasis devices** | Bold density, emoji frequency and placement, list-style preference |
| **Paragraph length** | Short (2–3 lines) vs long; spacing between paragraphs |
| **Hedging / certainty** | How strong the claims are; use of softening like 「みたい」「気がします」「かも」; balance with bold assertions |
| **AI-generation disclosure** | Whether the author always notes "human-written, AI-edited" etc., and where it appears |
| **Asides / interjections** | Personal anecdotes, parenthetical jokes, self-deprecation patterns |

### Output format for `./.issue-driven/voice-style-notes.md`

```markdown
# Voice/Style Profile (extracted from N prior articles)

## Sources analyzed
- <path or URL of article 1> (date, topic)
- <path or URL of article 2> ...

## Profile
- Frontmatter: <observed convention>
- First-person: ...
- Sentence ending: ...
- Tone register: ...
- Section structure: ...
- Opening pattern: ...
- Closing pattern: ...
- Code block convention: ...
- Image / diagram convention: ...
- Table usage: ...
- Platform-specific syntax: ...
- Emphasis devices: ...
- Paragraph length: ...
- Hedging / certainty: ...
- AI-generation disclosure: ...
- Asides / interjections: ...

## Distinctive phrases / cadences (verbatim quotes worth mimicking)
- "..." (from <article>)
- "..." (from <article>)

## Things to AVOID (anti-patterns from samples — usages the author seems to dislike or never employs)
- ...
```

This profile is the **rubric for the writing step**. Match it deliberately, not just by ear.

## Step A-1: Assemble the structure

```
- Title
- TL;DR (main message + target reader + value gained from reading)
- Background / preconditions
- Body (one section per sub-issue)
- Conclusion (restate main message + next step)
- References
```

When a voice/style profile is in use, override the generic structure above with the author's standard chapter structure if it differs (e.g. always 「はじめに」「本題」「おわりに」「参考」 with no separate TL;DR).

## Step A-2: Title design

Generate three candidates using one of these patterns and have the user pick:

- **Question form**: "How should we design X when Y?"
- **Discovery form**: "I tried X and discovered Y"
- **Steps form**: "N steps to achieve X with Y"
- **Comparison form**: "X vs Y: which to choose?"

Avoid clickbait titles ("Shocking", "The truth about X", etc.).

When a voice/style profile is in use, also offer one candidate that matches the author's prior title cadence (e.g. component-stack 「A×B×C で〜する」, demo-driven 「デモ実装で考える X」, problem-driven 「〜で重くなったコストを X で削減する」).

## Step A-3: Write the TL;DR / opening

In the first 3–5 lines, convey:

- The main message (lead with the conclusion)
- The target reader
- What the reader gains by finishing the article

Readers decide whether to read in the opening. Articles that don't convey value upfront don't get read.

When a voice/style profile is in use, conform the opening to the author's habitual opening pattern (e.g. short context paragraph + repo URL + AI-disclosure block, rather than a separate TL;DR section).

## Step A-4: Write each section

Write each sub-issue as one section. Each section:

- Heading expresses the sub-issue (interrogative form is OK)
- 1–2 sentences at the top summarize the section
- Body uses the verification material
- Mini-summary if needed

Sentence-by-sentence, match the voice/style profile: ending pattern, hedging, emphasis density.

## Step A-5: Final check on code and diagrams

- Does the code run as-is on copy-paste?
- Are the diagrams sufficient and necessary in the article's flow?
- Any leaked confidential info (API keys, internal URLs, personal info)?
- **Code block convention check**: language tag, filename, preface, after-code reaction line — all match the profile?
- **Image hosting check**: are images uploaded to the platform's CDN (not absolute external URLs that may rot)?

## Step A-6: Pre-publish checklist

- Does TL;DR / opening alone convey the main message?
- Does reading just the section headings let you trace the storyline?
- Does the target reader have the prerequisite knowledge to follow?
- Tags / categories set (Qiita / Zenn specific)
- **Voice profile compliance**: spot-check 3 random paragraphs against `./.issue-driven/voice-style-notes.md`. If any paragraph reads like generic technical writing, rewrite to match.
