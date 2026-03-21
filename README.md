# SDD Starter — Spec-Driven Development Template

> 將 SDD（Spec-Driven Development）工作流程移植到任何新專案的起始模板。

## 快速開始

### 1. 從 template 建立新專案

```bash
# 方法 A: GitHub template
gh repo create my-new-project --template PsychQuant/sdd-starter --private

# 方法 B: 手動複製
git clone https://github.com/PsychQuant/sdd-starter.git my-new-project
cd my-new-project
rm -rf .git && git init && git branch -m main
```

### 2. 安裝必要的 Claude Code Plugins

```bash
# speckit（SDD 核心流程）— 已內建於 .specify/ 目錄，透過 settings.json 載入
# 確認 .claude/settings.json 包含 speckit skill 路徑

# feature-dev（程式碼探索、架構審查、代碼審查）
claude plugins install feature-dev

# superpowers（brainstorming、TDD、debugging、code review 等進階技能）
claude plugins install superpowers

# issue-driven-dev（GitHub Issue 驅動開發）— 選用
claude plugins install issue-driven-dev
```

### 3. 初始化專案憲法

```bash
# 啟動 Claude Code，執行：
/speckit.constitution
# 根據提示填入專案名稱、描述、核心原則
```

### 4. 開始第一個 Feature

```bash
/speckit.specify 我想要做一個使用者登入功能
/speckit.clarify
/speckit.plan
/speckit.tasks
/speckit.implement
```

## SDD 工作流程

```
                ┌──────────────────┐
                │  /speckit.specify │  定義規格
                └────────┬─────────┘
                         │
                ┌────────▼─────────┐
                │  /speckit.clarify │  釐清模糊需求（最多 5 題）
                └────────┬─────────┘
                         │
                ┌────────▼─────────┐
                │  /speckit.plan    │  產出 research + data-model + quickstart
                └────────┬─────────┘
                         │
                ┌────────▼─────────┐
                │  /speckit.tasks   │  產生 Phase 化任務清單
                └────────┬─────────┘
                         │
                ┌────────▼──────────────┐
                │  /speckit.implement    │  執行實作（含 IDD + feature-dev）
                └───────────────────────┘
```

### 每個 Phase 的強制流程

```
🔍 code-explorer  →  📐 code-architect  →  ✍️ 實作  →  🔎 code-reviewer  →  📦 commit
```

### Issue-Driven Development（IDD）

- `/speckit.implement` 偵測 GitHub remote 後詢問是否建立 Phase Issues
- 每個 Phase 一個 Issue，內含 task checklist
- Phase commit 帶 `Closes #XX` 自動關閉 Issue

## 目錄結構

```
.claude/
├── commands/               # speckit 指令定義（SDD 流程核心）
│   ├── speckit.specify.md
│   ├── speckit.clarify.md
│   ├── speckit.plan.md
│   ├── speckit.tasks.md
│   ├── speckit.implement.md
│   ├── speckit.constitution.md
│   ├── speckit.checklist.md
│   ├── speckit.analyze.md
│   └── speckit.taskstoissues.md
├── rules/
│   ├── common/             # 通用開發規範（適用所有語言）
│   │   ├── coding-style.md
│   │   ├── git-workflow.md
│   │   ├── testing.md
│   │   ├── performance.md
│   │   ├── patterns.md
│   │   ├── hooks.md
│   │   ├── agents.md
│   │   ├── security.md
│   │   └── development-workflow.md
│   └── README.md           # 說明如何新增語言特定規則
├── settings.json           # 預設 permissions（speckit 腳本 + GitHub CLI）
└── settings.local.json     # 專案特定 permissions（不含在 template，自行建立）

.specify/
├── scripts/bash/           # 自動化腳本（不需修改）
│   ├── create-new-feature.sh
│   ├── check-prerequisites.sh
│   ├── setup-plan.sh
│   └── update-agent-context.sh
├── templates/              # 文件範本
│   ├── spec-template.md
│   ├── plan-template.md
│   ├── tasks-template.md
│   └── constitution-template.md
├── memory/
│   └── constitution.md     # 專案憲法（/speckit.constitution 產生）
└── extensions.yml          # Hook 配置（選用）

specs/                      # Feature 規格目錄（自動建立）
├── 001-feature-name/
│   ├── spec.md
│   ├── plan.md
│   ├── research.md
│   ├── data-model.md
│   ├── quickstart.md
│   ├── tasks.md
│   └── checklists/
└── ...

CLAUDE.md                   # Claude Code 專案指引（update-agent-context 維護）
```

### 語言特定規則（選用安裝）

從 [rules/ README](.claude/rules/README.md) 查看支援的語言。安裝方式：

```bash
# 從 https://github.com/PsychQuant/sdd-starter 複製語言目錄
# 例如 Swift 專案：
cp -r path/to/sdd-starter/.claude/rules/swift .claude/rules/swift
```

支援語言：Swift, Python, Go, TypeScript, Rust, Kotlin, Java, C++, C#, PHP, Perl

## 必要 Plugins

| Plugin | 用途 | 必要性 |
|--------|------|--------|
| **feature-dev** | code-explorer, code-architect, code-reviewer agents | 必要 |
| **superpowers** | brainstorming, TDD, debugging, finishing branch | 建議 |
| **issue-driven-dev** | GitHub Issue 驅動開發 | 選用 |
| **pr-review-toolkit** | PR code review, comment analysis | 選用 |

## 自訂

### 新增語言特定規則

在 CLAUDE.md 的 Code Style 區塊加入語言特定規範。`update-agent-context.sh` 會自動偵測 plan.md 中的技術棧並更新。

### 自訂憲法原則

執行 `/speckit.constitution` 可隨時修改原則。支援新增/刪除/修改原則，自動更新版本號。

### Hook 配置

在 `.specify/extensions.yml` 設定 before/after hooks：

```yaml
hooks:
  before_implement:
    - extension: my-linter
      command: lint
      description: Run linter before implementation
      enabled: true
      optional: false
```

## 授權

Private template — PsychQuant internal use.
