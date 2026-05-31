---
name: tradingview
description: >-
  TradingView Desktop control via CLI. Use when working with charts, Pine Script, indicators, replay, screenshots, price data, or any TradingView interaction. Trigger phrases: "tradingview", "my chart", "pine script", "tv", "screenshot chart", "what's the price", "change symbol", "indicators".
---

# TradingView CLI

Control TradingView Desktop via the `tv` command. Auto-detects CDP port.

## Quick Reference

```bash
tv status                         # check connection
tv state                          # symbol, timeframe, indicators
tv quote                          # current price
tv symbol <TICKER>                # change symbol (AAPL, ES1!, BTCUSD)
tv timeframe <TF>                 # change timeframe (1, 5, 15, 60, D, W)
tv type <TYPE>                    # chart type (Candles, Line, HeikinAshi, Area, Renko)
tv ohlcv --summary                # compact price stats
tv screenshot -r chart            # capture chart region
tv info                           # symbol metadata
tv search <QUERY>                 # search symbols
```

## Decision Tree

### "What's on my chart?"
1. `tv state` → symbol, timeframe, chart type, indicator list with IDs
2. `tv values` → current indicator values (RSI, MACD, BBands, EMAs)
3. `tv quote` → real-time price, OHLC, volume

### "Analyze my chart" (full workflow)
1. `tv quote` → current price
2. `tv values` → all indicator readings
3. `tv data lines` → price levels from custom indicators
4. `tv data labels` → text annotations with prices
5. `tv data tables` → session stats, analytics tables
6. `tv ohlcv --summary` → price action summary
7. `tv screenshot -r chart` → visual confirmation

### "Change the chart"
- Prefer the user's *Lista de observação* (watchlist) when selecting a symbol/pair. Use a saved symbol from the watchlist before manual search or direct typing whenever possible.
- If the watchlist is collapsed, open the sidebar entry labeled **"Lista de observação e detalhes e notícias"** first, then select the exact saved-row entry for the symbol.
- If the desired pair is not found in the watchlist, search manually.
- For forex manual search, always use the OANDA server prefix, for example `OANDA:EURUSD`.
- For TradingView's watchlist UI, prefer the row whose DOM exposes the saved symbol as `data-symbol-full` / `data-symbol-short`. A visible row may be highlighted/selected without actually changing the chart, so treat the chart as unchanged until the chart header updates.
- After choosing the symbol, verify the chart header/top-left symbol label *and* the interval label. If the chart did not switch, do not assume the click worked; retry on the exact row or fall back to direct symbol navigation.
- After the pair is selected and the timeframe is confirmed, close the watchlist panel.
- After the pair and timeframe are set, click **"Redefinir visão do gráfico"**.
- Switch the timeframe separately by clicking the chart interval buttons (for example **5m** for M5, **1h** for H1) or using `tv timeframe 5` / `tv timeframe 60` when the CLI is available.
- Verify the result by checking the chart header/top-left symbol label and timeframe before proceeding.
- `tv symbol AAPL` → switch ticker

- `tv timeframe D` → switch resolution
- `tv type Candles` → switch chart style
- `tv scroll 2025-01-15` → jump to date
- `tv range --from 1700000000 --to 1710000000` → zoom to range

See `references/watchlist-first.md` for the user-specific workflow note, `references/watchlist-symbol-selection.md` for the watchlist-click verification pitfall, and `references/watchlist-selection-workflow.md` for the tested watchlist-first + close-panel + reset-view flow.

### "Work on Pine Script"
→ Use the tradingview-pine skill for the full development loop

### "Practice trading"
→ Use the tradingview-replay skill for replay mode

### "Draw on chart"
```bash
tv draw shape --type horizontal_line --price 24500
tv draw shape --type trend_line --x1 <ts> --y1 <price> --x2 <ts> --y2 <price>
tv draw shape --type text --text "Key level" --price 24500
tv draw list                      # see drawings
tv draw remove-one --id <id>      # remove one
tv draw clear                     # remove all
```

