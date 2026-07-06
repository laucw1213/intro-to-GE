#!/usr/bin/env bash
# ----------------------------------------------------------------
# Cymbal Foods GSP1320 lab - auto-set-up the 3 Task 3 data stores.
# Run in the lab's Cloud Shell, zero input (project / engine_id / auth all automatic).
#
# Prerequisite (Task 2, must be done by hand in the Console - Terraform cannot):
#   1. Gemini Enterprise -> Start 30-day trial
#   2. Create the app, name = "Cymbal Foods - Gemini Enterprise", location = global
#   3. Set up identity -> Use Google Identity -> Confirm
#
# Usage:  cd intro-to-GE && ./setup.sh
# ----------------------------------------------------------------
set -euo pipefail

APP_NAME="Cymbal Foods - Gemini Enterprise"
cd "$(dirname "$0")"

# 0) Make sure a real terraform exists (Cloud Shell may only have an "install hint"
#    shim that exits 0, which would silently do nothing).
if ! terraform version 2>/dev/null | grep -q "^Terraform v"; then
  echo "> terraform not found, installing to ~/.local/bin ..."
  TF_VER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform \
    | python3 -c "import sys,json;print(json.load(sys.stdin)['current_version'])" 2>/dev/null || true)
  TF_VER="${TF_VER:-1.9.8}" # fallback version if the checkpoint API is unreachable (>=1.5 is enough)
  curl -sLo /tmp/tf.zip "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip"
  mkdir -p "$HOME/.local/bin"
  if command -v unzip >/dev/null 2>&1; then
    unzip -o -q /tmp/tf.zip -d "$HOME/.local/bin"
  else
    python3 -c "import zipfile;zipfile.ZipFile('/tmp/tf.zip').extractall('$HOME/.local/bin')"
  fi
  chmod +x "$HOME/.local/bin/terraform"
  export PATH="$HOME/.local/bin:$PATH" # ahead of the shim
  terraform version | head -1
fi

# 1) Auto-detect the project (the lab account has exactly one project; Cloud Shell already sets it).
PROJECT="${GOOGLE_CLOUD_PROJECT:-${DEVSHELL_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null)}}"
[ -z "$PROJECT" ] && { echo "ERROR: could not find a project ID."; exit 1; }
echo "> project: $PROJECT"

# 2) Auth: give Terraform the logged-in lab account token (has the cloud-platform scope).
export GOOGLE_OAUTH_ACCESS_TOKEN="$(gcloud auth print-access-token)"
[ -z "$GOOGLE_OAUTH_ACCESS_TOKEN" ] && { echo "ERROR: could not get an access token; is gcloud signed in?"; exit 1; }

# 3) Look up the engine_id by app display name.
ENGINE_ID=$(curl -s \
  -H "Authorization: Bearer $GOOGLE_OAUTH_ACCESS_TOKEN" \
  -H "X-Goog-User-Project: $PROJECT" \
  "https://discoveryengine.googleapis.com/v1/projects/$PROJECT/locations/global/collections/default_collection/engines" \
  | python3 -c "import sys,json;[print(e['name'].split('/')[-1]) for e in json.load(sys.stdin).get('engines',[]) if e.get('displayName')=='$APP_NAME']" | head -1)
if [ -z "$ENGINE_ID" ]; then
  echo "ERROR: app \"$APP_NAME\" not found. Complete Task 2 in the Console first (start trial + create app + choose Google Identity)."
  exit 1
fi
echo "> engine_id: $ENGINE_ID"

# 4) init -> import (existing app) -> apply (create 3 data stores + attach to app + GCS import)
TFVARS=(-var-file=lab.tfvars -var="project_id=$PROJECT" -var="engine_id=$ENGINE_ID")

echo "> terraform init..."
terraform init -input=false >/dev/null

echo "> import existing app..."
terraform import -input=false "${TFVARS[@]}" \
  'module.ge[0].google_discovery_engine_search_engine.ge' \
  "projects/$PROJECT/locations/global/collections/default_collection/engines/$ENGINE_ID" 2>/dev/null \
  || echo "  (already imported, skipping)"

echo "> terraform apply..."
terraform apply -auto-approve -input=false "${TFVARS[@]}"

echo
echo "Done! Wait 1-2 minutes for the connectors to become ready and the GCS import to run, then click Task 3 \"Check my progress\" in the lab."
