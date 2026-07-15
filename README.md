# How to set up an auto feeder
Validated with macOS Sequoia 15.6.

### Prerequisite
- **Claude code CLI** or **ChatGPT Codex CLI** installed in your local machine
  - Claude code: `curl -fsSL https://claude.ai/install.sh | bash`, then launch and authenticate.
  - ChatGPT Codex: `curl -fsSL https://chatgpt.com/codex/install.sh | bash`, then launch and authenticate.
- Clone this repo to your local machine

### Step1. Prepare a prompt script and example
- Specify the backend and model to use ([summarize.sh](./summarize.sh))
- Customize the PROMPT to fit to your interests, detailness, expertise etc. ([summarize.sh](./summarize.sh))
- Edit the example files for format preference: [hep-ex,quant-ph]/example.md
  You may also just describe in the prompt sentences in the script.
- Manual launch: go to the repo in the command line and do `./summarize.sh`.

The script generates a summary per category into a temp file, validates it
(rejecting empty/short output or CLI error messages such as "Not logged in"),
and only then overwrites the real `CATEGORY/DATE.md`. A failed run therefore
never clobbers a good summary, posts to Slack, or commits/pushes.

### Step2. Feed to Slack (optional)
Summaries can be posted to a Slack channel via an **Incoming Webhook**
([post_to_slack.py](./post_to_slack.py) handles Markdown→Slack conversion,
message splitting, and dividers).

1. Create a webhook: <https://api.slack.com/apps> → *Create New App* → *From
   scratch* → enable *Incoming Webhooks* → *Add New Webhook to Workspace* →
   pick a channel. Copy the `https://hooks.slack.com/services/...` URL.
2. Give the URL to the script, either way:
   - a **gitignored file** in the repo root (recommended):
     ```
     echo 'https://hooks.slack.com/services/T000/B000/xxxx' > .slack_webhook
     ```
   - or the `SLACK_WEBHOOK_URL` environment variable (takes priority).

If neither is set, the Slack step is skipped silently — everything else runs
as normal.

### Step3. Schedule it
On macOS, **use a LaunchAgent, not cron.** cron runs outside your GUI login
session and cannot reach the login Keychain, so `claude` ends up "Not logged
in" and the run fails. A LaunchAgent runs inside your session and stays
authenticated.

```
./install_launchd.sh
```

This fills the repo path into [the plist template](./com.cshion.arxivsummaryfeeds.plist.template)
and installs/loads it. By default it runs **weekdays at 21:00** (edit
`StartCalendarInterval` in the template to change the schedule, then re-run the
installer). The repo path is auto-detected, or set it explicitly:

```
ARXIV_REPO=/abs/path/to/repo ./install_launchd.sh
```

Useful commands:
```
launchctl list | grep arxivsummaryfeeds                       # is it loaded?
launchctl kickstart -k gui/$(id -u)/com.cshion.arxivsummaryfeeds   # run now
launchctl unload ~/Library/LaunchAgents/com.cshion.arxivsummaryfeeds.plist  # stop
```
stdout/stderr of each run is appended to `crontab.log`.

<details>
<summary>Alternative: cron (not recommended on macOS)</summary>

Works only if `claude`/`codex` can authenticate without the login Keychain
(e.g. via an API-key env var). PATH is minimal under cron, but
`summarize.sh` sets its own PATH, so this single line is enough:
```
crontab -e
0 21 * * * (cd ABSPATH_TO_REPO/; ./summarize.sh > crontab.log 2>&1)
```
Change `ABSPATH_TO_REPO` to something appropriate.
</details>
