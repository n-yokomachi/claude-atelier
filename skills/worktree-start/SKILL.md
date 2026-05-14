---
name: worktree-start
description: git worktreeを作成し、tmuxペインで新しいClaude Codeセッションを起動する
allowed-tools: Bash, AskUserQuestion, ToolSearch, mcp__atlassian-mcp-server__getJiraIssue
---

# worktree-start

git worktree を作成し、依存関係をインストールした上で、tmux の新しいペインに Claude Code セッションを起動する。

## 使い方

```
/worktree-start <branch名またはJiraチケットURL/ID>
```

例:
- `/worktree-start feature/KSF-42`
- `/worktree-start feature/new-api`
- `/worktree-start https://kddi-corp.atlassian.net/browse/KSFDXPJ-449`
- `/worktree-start KSFDXPJ-449 最新のmainからworktreeを作成して`

## 手順

1. 引数からブランチ名を取得する。引数がない場合は AskUserQuestion で確認する。

1.5. **（オプション）Jira チケット情報の取得**  
   引数に Jira チケットの URL（`atlassian.net/browse/XXX-NNN`）またはチケット ID（例: `KSFDXPJ-449`）が含まれる場合:
   - ToolSearch で `getJiraIssue` スキーマをロードし、`mcp__atlassian-mcp-server__getJiraIssue` でチケットの `summary` を取得する
   - ブランチ名が未指定のときはチケット ID をそのままサフィックスに使用する（例: `feature/KSFDXPJ-449`）
   - 取得した summary を完了メッセージに含める

2. worktree のディレクトリパスを決定する:
   - リポジトリのルートディレクトリ名を取得（例: `ksf-dx-app`）
   - ブランチ名からサフィックスを生成（`/` を `-` に置換）
   - パス: `<リポジトリの親ディレクトリ>/<リポジトリ名>--<サフィックス>`
   - 例: `feature/KSF-42` → `/Users/na-yokomachi/ksf/ksf-dx-app--feature-KSF-42`

3. 既に同名の worktree が存在するか確認する（`git worktree list`）。存在する場合はその旨を伝え、既存のパスを使って手順6へスキップする。  
   **Step 3 の `git worktree list` と Step 4 のフェッチ（後述）は独立しているため、同じ Bash ターンで並行実行してよい。**

4. worktree を作成する:
   - ユーザーが「最新のmainから」等と指示した場合、または新規ブランチをリモートの最新状態から作りたい場合は、事前に `git fetch origin <base>` を実行してからブランチを作成する:
     ```bash
     git fetch origin main
     git worktree add -b <branch名> <path> origin/main
     ```
   - 既存ブランチをチェックアウトする場合:
     ```bash
     git worktree add <path> <branch名>
     ```
   - ブランチが存在しない場合（フェッチ不要なケース）は `-b` オプションで `main` から新規作成:
     ```bash
     git worktree add -b <branch名> <path> main
     ```

5. 依存関係をインストールする（worktree ディレクトリ内で実行）:
   - `[ -d <path>/web ]` で確認し、存在する場合: `cd <path>/web && pnpm install`
   - `[ -d <path>/infrastructure/functions ]` で確認し、存在する場合: `cd <path>/infrastructure/functions && uv sync`
   - ディレクトリ存在確認は `ls` による一覧取得ではなく上記の条件分岐で行う
   - いずれもバックグラウンドではなく完了を待つ

6. tmux で新しいペインを開き、Claude Code を起動する:
   ```bash
   tmux split-window -v -c "<path>"
   tmux send-keys 'claude' Enter
   ```

7. 完了メッセージを表示する:
   - 作成した worktree のパス
   - インストールした依存関係
   - tmux ペインで Claude Code が起動した旨
   - Jira チケット情報が取得できた場合はチケット ID・summary を表示する
   - **新しいセッションでの実装開始には `/spops <チケットURL>` を使うと Superpowers 開発フロー（Brainstorming → Writing Plans → Executing Plans）が利用できる旨を案内する**

## 注意事項

- tmux セッション内でない場合はエラーにせず、worktree 作成と依存インストールまで行い、手動で移動するよう案内する
- 同じブランチの worktree が既に存在する場合は作り直さない
