# claude-atelier

Claude Codeを自分専用の汎用エージェントに育てるプロジェクト。スキル・設定・ターミナル環境・プラグインをここで一元管理する。

このリポジトリ自体が `claude-atelier` ローカルマーケットプレイスとしても機能する（`.claude-plugin/marketplace.json`）。

## プロジェクト構造
- `dotfiles/` — `~/.claude/` に配置するファイル群（CLAUDE.md, settings.json, statusline-command.sh）
- `skills/` — `~/.claude/skills/` に配置するフラットなスキル群（`/<name>` で起動）
- `plugins/` — マーケットプレイス経由で配布するプラグイン群（`/<plugin>:<skill>` で起動）
  - `plugins/issue-driven/` — 技術アウトプット制作の 5 フェーズパイプライン
- `.claude-plugin/marketplace.json` — このリポジトリをマーケットプレイス化するマニフェスト
- `.claude/skills/atelier-init/` — Claude Code設定のデプロイ（プロジェクトレベル）
- `.claude/skills/terminal-init/` — ターミナル環境構築（プロジェクトレベル）

## 開発フロー
1. `skills/` `plugins/` `dotfiles/` のファイルを編集
2. `/atelier-init` で Claude Code 設定を `~/.claude/` に反映 + マーケットプレイス登録 + プラグイン有効化
3. `/terminal-init` でターミナル環境（Ghostty + tmux + yazi + lazygit）をセットアップ
4. 別プロジェクトで動作確認

## スキルとプラグインの違い

| 項目 | フラットスキル (`skills/`) | プラグインスキル (`plugins/<plugin>/skills/`) |
|------|---------------------------|---------------------------------------------|
| 呼び出し | `/<skill>` | `/<plugin>:<skill>` |
| 配置 | `~/.claude/skills/` への symlink | マーケットプレイス経由 |
| 例 | `/briefing`, `/worktree-start` | `/issue-driven:issue-finding` |

## 外部連携
| サービス | 方式 |
|---------|------|
| Gmail | クラウドMCP（Anthropic提供） |
| Google Calendar | クラウドMCP（Anthropic提供） |
| Slack | クラウドMCP（Anthropic Slack Connector） |

## シークレット管理
settings.jsonにシークレットは書かない。シェルプロファイル（~/.bashrc, ~/.zshrc）でexportする。
