---
name: telegram-print-send
description: Use when the user asks for a print/screenshot to be captured and delivered on Telegram. Capture the image, verify the file path, and send it as native media instead of a broken text link.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [telegram, screenshot, media, delivery, verification]
    related_skills: [tradingview, dogfood]
---

# Telegram Screenshot Delivery

## Overview

Use this skill when the user wants a screenshot, print, or visual capture sent into Telegram. The main goal is to avoid the common failure mode where the assistant writes a `MEDIA:` string in chat instead of delivering the file through `send_message`.

The correct workflow is:
1. Capture or locate the screenshot file.
2. Verify the file exists and is readable.
3. Send it with `send_message` using a `MEDIA:` attachment.
4. Confirm the send result before telling the user it was delivered.

## When to Use

- The user says: "manda o print", "envia a captura", "tira um print e manda aqui".
- A browser or app screenshot already exists and must be delivered on Telegram.
- You need to send a chart, terminal output, or visual proof as native media.

## Core Rules

### 1) Never rely on plain text `MEDIA:` in a normal chat reply
A plain assistant message like `MEDIA:/path/file.png` may not render as an attachment in the target channel. For Telegram delivery, use the `send_message` tool.

### 2) Prefer an existing screenshot path when available
If another tool already produced a screenshot file, reuse that exact absolute path after verifying it exists.

### 3) Verify before sending
Check the file path first so you do not send a missing or stale file.

Recommended checks:
- file exists
- file size is non-zero
- the filename matches the intended target image

### 4) Send as native media
Use this pattern:

```text
send_message(
  target="telegram",
  message="Print do gráfico:\nMEDIA:/absolute/path/to/image.png"
)
```

For a clean delivery, keep the message short and put the `MEDIA:` token on its own line when possible.

### 5) Confirm the delivery result
Only tell the user it was sent after `send_message` returns success and a `message_id`.

## Preferred Workflow

### A. If a screenshot already exists
1. Identify the image path.
2. Verify the path with a file check.
3. Send using `send_message` to the correct Telegram target.
4. Report success briefly.

### B. If you need to capture the screenshot first
1. Capture the screenshot with the relevant tool:
   - browser page → use browser screenshot / vision tools
   - app window already visible → use the available screenshot workflow for that surface
2. Save or locate the resulting file path.
3. Verify it exists.
4. Deliver it with `send_message`.

## Common Pitfalls

1. **Posting `MEDIA:` directly in the assistant reply.**
   - This can fail to render as an actual attachment.
   - Fix: use `send_message`.

2. **Using a relative path.**
   - Telegram delivery should use an absolute path.
   - Fix: pass the full file path.

3. **Sending a deleted or stale screenshot.**
   - The file may have been cleaned up from temp storage.
   - Fix: check the file exists right before sending.

4. **Not confirming the send result.**
   - A successful tool call is the only proof of delivery.
   - Fix: verify the `send_message` response and message ID.

5. **Trying to describe the screenshot instead of delivering it.**
   - The user asked for the image, not a summary.
   - Fix: send the actual media.

## Verification Checklist

- [ ] Screenshot file exists
- [ ] Path is absolute
- [ ] File is the intended image
- [ ] `send_message` used for Telegram delivery
- [ ] Tool returned success
- [ ] `message_id` or equivalent confirmation recorded
- [ ] User is told the print was sent, not that it "should" be sent
