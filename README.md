# Intro to Gemini Enterprise lab (GSP1320) — one-command setup for Task 2 + 3

Automatically completes the **three Task 3 data stores** for the "Introduction to
Gemini Enterprise" (Cymbal Foods) lab. Run one command in the lab's Cloud Shell —
**zero input** (project / engine / auth / terraform install are all automatic).

> ✅ Verified end-to-end on a real lab (2026-07): both Task 2 and Task 3 "Check my progress" pass.

> 📖 Participant workshop guide (full walkthrough, Steps 0–5): [`lab_guide/intro-to-GE.html`](lab_guide/intro-to-GE.html).

## Steps

### 1. Task 2 — do this by hand in the Console (Terraform / API cannot)
In the lab's Google Cloud Console:
1. Search **Gemini Enterprise** → **Start 30 Day Free Trial** (follow the prompt to activate the API).
2. Create the app: App name = **`Cymbal Foods - Gemini Enterprise`**, Location = **global** → **Create**.
3. **Set up identity → Use Google Identity → Confirm Workforce Identity**.

> The Task 2 graded item is the identity provider, which must be clicked by hand. Without an IdP selected, connectors cannot be created (`IdP must be selected`).

### 2. Task 3 — open Cloud Shell and run one command
```bash
git clone https://github.com/laucw1213/intro-to-GE.git
cd intro-to-GE && ./setup.sh
```

### 3. Wait 1–2 minutes, then click "Check my progress"
Give the connectors time to become ACTIVE and the Cloud Storage import to run, then click **Check my progress** for **Task 2** and **Task 3** in the lab.

## What `setup.sh` does

1. **Auto-installs Terraform** (Cloud Shell ships only an "install hint" shim): downloads the current release from HashiCorp into `~/.local/bin` — no sudo.
2. **Detects the project** (the lab account has one project; Cloud Shell already sets it).
3. **Authenticates** with the Cloud Shell lab-account token (`gcloud auth print-access-token`, which has the cloud-platform scope) via `GOOGLE_OAUTH_ACCESS_TOKEN`. No OAuth client, no server, credentials never leave your session.
4. **Looks up the engine_id by app name** (`Cymbal Foods - Gemini Enterprise`) → `terraform import`s the app you created in Task 2 (in-place, not recreated).
5. **`terraform apply`**:
   - creates **Google Drive** + **Google Calendar** connectors (Google-managed zero-config OAuth, federated),
   - creates a **Cloud Storage** data store and imports the documents from `gs://<project>/gemini-enterprise-cloud-storage/`,
   - attaches all three data stores to your app using Console-format IDs (`<slug>_<digits>`, e.g. `cloud-storage_7784061364277`),
   - and enables the app features (Agent Designer, Canvas, etc.).

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `app "Cymbal Foods - Gemini Enterprise" not found` | Task 2 isn't complete (app not created / wrong name). Finish it in the Console first. |
| `IdP must be selected` | Task 2 step 3 (Google Identity) wasn't clicked. Do it, then re-run `./setup.sh`. |
| `DataStore ... is being deleted` | A same-named data store was just deleted; GCP locks the id for a few hours. Re-running uses a fresh random suffix to avoid it; a fresh lab won't hit this. |
| Check my progress doesn't pass | Wait another 1–2 minutes (connectors / import not ready yet) and click again. |

## Notes
- This repo only covers **Task 2 (the app part) + Task 3**; Task 1 / 4 / 6 you do by hand following the lab.
- Does not touch billing (Qwiklabs owns the lab billing).
