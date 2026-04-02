# claude-atelier

Claude Codeを自分専用の汎用エージェントに育てるプロジェクト。スキル・設定・ターミナル環境をここで一元管理する。

## プロジェクト構造
- `dotfiles/` — `~/.claude/` に配置するファイル群（CLAUDE.md, settings.json, statusline-command.sh）
- `skills/` — `~/.claude/skills/` に配置するスキル群
- `.claude/skills/atelier-init/` — Claude Code設定のデプロイ（プロジェクトレベル）
- `.claude/skills/terminal-init/` — ターミナル環境構築（プロジェクトレベル）

## 開発フロー
1. `skills/` や `dotfiles/` のファイルを編集
2. `/atelier-init` で Claude Code 設定を `~/.claude/` に反映
3. `/terminal-init` でターミナル環境（Ghostty + tmux + yazi + lazygit）をセットアップ
4. 別プロジェクトで動作確認

## 外部連携
| サービス | 方式 |
|---------|------|
| Gmail | クラウドMCP（Anthropic提供） |
| Google Calendar | クラウドMCP（Anthropic提供） |
| Slack | クラウドMCP（Anthropic Slack Connector） |

## シークレット管理
settings.jsonにシークレットは書かない。シェルプロファイル（~/.bashrc, ~/.zshrc）でexportする。
