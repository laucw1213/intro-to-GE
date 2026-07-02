# Cymbal Foods lab (GSP1320) — 自動 setup Task 2 + 3

用 Cloud Shell 幫 lab 學員自動搞掂 Task 3 嘅 3 個 data store。學員零輸入。

## 前提：Task 2 要手動做（Console，Terraform / API 做唔到）
喺 lab 嘅 Google Cloud Console：
1. Gemini Enterprise → **Start 30-day trial**
2. 整 app，名 = **`Cymbal Foods - Gemini Enterprise`**，location = **global**
3. **Set up identity → Use Google Identity → Confirm**

> Task 2 個 graded item 係 identity provider，一定要人手撳。

## Task 3：喺 Cloud Shell 跑一句
```bash
git clone https://github.com/laucw1213/intro-to-GE.git
cd intro-to-GE
./setup.sh
```

`setup.sh` 會自動：
- 偵測 project ID（lab 得一個 project，Cloud Shell 已 set 好）
- 用 gcloud 已登入嘅 lab account token 認證（含 cloud-platform scope）
- 靠 app display name 查 engine_id
- `terraform import` 現有 app → `terraform apply`
- 起 Google Drive / Google Calendar / Cloud Storage 3 個 data store（ID 格式對齊 grader）+ 接落 app + GCS 文件 import

跑完等 **1-2 分鐘**（俾 connector ready + GCS import），再喺 lab 撳 **Task 2 + Task 3「Check my progress」**。

## 認證點解得（Cloud Shell）
Cloud Shell 本身已用 lab account 登入，`gcloud auth print-access-token` 直接攞到帶 cloud-platform scope 嘅 token，Terraform 用 `GOOGLE_OAUTH_ACCESS_TOKEN` 食。**唔使 OAuth client、唔使 server、憑證唔離開學員 session。**

## 注意
- 要學員 clone 到 repo，所以 repo 要有 git remote（push 上 GitHub 等）。
- 呢個 root 唔掂 billing（lab / Qwiklabs 負責）。
