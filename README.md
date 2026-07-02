# Intro to Gemini Enterprise lab (GSP1320) — 一鍵 setup Task 2 + 3

幫「Introduction to Gemini Enterprise」(Cymbal Foods) lab 學員自動完成 **Task 3 嘅 3 個 data store**。
喺 lab 嘅 Cloud Shell 跑一句就得，**零輸入**（project / engine / 認證 / terraform 安裝全自動）。

> ✅ 已於真實 lab 端到端實測（2026-07）：Task 2 + Task 3 兩個「Check my progress」都 pass。

## 步驟

### 1. Task 2 —— 喺 Console 手動做（呢部分 Terraform / API 做唔到）
喺 lab 嘅 Google Cloud Console：
1. 搜「Gemini Enterprise」→ **Start 30 Day Free Trial**（跟提示 activate API）
2. 整 app：App name = **`Cymbal Foods - Gemini Enterprise`**，Location = **global** → Create
3. **Set up identity → Use Google Identity → Confirm Workforce Identity**

> Task 2 個 graded item 係 identity provider，一定要人手撳；IdP 未揀，connector 會起唔到（`IdP must be selected`）。

### 2. Task 3 —— 開 Cloud Shell，跑一句
```bash
git clone https://github.com/laucw1213/intro-to-GE.git
cd intro-to-GE && ./setup.sh
```

### 3. 等 1-2 分鐘，撳「Check my progress」
俾 connector 轉 ACTIVE + Cloud Storage 文件 import，然後喺 lab 撳 **Task 2** 同 **Task 3** 嘅 Check my progress。

## `setup.sh` 做咗啲咩

1. **自動安裝 terraform**（Cloud Shell 預設只有個「提示安裝」嘅 shim）：由 HashiCorp 下載現行版本落 `~/.local/bin`，唔使 sudo
2. **偵測 project**（lab account 得一個 project，Cloud Shell 已 set 好）
3. **認證**：用 Cloud Shell 已登入嘅 lab account token（`gcloud auth print-access-token`，含 cloud-platform scope）→ `GOOGLE_OAUTH_ACCESS_TOKEN`。無 OAuth client、無 server、憑證唔離開你個 session
4. **靠 app 名查 engine_id**（`Cymbal Foods - Gemini Enterprise`）→ `terraform import` 你喺 Task 2 整嗰個 app（in-place，唔會重建）
5. **`terraform apply`**：
   - 起 **Google Drive** + **Google Calendar** connector（Google-managed zero-config OAuth，federated）
   - 起 **Cloud Storage** data store 並自動 import `gs://<project>/gemini-enterprise-cloud-storage/` 啲文件
   - 3 個 data store 用 Console 格式 ID（`<slug>_<digits>`，例 `cloud-storage_7784061364277`）attach 落你個 app
   - 順手 enable 晒 app 嘅 features（agent designer / canvas 等）

## Troubleshooting

| 現象 | 原因 / 做法 |
|---|---|
| `❌ 揾唔到 app「Cymbal Foods - Gemini Enterprise」` | Task 2 未做完（app 未整 / 名唔啱）。返去 Console 做完先。 |
| `IdP must be selected` | Task 2 第 3 步（Google Identity）未撳。撳完再跑 `./setup.sh`。 |
| `DataStore ... is being deleted` | 同名 data store 啱啱刪過，GCP 鎖幾個鐘。再跑一次會用新 random 尾避開；一般 fresh lab 唔會遇到。 |
| Check my progress 未 pass | 等多 1-2 分鐘（connector / import 未 ready）再撳。 |

## 注意
- 呢個 repo 只處理 **Task 2（app 部分）+ Task 3**；Task 1 / 4 / 6 要跟 lab 指示自己做。
- 唔掂 billing（lab 由 Qwiklabs 負責）。
