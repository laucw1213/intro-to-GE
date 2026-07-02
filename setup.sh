#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────
# Cymbal Foods GSP1320 lab — 自動 setup Task 3 嘅 3 個 data store
# 喺 lab 嘅 Cloud Shell 跑，零輸入（project / engine_id / 認證全自動）。
#
# 前提（Task 2，要喺 Console 手動做，Terraform 做唔到）：
#   1. Gemini Enterprise → Start 30-day trial
#   2. 整 app，名 = "Cymbal Foods - Gemini Enterprise"，location = global
#   3. Set up identity → Use Google Identity → Confirm
#
# 用法：  cd byo && ./setup.sh
# ────────────────────────────────────────────────────────────────
set -euo pipefail

APP_NAME="Cymbal Foods - Gemini Enterprise"
cd "$(dirname "$0")"

# 1) 自動偵測 project（lab account 得一個 project，Cloud Shell 已 set 好）
PROJECT="${GOOGLE_CLOUD_PROJECT:-${DEVSHELL_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null)}}"
[ -z "$PROJECT" ] && { echo "❌ 揾唔到 project ID。"; exit 1; }
echo "▸ project: $PROJECT"

# 2) 認證：用 gcloud 已登入嘅 lab account token 畀 Terraform（含 cloud-platform scope）
export GOOGLE_OAUTH_ACCESS_TOKEN="$(gcloud auth print-access-token)"
[ -z "$GOOGLE_OAUTH_ACCESS_TOKEN" ] && { echo "❌ 攞唔到 access token，gcloud 未登入？"; exit 1; }

# 3) 靠 app display name 自動查 engine_id
ENGINE_ID=$(curl -s \
  -H "Authorization: Bearer $GOOGLE_OAUTH_ACCESS_TOKEN" \
  -H "X-Goog-User-Project: $PROJECT" \
  "https://discoveryengine.googleapis.com/v1/projects/$PROJECT/locations/global/collections/default_collection/engines" \
  | python3 -c "import sys,json;[print(e['name'].split('/')[-1]) for e in json.load(sys.stdin).get('engines',[]) if e.get('displayName')=='$APP_NAME']" | head -1)
if [ -z "$ENGINE_ID" ]; then
  echo "❌ 揾唔到 app「$APP_NAME」。請先喺 Console 做 Task 2（start trial + 整 app + 揀 Google Identity）。"
  exit 1
fi
echo "▸ engine_id: $ENGINE_ID"

# 4) init → import（現有 app）→ apply（起 3 個 data store + 接落 app + GCS import）
TFVARS=(-var-file=lab.tfvars -var="project_id=$PROJECT" -var="engine_id=$ENGINE_ID")

echo "▸ terraform init..."
terraform init -input=false >/dev/null

echo "▸ import 現有 app..."
terraform import -input=false "${TFVARS[@]}" \
  'module.ge[0].google_discovery_engine_search_engine.ge' \
  "projects/$PROJECT/locations/global/collections/default_collection/engines/$ENGINE_ID" 2>/dev/null \
  || echo "  (已 import，跳過)"

echo "▸ terraform apply..."
terraform apply -auto-approve -input=false "${TFVARS[@]}"

echo
echo "✅ 完成！等 1-2 分鐘俾 connector ready + GCS import，然後喺 lab 撳 Task 3「Check my progress」。"
