---
name: atelier-init
description: CLaiREハーネスを現在のマシンにインストール。~/.claude/ にシンボリックリンクを作成し、claude-atelier (ローカル) + cadenza (GitHub public) マーケットプレイスを登録、cadenza / cadenza-personal / skill-creator (公式) プラグインを有効化する。初回セットアップ、ハーネスインストール時に使用。
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob
---

# CLaiRE Atelier Installer

このリポジトリのファイルを `~/.claude/` にシンボリックリンクで配置し、`claude-atelier` (ローカルディレクトリ) と `cadenza` (GitHub public, https://github.com/n-yokomachi/cadenza) の 2 つのマーケットプレイスを登録、`cadenza` / `cadenza-personal` プラグインを有効化することで、全プロジェクトで CLaiRE パーソナルエージェントを有効にする。

`cadenza` は OSS 公開済みプラグインで GitHub から、`cadenza-personal` は本リポジトリ (`claude-atelier`) からそれぞれ配信される構成。

## 前提条件
- Windows: 開発者モードが有効であること（設定 → システム → 開発者向け）
- Mac/Linux: 特になし
- `claude` CLI が PATH に通っていること

## 実行手順

### Step 1: 環境確認

1. OS検出（Windows / macOS / Linux）
2. `~/.claude/` ディレクトリの存在確認
3. 既存ファイルの状態を確認:
   - `~/.claude/CLAUDE.md`
   - `~/.claude/settings.json`
   - `~/.claude/statusline-command.sh`
   - `~/.claude/notify.sh`
   - `~/.claude/skills`
   - 既にシンボリックリンクなら「設定済み」として報告
   - 通常ファイル/ディレクトリなら削除してリンクを張り直す（オーナーに確認）
   - 存在しなければ新規作成

### Step 2: シンボリックリンク作成

ハーネスリポジトリのルートパスを検出し（このスキルが実行されているプロジェクト）、以下のリンクを作成する。

**Mac/Linux:**
```bash
ln -sf <repo>/dotfiles/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf <repo>/dotfiles/settings.json ~/.claude/settings.json
ln -sf <repo>/dotfiles/statusline-command.sh ~/.claude/statusline-command.sh
ln -sf <repo>/dotfiles/notify.sh ~/.claude/notify.sh
ln -sf <repo>/dotfiles/skill-audit.sh ~/.claude/skill-audit.sh
ln -sfn <repo>/skills ~/.claude/skills
chmod +x ~/.claude/skill-audit.sh ~/.claude/statusline-command.sh ~/.claude/notify.sh
```

**Windows (Git Bash):**
```bash
export MSYS=winsymlinks:nativestrict
ln -s <repo>/dotfiles/CLAUDE.md ~/.claude/CLAUDE.md
ln -s <repo>/dotfiles/settings.json ~/.claude/settings.json
ln -s <repo>/dotfiles/statusline-command.sh ~/.claude/statusline-command.sh
ln -s <repo>/dotfiles/notify.sh ~/.claude/notify.sh
ln -s <repo>/dotfiles/skill-audit.sh ~/.claude/skill-audit.sh
ln -s <repo>/skills ~/.claude/skills
```

※ Windows では既存ファイルを先に `rm` してから `ln -s` する（`-f` が効かないため）

### Step 3: マーケットプレイス登録 + プラグイン有効化

以下の 3 つのプラグインをインストールする:

1. **`cadenza@cadenza`** — 技術アウトプット 5 フェーズパイプライン（OSS 公開、format-agnostic な単一 markdown 出力。`github.com/n-yokomachi/cadenza` から配信）
2. **`cadenza-personal@claude-atelier`** — cadenza の出力を Zenn / deck / LT 形式に仕上げる個人専用拡張（非公開、本リポジトリから配信）
3. **`skill-creator@claude-plugins-official`** — 公式の Skill 作成・eval・改善ツール

CLI コマンドを Bash で実行する。**`--scope local` を必ず付ける**ことで、マシン固有のパスがプロジェクトの `.claude/settings.local.json` (gitignored) に書かれるようにする。`--scope user`（デフォルト）だと `~/.claude/settings.json` (= 本リポジトリの `dotfiles/settings.json` への symlink、git 管理対象) に書き込まれてしまうので環境ロックインの原因になる。

ただし `cadenza@cadenza` (GitHub public) のみは git URL で機械非依存のため、`dotfiles/settings.json` 経由で恒常登録している。`atelier-init` 内ではマーケットプレイス登録のみ補助的に行い、有効化は settings.json 側に任せる。

```bash
# リポジトリルート絶対パスを取得（このスキルが実行されているリポジトリ）
REPO=$(git rev-parse --show-toplevel)

# claude-atelier マーケットプレイス登録 (ローカルディレクトリ、まだなら)
if ! claude plugin marketplace list 2>&1 | grep -q "claude-atelier"; then
  claude plugin marketplace add "$REPO" --scope local
fi

# cadenza マーケットプレイス登録 (GitHub public、まだなら)
# 注: github.com/<owner>/<repo> の短縮形ではなく https:// 形式を使う必要がある
if ! claude plugin marketplace list 2>&1 | grep -q "^cadenza\b\|cadenza$"; then
  claude plugin marketplace add https://github.com/n-yokomachi/cadenza
fi

# claude-plugins-official マーケットプレイス登録 (通常はデフォルトで登録済み)
if ! claude plugin marketplace list 2>&1 | grep -q "claude-plugins-official"; then
  claude plugin marketplace add anthropics/claude-plugins-official --scope local
fi

# プラグインインストール (冪等)
# cadenza は dotfiles/settings.json で enabled 設定されているため、
# 本来は restart で自動 install されるが、明示的にも実行可能
claude plugin install cadenza@cadenza --scope local
claude plugin install cadenza-personal@claude-atelier --scope local
claude plugin install skill-creator@claude-plugins-official --scope local
```

注意点:
- パスはOSネイティブ形式でOK（Windows なら `D:\\...`、Unix なら `/home/...`）
- インストール時にプラグインファイルは `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/` に**コピー**される（symlink ではない）
- `cadenza` プラグイン (OSS 公開側) の編集は `plugins/cadenza/**` 経由で main に push → GitHub Actions が自動で `n-yokomachi/cadenza` public mirror に反映 → `claude plugin marketplace update cadenza && claude plugin install cadenza@cadenza --scope local` を再実行
- `cadenza-personal` プラグイン (本リポジトリ側) の編集は `claude plugin marketplace update claude-atelier && claude plugin install cadenza-personal@claude-atelier --scope local` を再実行
- 公式プラグイン (`skill-creator` 等) の更新は `claude plugin update skill-creator` で取得

### Step 4: 検証

1. シンボリックリンクが正しいか `ls -la ~/.claude/` で確認
2. `claude plugin list` で `cadenza@cadenza`, `cadenza-personal@claude-atelier`, `skill-creator@claude-plugins-official` が enabled になっているか確認
3. 結果を報告

### Step 5: 完了報告

以下を CLaiRE の口調で報告:

1. 作成されたシンボリックリンクの一覧
2. 登録されたマーケットプレイス・プラグイン
3. 動作確認の案内:
   - 「**Claude Code を再起動してください**」（プラグイン読み込みのため必須）
   - 「新しいセッションで `/briefing` でブリーフィングが動くか試してみよう！」
   - 「`/cadenza:issue-finding` で技術アウトプット制作ワークフローが起動できるか確認しよう！」
   - 「`/cadenza-personal:output-publish` で Zenn / deck / LT 仕上げが起動できるか確認しよう！」
   - 「`/skill-creator:skill-creator` でスキル作成・改善ツールが起動できるか確認しよう！」
4. 開発フローの案内:
   - フラットスキル (`skills/`) は symlink 経由で即時反映される
   - `cadenza` プラグイン: `plugins/cadenza/**` を編集して main に push → GitHub Actions が自動で `n-yokomachi/cadenza` public mirror に反映 → `claude plugin marketplace update cadenza && claude plugin install cadenza@cadenza --scope local` で取り込み
   - `cadenza-personal` プラグイン: 編集後 `claude plugin marketplace update claude-atelier && claude plugin install cadenza-personal@claude-atelier --scope local` で取り込み
