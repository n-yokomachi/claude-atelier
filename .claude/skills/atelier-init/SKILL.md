---
name: atelier-init
description: CLaiREハーネスを現在のマシンにインストール。~/.claude/ にシンボリックリンクを作成し、claude-atelier マーケットプレイスを登録、issue-driven プラグインを有効化する。初回セットアップ、ハーネスインストール時に使用。
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob
---

# CLaiRE Atelier Installer

このリポジトリのファイルを `~/.claude/` にシンボリックリンクで配置し、`claude-atelier` マーケットプレイスを登録、`issue-driven` プラグインを有効化することで、全プロジェクトで CLaiRE パーソナルエージェントを有効にする。

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
ln -sfn <repo>/skills ~/.claude/skills
```

**Windows (Git Bash):**
```bash
export MSYS=winsymlinks:nativestrict
ln -s <repo>/dotfiles/CLAUDE.md ~/.claude/CLAUDE.md
ln -s <repo>/dotfiles/settings.json ~/.claude/settings.json
ln -s <repo>/dotfiles/statusline-command.sh ~/.claude/statusline-command.sh
ln -s <repo>/dotfiles/notify.sh ~/.claude/notify.sh
ln -s <repo>/skills ~/.claude/skills
```

※ Windows では既存ファイルを先に `rm` してから `ln -s` する（`-f` が効かないため）

### Step 3: claude-atelier マーケットプレイス登録 + プラグイン有効化

リポジトリルートを `claude-atelier` ローカルマーケットプレイスとして登録し、`issue-driven` プラグインをインストールする。

CLI コマンドを Bash で実行する。**`--scope local` を必ず付ける**ことで、マシン固有のパスがプロジェクトの `.claude/settings.local.json` (gitignored) に書かれるようにする。`--scope user`（デフォルト）だと `~/.claude/settings.json` (= 本リポジトリの `dotfiles/settings.json` への symlink、git 管理対象) に書き込まれてしまうので環境ロックインの原因になる。

```bash
# リポジトリルート絶対パスを取得（このスキルが実行されているリポジトリ）
REPO=$(git rev-parse --show-toplevel)

# 既に登録済みかチェック
if claude plugin marketplace list 2>&1 | grep -q "claude-atelier"; then
  echo "Marketplace claude-atelier already registered"
else
  claude plugin marketplace add "$REPO" --scope local
fi

# プラグインインストール（既にインストール済みなら冪等、必ず --scope local）
claude plugin install issue-driven@claude-atelier --scope local
```

注意点:
- パスはOSネイティブ形式でOK（Windows なら `D:\\...`、Unix なら `/home/...`）
- インストール時にプラグインファイルは `~/.claude/plugins/cache/claude-atelier/issue-driven/<version>/` に**コピー**される（symlink ではない）
- リポジトリ側の SKILL.md を編集した場合、変更を反映するには `claude plugin marketplace update claude-atelier && claude plugin install issue-driven@claude-atelier --scope local` を再実行する必要がある

### Step 4: 検証

1. シンボリックリンクが正しいか `ls -la ~/.claude/` で確認
2. `claude plugin list` で `issue-driven@claude-atelier` が enabled になっているか確認
3. 結果を報告

### Step 5: 完了報告

以下を CLaiRE の口調で報告:

1. 作成されたシンボリックリンクの一覧
2. 登録されたマーケットプレイス・プラグイン
3. 動作確認の案内:
   - 「**Claude Code を再起動してください**」（プラグイン読み込みのため必須）
   - 「新しいセッションで `/briefing` でブリーフィングが動くか試してみよう！」
   - 「`/issue-driven:issue-finding` で技術アウトプット制作ワークフローが起動できるか確認しよう！」
4. 開発フローの案内:
   - フラットスキル (`skills/`) は symlink 経由で即時反映される
   - プラグインスキル (`plugins/<plugin>/skills/`) はキャッシュ方式のため、編集後に `claude plugin marketplace update claude-atelier && claude plugin install issue-driven@claude-atelier` の再実行が必要
