---
name: tradingview-integration-runbook
description: Use when another agent needs to reproduce the TradingView Desktop + MCP integration on Windows, including launcher .bat creation, skill installation, code fixes, and verification steps.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [tradingview, windows, mcp, launcher, bat, forex, setup]
    related_skills: [tradingview, tradingview-pine, tradingview-replay, tradingview-watchlist-selection, github-repo-management]
---

# TradingView Desktop + MCP Integration Runbook

## Overview

This skill documents the exact integration path used to connect TradingView Desktop to Hermes on Windows, so another agent can reproduce the setup from scratch.

The workflow combines three pieces:

1. TradingView Desktop running with Chrome DevTools Protocol on port `9222`
2. A launcher `.bat` that reliably starts TradingView on Windows
3. A PineScript MCP server that Hermes can connect to and use for TradingView/PineScript tasks

The process also includes the specific skill installs, repository links, code fixes, and verification steps that were required to make the integration work in practice.

## When to Use

- Reproducing the TradingView connection on a new Windows machine
- Rebuilding the same setup for a fresh Hermes profile
- Documenting the exact launcher and MCP server adjustments used for TradingView automation
- Onboarding another agent to the same workflow without context from previous sessions

## Source Repositories and Skills

The following upstream repositories were used:

- TradingView CLI / skills repository:
  - https://github.com/kml93/tradingview-cli
- PineScript MCP server:
  - https://github.com/cklose2000/pinescript-mcp-server

The TradingView-related skills installed from the TradingView CLI repository were:

- `tradingview`
- `tradingview-pine`
- `tradingview-replay`

A custom TradingView workflow skill was also created locally:

- `tradingview-watchlist-selection`

## Required Local Layout

The integration was validated in the active `trader` profile, with the following important paths:

- TradingView portable extraction:
  - `C:\Users\Hermes\AppData\Local\hermes\profiles\trader\external\TradingViewPortable\TradingView.exe`
- PineScript MCP repo:
  - `C:\Users\Hermes\AppData\Local\hermes\profiles\trader\external\pinescript-mcp-server`
- TradingView launcher `.bat`:
  - `C:\Users\Hermes\Desktop\start-tradingview-cdp.bat`
- PineScript MCP launcher `.bat`:
  - `C:\Users\Hermes\AppData\Local\hermes\profiles\trader\external\pinescript-mcp-server\run-pinescript-mcp.bat`

## Procedure

### 1) Install the TradingView skills

Install the TradingView-related skills from the TradingView CLI repository:

- `tradingview`
- `tradingview-pine`
- `tradingview-replay`

These skills are the control surface for chart handling, PineScript work, and replay workflows.

### 2) Prepare TradingView Desktop for remote debugging

On this Windows setup, TradingView Desktop was installed as an MSIX/AppX package. The workable solution was:

1. Extract the MSIX into a user-writable portable directory
2. Prefer the portable `TradingView.exe`
3. Start TradingView with `--remote-debugging-port=9222`
4. Verify the CDP endpoint before trying to control the chart

The launcher logic should prefer sources in this order:

1. `TradingViewPortable\TradingView.exe`
2. AppX `InstallLocation`
3. Any fallback install location available on the machine

### 3) Create the TradingView `.bat`

The launcher should do the following:

- locate the executable
- start TradingView with `--remote-debugging-port=9222`
- avoid relying on the Store app path alone
- keep the launch process simple and repeatable

After launch, verify the debugging endpoint:

```bash
curl http://127.0.0.1:9222/json/version
```

Do not assume the app is ready until that endpoint responds with a valid `webSocketDebuggerUrl`.

### 4) Connect TradingView through CDP

Once the endpoint is live, the agent can attach through the browser/CDP flow and control the chart.

The important checks are:

- TradingView window exists
- `127.0.0.1:9222` responds
- the chart tab appears in `http://127.0.0.1:9222/json/list`
- the active chart URL can be inspected and manipulated

### 5) Install and repair the PineScript MCP server

Clone the PineScript MCP repository and install dependencies.

Repository:

- https://github.com/cklose2000/pinescript-mcp-server

During setup, the project required several adjustments before it could run reliably in this environment.

#### Adjustments made

- fixed a Zod typing issue in `src/config/configTool.ts`
  - changed `z.record(z.any())` to `z.record(z.string(), z.any())`
- fixed ESM import paths to include `.js` where needed
  - `src/fixers/errorFixer.ts`
  - `src/config/configTool.ts`
- created a local shim file:
  - `src/patched-protocol.ts`
- installed missing dependencies:
  - `commander`
  - `fastmcp`
  - `zod`
  - `@supabase/supabase-js`
  - `openai`
  - `@anthropic-ai/sdk`
  - `@types/node-fetch`
  - `@modelcontextprotocol/sdk`
- installed `tsx` so the server could run directly from TypeScript during development
- created a launcher:
  - `run-pinescript-mcp.bat`
- used the launcher to start the server with `npx tsx src/index.ts`

### 6) Verify the MCP server starts cleanly

The expected startup behavior is similar to:

- `Starting PineScript MCP server with extended timeout (5 minutes)`
- `Starting PineScript MCP server...`
- `PineScript MCP server started successfully`

After startup, confirm Hermes sees the server and its tools.

The final connection state should expose the PineScript MCP toolset to Hermes.

### 7) Validate the TradingView chart control path

Once TradingView and the MCP server are both working, validate the chart path end-to-end.

The key chart behavior rules that were learned during validation:

- prefer the saved pair in **Lista de observação** first
- if the pair is not in the watchlist, use manual search
- for forex manual search, always use the `OANDA:` prefix
  - example: `OANDA:EURUSD`
- after the symbol and timeframe are set, close the watchlist
- after that, redefine the chart view

### 8) Confirm the chart state visually

Use screenshots or DOM inspection to confirm:

- symbol is correct
- timeframe is correct
- watchlist is closed
- chart view is reset

For the successful validation in this setup, the chart was opened as:

- `EURUSD`
- `M5`

## Common Pitfalls

1. **TradingView installed as MSIX/AppX only**
   - The Store install path is not always practical.
   - Prefer a portable extraction that the agent can launch directly.

2. **No `tv` command in PATH**
   - Do not rely on the CLI binary being available.
   - Use the launcher + CDP route.

3. **CDP not yet listening**
   - Always verify `http://127.0.0.1:9222/json/version` before assuming the browser can be controlled.

4. **MCP build/runtime errors**
   - ESM imports without extensions and missing compiled files were a source of failure.
   - The launcher + TypeScript runtime approach was the practical workaround.

5. **Watchlist row highlighted but chart unchanged**
   - A selected row is not enough.
   - Verify the chart header and URL actually changed.

## Verification Checklist

- [ ] TradingView Portable exists at the expected path
- [ ] TradingView starts with `--remote-debugging-port=9222`
- [ ] `http://127.0.0.1:9222/json/version` responds
- [ ] The chart tab is visible in `json/list`
- [ ] The PineScript MCP server starts from `run-pinescript-mcp.bat`
- [ ] Hermes connects to the MCP server
- [ ] TradingView skills are installed
- [ ] Watchlist-first selection works
- [ ] Forex manual search uses `OANDA:`
- [ ] After symbol + timeframe are set, the watchlist is closed
- [ ] The chart view is redefined
- [ ] The final chart state is confirmed visually
