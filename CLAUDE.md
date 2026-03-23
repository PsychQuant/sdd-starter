# Project Development Guidelines

Auto-generated from feature plans. Last updated: [DATE]

## Active Technologies
<!-- auto-updated by update-agent-context.sh -->

## Project Structure

```text
# Update this section to reflect your project structure
src/
  ...
```

## Commands

```bash
# Add your project-specific build/test/run commands here
```

## Code Style

- Follow standard conventions for your language
- Validate at system boundaries (user input, external APIs)
- UI text: 正體中文 (or your preferred language)

## Development Workflow

### 完整開發流程
```
/speckit.specify     → 定義規格
/speckit.clarify     → 釐清模糊需求
/speckit.plan        → 產出設計文件
/speckit.tasks       → 產生任務清單
/speckit.taskstoissues → 轉成 GitHub Issues（IDD 模式）
/speckit.implement   → 執行實作（整合 feature-dev + IDD）
```

### Git 追蹤規範
- **每完成一個 Phase 必須 commit**，commit message 包含 Phase 名稱和完成的 task 範圍
- Commit 格式：`feat: Phase N — [Phase 名稱] (T0XX–T0XX)`
- IDD 模式下，commit 尾部加 `Closes #XX, #XX`（自動關閉 GitHub Issues）
- 修正 bug 獨立 commit：`fix: [描述]`

### feature-dev Plugin 整合（強制執行）
**以下三步 MUST NOT 跳過，無論 Phase 多簡單（包含 Setup / greenfield Phase）：**

1. **Phase 開始前**：輸出 `🔍 [feature-dev] Exploring codebase for Phase N...` 然後啟動 `feature-dev:code-explorer` agent
   - Greenfield: 確認根目錄無衝突檔案、驗證 .gitignore
2. **寫 code 前**：輸出 `📐 [feature-dev] Reviewing architecture for Phase N...` 然後啟動 `feature-dev:code-architect` agent
   - Greenfield: 確認專案結構符合 plan.md 設計
3. **Phase commit 前**：輸出 `🔎 [feature-dev] Reviewing Phase N code...` 然後啟動 `feature-dev:code-reviewer` agent

**跳過規則**：
- 僅限使用者明確指示才可跳過。AI 判斷「太簡單」不是合法理由。
- 經使用者同意跳過：commit message MUST 包含 `⚠️ SKIPPED: [step] — user requested`
- **Pre-commit gate check**：commit 前必須驗證三步皆已執行，缺少則 STOP 補執行

### Issue-Driven Development 整合
- **每個 Phase 一個 GitHub Issue**（不是每個 task 一個），內含 task checklist + 驗收標準
- `/speckit.implement` 啟動時偵測 GitHub remote → 詢問是否建立 Phase Issues
- 每個 Phase commit 帶 `Closes #issue` 關閉該 Phase 的 issue
