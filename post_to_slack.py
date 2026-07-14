#!/usr/bin/env python3
"""Post an arXiv summary Markdown file to Slack via an Incoming Webhook.

Usage:
    SLACK_WEBHOOK_URL=... ./post_to_slack.py <markdown_file> [<header>]

The webhook URL is read from the SLACK_WEBHOOK_URL environment variable.
The Markdown is lightly converted to Slack "mrkdwn" and split into chunks
(Slack rejects/truncates very long messages), then posted in order.
"""
import json
import os
import re
import sys
import time
import urllib.request

# Slack allows up to 40000 chars in `text`, but keeping chunks small renders
# more reliably and avoids server-side truncation.
MAX_CHARS = 3500

# Divider hierarchy (rendered as-is in Slack mrkdwn), strongest to lightest:
POST_RULE = "═" * 30    # between separate posts (added in main, not here)
SECTION_RULE = "━" * 26  # source "---" -> long section divider
ENTRY_RULE = "┈" * 12    # inserted between paper entries (### headings)


def md_to_mrkdwn(text: str) -> str:
    """Convert a subset of Markdown to Slack mrkdwn."""
    out_lines = []
    # Track whether a paper entry (### heading) has already appeared in the
    # current section, so we only put a rule *between* entries.
    seen_entry_in_section = False
    for line in text.splitlines():
        # Markdown links [text](url) -> Slack <url|text>
        line = re.sub(r"\[([^\]]+)\]\((https?://[^)]+)\)", r"<\2|\1>", line)
        # Bold **text** -> *text*  (do this before header handling)
        line = re.sub(r"\*\*([^*]+)\*\*", r"*\1*", line)
        # Horizontal rule --- -> a long section divider; resets entry tracking
        if line.strip() == "---":
            out_lines.append(SECTION_RULE)
            seen_entry_in_section = False
            continue
        # Headers (# .. ######) -> bold line
        m = re.match(r"^(#{1,6})\s+(.*)$", line)
        if m:
            level = len(m.group(1))
            if level >= 3:
                # Paper entry: add a short rule before all but the first one.
                if seen_entry_in_section:
                    out_lines.append("")
                    out_lines.append(ENTRY_RULE)
                seen_entry_in_section = True
            else:
                # A higher-level header starts a fresh section.
                seen_entry_in_section = False
            out_lines.append("*" + m.group(2).strip() + "*")
            continue
        out_lines.append(line)
    return "\n".join(out_lines)


def chunk(text: str, limit: int = MAX_CHARS):
    """Split text into chunks <= limit, never breaking a line."""
    chunks, cur = [], ""
    for line in text.splitlines(keepends=True):
        if cur and len(cur) + len(line) > limit:
            chunks.append(cur)
            cur = ""
        cur += line
    if cur:
        chunks.append(cur)
    return chunks


def post(webhook: str, text: str) -> None:
    data = json.dumps({"text": text}).encode("utf-8")
    req = urllib.request.Request(
        webhook, data=data, headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = resp.read().decode("utf-8", "replace")
        if body.strip() != "ok":
            raise RuntimeError(f"Slack responded: {body!r}")


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: post_to_slack.py <markdown_file> [header]", file=sys.stderr)
        return 2

    webhook = os.environ.get("SLACK_WEBHOOK_URL", "").strip()
    if not webhook:
        print("SLACK_WEBHOOK_URL not set; skipping Slack post.", file=sys.stderr)
        return 0

    path = sys.argv[1]
    header = sys.argv[2] if len(sys.argv) > 2 else ""

    with open(path, encoding="utf-8") as f:
        body = md_to_mrkdwn(f.read())

    # Drop leading/trailing divider lines so they don't stack with the
    # post divider and header we add below.
    lines = body.splitlines()
    while lines and lines[0].strip() in ("", SECTION_RULE, ENTRY_RULE):
        lines.pop(0)
    while lines and lines[-1].strip() in ("", SECTION_RULE, ENTRY_RULE):
        lines.pop()
    body = "\n".join(lines)

    # A strong divider separates this post from the previous one in the
    # channel; it goes on the first message only (not on continuation chunks).
    parts = [POST_RULE]
    if header:
        parts.append(f"*{header}*")
    parts.append(body)
    body = "\n".join(parts)

    chunks = chunk(body)
    for i, part in enumerate(chunks):
        # Add a small continuation marker so multi-part posts read cleanly.
        if len(chunks) > 1 and i > 0:
            part = f"_(続き {i + 1}/{len(chunks)})_\n{part}"
        post(webhook, part)
        time.sleep(0.5)  # be gentle with Slack rate limits

    print(f"Posted {len(chunks)} message(s) to Slack: {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
