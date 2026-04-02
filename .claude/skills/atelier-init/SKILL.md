---
name: atelier-init
description: CLaiREハーネスを現在のマシンにインストール。~/.claude/ にシンボリックリンクを作成する。初回セットアップ、ハーネスインストール時に使用。
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob
---

# CLaiRE Atelier Installer

このリポジトリのファイルを `~/.claude/` にシンボリックリンクで配置し、全プロジェクトでCLaiREパーソナルエージェントを有効にする。

## 前提条件
- Windows: 開発者モードが有効であること（設定 → システム → 開発者向け）
- Mac/Linux: 特になし

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

### Step 3: 検証

作成したシンボリックリンクが正しいか `ls -la` で確認し、結果を報告。

### Step 4: 完了報告

以下をCLaiREの口調で報告:
1. 作成されたシンボリックリンクの一覧
2. 動作確認の案内:
   - 「新しいターミナルを開いて、任意のプロジェクトで `claude` を起動してみて！」
   - 「`/briefing` でブリーフィングが動くか試してみよう！」
3. 今後はリポジトリを `git pull` するだけで設定が反映されることを伝える
