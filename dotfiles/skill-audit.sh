#!/usr/bin/env bash
# Skill audit script — invoked from SessionEnd hook.
#
# Reads hook input from stdin (per Claude Code hook spec), then:
#   1. Appends a marker to ~/.claude/logs/session-end.jsonl
#   2. Spawns a detached background `claude --print` agent that:
#      a. Audits the just-ended session transcript for skill usage quality
#      b. Writes a Markdown report to ~/.claude/logs/skill-audit/
#      c. If actionable findings exist, opens a PR in claude-atelier
#
# Background spawn prevents the hook from blocking session shutdown.
# Recursion guard: SKILL_AUDIT_INSIDE env var prevents the audit agent's
# own SessionEnd from spawning another audit (since we don't use --bare,
# hooks would otherwise still fire). --bare can't be used because it
# disables OAuth keychain reads, which the user's Pro/Max auth depends on.

set -uo pipefail

# Recursion guard: skip if we're being called from within an audit session
if [ -n "${SKILL_AUDIT_INSIDE:-}" ]; then
  exit 0
fi

LOGS_DIR="$HOME/.claude/logs"
AUDIT_DIR="$LOGS_DIR/skill-audit"
mkdir -p "$AUDIT_DIR"

# Read hook input from stdin
INPUT="$(cat)"

# Always log a marker (lightweight, useful for retrospective analysis)
printf '{"ts":"%s","cwd":"%s","input":%s}\n' \
  "$(date -Iseconds)" "$(pwd)" "$INPUT" \
  >> "$LOGS_DIR/session-end.jsonl"

# Extract session_id (no jq dependency — grep + sed)
SESSION_ID="$(echo "$INPUT" \
  | grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | sed 's/.*"\([^"]*\)"$/\1/' | head -1)"
[ -z "$SESSION_ID" ] && SESSION_ID="unknown"

# Resolve claude-atelier repo location via this script's symlink target.
# This script lives at ~/.claude/skill-audit.sh as a symlink to
# claude-atelier/dotfiles/skill-audit.sh. readlink -f resolves to the
# real path so we can derive the repo root.
SCRIPT_REAL="$(readlink -f "$0" 2>/dev/null || echo "$0")"
DOTFILES_DIR="$(dirname "$SCRIPT_REAL")"
ATELIER_REPO="$(dirname "$DOTFILES_DIR")"

TS="$(date +%Y%m%d-%H%M%S)"
REPORT="$AUDIT_DIR/${TS}-${SESSION_ID:0:8}.md"

# Background audit — fully detached so the hook returns immediately.
# SKILL_AUDIT_INSIDE=1 propagates to the spawned claude → its own SessionEnd
# hook → this script → guard at top → early exit. No recursion.
(
  export SKILL_AUDIT_INSIDE=1
  nohup claude --print --model claude-sonnet-4-6 \
    "You are auditing a Claude Code session that just ended. Output in plain neutral English (do not adopt any persona from CLAUDE.md). Be thorough but conservative — false positives waste maintainer attention.

## Inputs

- Session ID: ${SESSION_ID}
- claude-atelier repo: ${ATELIER_REPO}
- Transcript: search ~/.claude/projects/ for ${SESSION_ID}.jsonl (typical layout: ~/.claude/projects/<encoded-cwd>/${SESSION_ID}.jsonl)

## Available custom skills (compare usage against these)

- Flat skills: ${ATELIER_REPO}/skills/
- Plugin skills: ${ATELIER_REPO}/plugins/

Read each SKILL.md to know what's available before judging triggering quality.

## Audit criteria

For the just-ended session, identify:

1. **Skills used** — Skill tool invocations or /slash-commands. List them.
2. **Triggering quality** — for each available custom skill (not just used ones):
   - Should it have triggered but didn't? (under-trigger)
   - Did it trigger when it shouldn't? (over-trigger)
   - Was the trigger correct? (good)
3. **Manual workarounds** — did the user (or assistant) do work manually that an existing skill would have automated?
4. **Inefficient patterns** — repeated tool calls, unclear phase handoffs, redundant searches, oversized context loads.

## Output

Write a Markdown report to: ${REPORT}

Required sections:
- ## Summary (1-2 sentences)
- ## Skills used
- ## Findings (one bullet per concrete observation, with transcript evidence — quote a line or describe the location)
- ## Improvement candidates (only include if actionable; each must specify the target file and the proposed change)

If no actionable findings exist, the entire report can be just: \`No actionable findings.\`

## Auto-PR (only if ≥2 concrete improvement candidates)

After writing the report, count the items in the 'Improvement candidates' section.

If there are **2 or more** concrete candidates AND each can be implemented as a small, low-risk edit (description tweak, anti-pattern addition, missing section, reference split — NOT structural refactors or skill renames), then:

1. cd into ${ATELIER_REPO}
2. Create a branch: \`skill-audit-${TS}\`
3. Apply the proposed edits to the relevant SKILL.md files
4. Commit with a clear message describing the changes
5. \`git push -u origin <branch>\`
6. \`gh pr create --title \"skill audit ${TS}: <N> proposals\" --body-file ${REPORT}\` (replace <N> with the actual count)

CRITICAL: do not include 'Co-Authored-By', 'Claude Code', 'Claude', or 'Anthropic' attribution in commit messages or PR description (per CLaiRE rules in dotfiles/CLAUDE.md).

If the candidates are speculative, structural, or require user judgment, skip the PR step — just leave them in the report for human review.

## Final output to stdout

Print one of:
- 'OK: no findings'
- 'OK: report written to ${REPORT}'
- 'OK: report written, PR opened: <pr-url>'

Errors should print to stderr." \
    > "$REPORT.stdout" 2> "$REPORT.stderr"
) </dev/null >/dev/null 2>&1 & disown
