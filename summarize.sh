#!/bin/bash
set -euo pipefail

# cron runs with a minimal PATH (typically just /usr/bin:/bin), so tools
# installed elsewhere (claude in ~/.local/bin, git/python3/jq in Homebrew)
# are not found. Prepend their locations here so the script is self-contained
# regardless of how it is invoked.
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}"

DATE=$(date +%Y-%m-%d)
#DATE=2026-07-06

# Skip on weekends: arXiv does not announce new papers on Sat/Sun.
# date +%u => 1=Mon ... 6=Sat, 7=Sun
DOW=$(date +%u)
if [ "${DOW}" -ge 6 ]; then
    echo "Weekend (day ${DOW}): no arXiv update. Skipping."
    exit 0
fi

# AI backend selection: "claude" or "codex"
BACKEND="claude" # "codex"

# Slack Incoming Webhook(s) (optional). Feeds each summary to Slack when set.
# Priority: SLACK_WEBHOOK_URL env var, then a gitignored .slack_webhook file.
# The file may hold multiple webhook URLs (one per line, #-comments allowed)
# to feed several workspaces; newlines are preserved for that reason.
if [ -z "${SLACK_WEBHOOK_URL:-}" ] && [ -f "$(dirname "$0")/.slack_webhook" ]; then
    SLACK_WEBHOOK_URL=$(cat "$(dirname "$0")/.slack_webhook")
fi
export SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"

# Model selection (claude only, codex will auto-select the model)
CLAUDE_MODEL="claude-opus-4-8" # "claude-opus-4-8, claude-sonnet-4-8" etc.

# Function to call AI
call_ai() {
    local prompt="$1"
    local output="$2"
    
    if [ "${BACKEND}" = "claude" ]; then
        # File-modifying tools are disallowed: the summary must come back on
        # stdout. Otherwise the agent may write CATEGORY/DATE.md directly (or
        # skip regenerating when it already exists), leaving stdout empty and
        # tripping the validation guard.
        # NOTE: --disallowedTools is variadic and would swallow a following
        # positional argument, so the prompt must come BEFORE it.
        claude --model "${CLAUDE_MODEL}" --verbose --print "${prompt}" \
            --disallowedTools "Write,Edit,NotebookEdit,Bash" > "${output}"

    elif [ "${BACKEND}" = "codex" ]; then
        local log_file
        log_file="$(mktemp "${TMPDIR:-/tmp}/codex-summary.XXXXXX.log")"

        if ! codex exec \
            -c tools.web_search=true \
            --cd "$(pwd)" \
            --sandbox workspace-write \
            --output-last-message "${output}" \
            "${prompt}" > "${log_file}" 2>&1; then
            echo "Codex failed. Log: ${log_file}" >&2
            return 1
        fi

	# Check the consumed tokens
        local tokens_used
        tokens_used="$(awk '/^tokens used$/ { getline; print; found=1 } END { exit found ? 0 : 1 }' "${log_file}" || true)"
        if [ -n "${tokens_used}" ]; then
            echo "Codex tokens used: ${tokens_used}"
        fi
        rm -f "${log_file}"

    else
        echo "Unknown backend: ${BACKEND}" >&2
        exit 1
    fi
}

# Sanity-check a generated summary before it is allowed to overwrite the real
# file. Guards against auth failures / errors (e.g. "Not logged in") or empty
# output silently clobbering a good summary and getting committed & pushed.
validate_summary() {
    local file="$1"
    # Must exist and be non-trivially sized (a real summary is >1 KB).
    if [ ! -s "${file}" ] || [ "$(wc -c < "${file}" | tr -d ' ')" -lt 400 ]; then
        echo "  -> too short/empty" >&2
        return 1
    fi
    # Must not be a CLI error/authentication message.
    if grep -qiE 'Not logged in|Please run /login|Invalid API key|Credit balance|usage limit|rate limit|Execution error|API Error|Authentication' "${file}"; then
        echo "  -> looks like an error/auth message" >&2
        return 1
    fi
    return 0
}

#for CATEGORY in hep-ex quant-ph; do
for CATEGORY in quant-ph; do

    OUTPUT=${CATEGORY}/${DATE}.md
    echo "Fetching ${CATEGORY} with ${BACKEND}..."
    
    PROMPT="
    Please generate a summary of new arXiv papers under the ${CATEGORY} category in Japanese.
    Go through https://arxiv.org/list/${CATEGORY}/new, pick up 3 papers to summarize.
    Please reference the format of ${CATEGORY}/example.md in this repo.
    I am mostly expert in LHC/SUSY/dark matter etc. so feel free to do aggressively for hep-ex but more introduction is appreciated for other categories.
    For hep-ex, focus particularly on novel techniques/ideas, and dark matter/high frequency gravitational wave searches using cavity/quantum sensors.
    For quant-ph, I'm particularly interested in the hardware development and sensing application.
    IMPORTANT: Reply with ONLY the markdown summary itself (starting with the '# arXiv ...' heading) — no preamble or commentary.
    Do NOT write, create, edit, or delete any files; your reply text itself will be saved by the calling script.
    Always generate a fresh summary even if a file for today already exists in the repo."
    
    # Generate into a temp file first, so a failed run never clobbers the
    # existing good summary (and never gets committed/pushed).
    TMP="${OUTPUT}.tmp"
    call_ai "${PROMPT}" "${TMP}"
    if ! validate_summary "${TMP}"; then
        echo "ERROR: ${CATEGORY} summary invalid; keeping previous ${OUTPUT} and aborting." >&2
        if [ -f "${TMP}" ]; then
            echo "---- rejected output (first 5 lines) ----" >&2
            head -5 "${TMP}" >&2
        else
            echo "(no output file was produced)" >&2
        fi
        rm -f "${TMP}"
        exit 1
    fi
    mv "${TMP}" "${OUTPUT}"
    echo "Saved: ${OUTPUT}"

    # Feed to Slack (no-op if SLACK_WEBHOOK_URL is unset; never blocks the run).
    if [ -n "${SLACK_WEBHOOK_URL}" ]; then
        python3 "$(dirname "$0")/post_to_slack.py" "${OUTPUT}" \
            "arXiv ${CATEGORY} daily summary ${DATE}" \
            || echo "Slack post failed for ${OUTPUT} (continuing)." >&2
    fi
done


# Push to git 
git add .
git commit -m "arXiv daily summary ${DATE} [${BACKEND}]"
git push
echo "Done!"
