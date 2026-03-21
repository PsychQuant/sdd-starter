# [PROJECT_NAME] 專案憲法

> [PROJECT_DESCRIPTION]

## 核心原則

### I. 高品質程式碼

- 所有程式碼 MUST 遵循一致的命名慣例與格式規範
- 每個函式 MUST 職責單一，不超過一個明確的功能
- 禁止提交含有已知缺陷或編譯警告的程式碼
- 程式碼 MUST 具備自解釋性；僅在邏輯不明顯處加註解

### II. 可測試性優先

- 所有核心邏輯 MUST 可被獨立測試，不依賴外部狀態
- 新功能 MUST 附帶對應的測試案例
- 測試 MUST 先撰寫並確認失敗，再進行實作（紅-綠-重構）

### III. 最小可行產品（MVP）

- 每個功能 MUST 從最小可交付單元開始實作
- 優先交付可運作的端到端流程，再逐步擴充
- 每個 User Story MUST 可獨立開發、測試、部署

### IV. 禁止過度設計

- MUST NOT 為假設性的未來需求撰寫程式碼（YAGNI）
- MUST NOT 在僅使用一次的邏輯上建立抽象層
- 複雜度 MUST 有明確的當前需求作為正當理由

### V. [PRINCIPLE_5_NAME]

- [PRINCIPLE_5_RULES]

## 品質標準

- 程式碼覆蓋率目標：核心業務邏輯 MUST 達到 80% 以上
- 所有公開介面 MUST 有明確的輸入驗證與錯誤處理
- 安全性：MUST 遵循 OWASP Top 10 防護原則

## 開發流程

- 每個功能以獨立分支開發，透過 Pull Request 合併
- PR MUST 通過所有自動化測試後方可合併
- 每次提交 MUST 為原子性變更，附帶有意義的訊息
- 重構與功能變更 MUST NOT 混合在同一次提交中

## 治理

- 本憲法為專案最高指導原則，優先於所有其他慣例
- 修訂程序：提出變更 → 文件記錄 → 團隊審核 → 更新版本號
- 版本號採用語意化版本控制（MAJOR.MINOR.PATCH）

**Version**: 1.0.0 | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