### "Manage indicators"
```bash
tv indicator add --name "Relative Strength Index"    # USE FULL NAMES, not "RSI"
tv indicator add --name "Moving Average Exponential"
tv indicator remove --id <entity_id>
tv indicator toggle --id <entity_id>
tv indicator set --id <entity_id> --input length=200
```

### "Multi-pane layouts"
```bash
tv pane list                      # list panes
tv pane layout 2x2               # set grid (s, 2h, 2v, 2x2, 4, 6, 8)
tv pane focus 0                   # focus pane by index
tv pane symbol 1 ES1!             # set symbol on pane
```

### "Alerts"
```bash
tv alert list
tv alert create --condition crossing --value 24500
tv alert delete --id <id>
```

### "Screenshots"
```bash
tv screenshot                     # full window
tv screenshot -r chart            # chart only
tv screenshot -r strategy_tester  # strategy tester panel
```

## Context Management

- Always use `--summary` on `tv ohlcv` unless individual bars are needed
- Prefer `tv screenshot` for visual context over large data pulls
- Call `tv state` once at start, reuse entity IDs from the result
- Avoid `tv pine get` on complex scripts (can return 200KB+)
- **Free plan limit**: 2 indicators per chart max. Remove indicators before adding more.
- On Windows, if TradingView Desktop is installed as an Appx/Microsoft Store app, prefer a launcher that targets a user-writable portable extraction of the MSIX first, then falls back to the AppX `InstallLocation`, and only then to the Start-app AppID path if needed. Always start the executable with `--remote-debugging-port=9222`, then verify the endpoint with `curl http://127.0.0.1:9222/json/version` before assuming the skill can attach. See `references/windows-launch.md`.

## Indicator Management Gotchas

- `tv indicator add --name "X"` only works for built-in/community indicators, NOT user scripts
- To add a user script: use the Pine Editor workflow (`tv pine set` → `tv pine compile` → click "Add to chart")
- `tv indicator remove --id <id>` is reliable — always clean up before adding to avoid hitting the 2-indicator limit
- `tv state` shows entity IDs — always capture these after `tv state` for subsequent remove/toggle operations

## `tv ui eval` — JavaScript Execution

Execute arbitrary JS on the TradingView page. Useful for clicking buttons that the CLI can't reach.

```bash
# Basic usage
tv ui eval --js "document.title"

# Click a button by text
tv ui eval --js "const target = [...document.querySelectorAll('button')].find(b => b.textContent.includes('Add to chart')); if (target) { target.click(); 'Clicked'; } else { 'Not found'; }"
```

**CRITICAL: Variable naming** — `tv ui eval` persists JS context between calls. Never reuse variable names:
```bash
# ❌ FAILS on second call — 'btns' already declared
tv ui eval --js "const btns = [...document.querySelectorAll('button')]; btns.length"

# ✅ Use unique names each call
tv ui eval --js "const allButtons = [...document.querySelectorAll('button')]; allButtons.length"
```

## Screenshot Caveat

CDN URLs returned by `tv screenshot` may be cached. When comparing screenshots, rely on the local file path, not the CDN URL. Use `Read` tool on the local path to view the image.

## Indicator Names

MUST use full names:
- "Relative Strength Index" (not RSI)
- "Moving Average Exponential" (not EMA)
- "Bollinger Bands" (not BB)
- "Moving Average" (for SMA)
- "Average True Range" (not ATR)
- "Volume" (not VOL)

## Data Commands

```bash
tv data lines                     # price levels from custom indicators
tv data labels                    # text annotations with prices
tv data tables                    # session stats, analytics tables
tv data boxes                     # price zones
tv data strategy                  # strategy performance metrics
tv data trades                    # trade list
tv data equity                    # equity curve
tv data depth                     # order book depth
tv data indicator                 # indicator data
```

All `tv data` commands accept `--filter <name>` to target a specific indicator.
