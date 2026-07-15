#!/bin/bash
# Generate the LaunchAgent plist from the template and (re)install it.
#
# Repo path resolution:
#   1. ARXIV_REPO environment variable, if set
#   2. otherwise the directory containing this script
#
# Usage:
#   ./install_launchd.sh              # auto-detect repo path
#   ARXIV_REPO=/path/to/repo ./install_launchd.sh
set -euo pipefail

LABEL="com.cshion.arxivsummaryfeeds"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="${ARXIV_REPO:-${SCRIPT_DIR}}"
TEMPLATE="${SCRIPT_DIR}/${LABEL}.plist.template"
DEST="${HOME}/Library/LaunchAgents/${LABEL}.plist"

if [ ! -f "${TEMPLATE}" ]; then
    echo "Template not found: ${TEMPLATE}" >&2
    exit 1
fi

mkdir -p "${HOME}/Library/LaunchAgents"

# Substitute the repo path into the template.
sed "s|__REPO__|${REPO}|g" "${TEMPLATE}" > "${DEST}"

# Validate before loading.
plutil -lint "${DEST}"

# Reload (unload old definition if present, then load the new one).
launchctl unload "${DEST}" 2>/dev/null || true
launchctl load "${DEST}"

echo "Installed and loaded ${LABEL} (repo: ${REPO})"
launchctl list | grep "${LABEL}" || echo "WARNING: not listed after load" >&2
