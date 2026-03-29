# claude-harness

A symlink-based harness that extends Claude Code with custom skills, dotfiles, and terminal environment.

## Quick Start

```bash
git clone https://github.com/n-yokomachi/claude-harness.git && cd claude-harness

/harness-init     # Deploy Claude Code config
/terminal-init    # Set up terminal environment
```

## Structure

```
dotfiles/
├── CLAUDE.md               # Global instructions
├── settings.json           # Claude Code settings
├── statusline-command.sh   # Status line (TokyoNight)
├── ghostty/config          # Ghostty
├── tmux.conf               # tmux
├── yazi/yazi.toml          # yazi
└── lazygit/config.yml      # lazygit

skills/
├── briefing/               # Morning briefing (calendar, email, weather)
├── calendar/               # Google Calendar
└── email-check/            # Gmail
```

All files are symlinked — `git pull` updates everything.
