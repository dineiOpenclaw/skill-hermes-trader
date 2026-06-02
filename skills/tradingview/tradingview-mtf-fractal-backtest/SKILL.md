---
name: tradingview-mtf-fractal-backtest
description: >-
  Experimental multi-timeframe framework for reading daily fractal, H1 range,
  and M5 CHoCH entries with 3:1 reward-to-risk. Use for backtesting only until
  the setup is validated.
---

# TradingView MTF Fractal Backtest

## Status

**Experimental / pending validation.**

This workflow is for testing and backtesting only. Do not treat it as a proven edge until enough examples are collected and reviewed.

## Core hierarchy

Use the following hierarchy for analysis:

- **Monthly → Daily**
- **Weekly → H4**
- **Daily → H1**
- **H4 → M15**
- **H1 → M5**
- **M15 → M1**

Interpretation:

- The higher timeframe defines the macro bias and liquidity target.
- The next lower parental timeframe defines the operating range.
- The child timeframe is used for confirmation and execution.

## Practical model

### Macro layer

1. Identify the **last valid daily fractal**.
2. Treat that daily fractal as the **macro reference**.
3. A bearish daily fractal implies the market is likely seeking **lower liquidity**.

### Intraday layer

1. Treat **H1** as the intraday trend/range inside the daily context.
2. Treat **M5** as the fractal/confirmation timeframe inside the H1 range.
3. Use **M5 CHoCH with displacement** to detect the end of the H1 correction or the end of the H1 impulse.

## Entry logic

For a valid setup:

1. Daily context is established.
2. H1 range is aligned with the macro bias.
3. M5 prints a **CHoCH**.
4. The CHoCH must come with **displacement**.
5. Execute the entry after confirmation of the displacement.

## Stop-loss rule

- After the M5 CHoCH, place the stop **beyond the extreme of the new M5 fractal created by the CHoCH**.
- For bearish setups, the stop goes **above the top** of that new M5 fractal.
- For bullish setups, mirror the logic and place the stop **below the bottom** of the new M5 fractal.

## Take-profit rule

- The default target is **3:1 reward-to-risk**.
- If the initial risk is `R`, then the target is `3R`.

## Backtest procedure

1. Start from the **daily chart**.
2. Mark the last valid daily fractal.
3. Drop to **H1** and define the operating range.
4. Drop to **M5** and look for the CHoCH.
5. Confirm displacement.
6. Mark the entry, stop, and 3R target.
7. Record:
   - symbol
   - date/time
   - direction
   - daily fractal context
   - H1 range boundaries
   - M5 CHoCH candle
   - stop price
   - target price
   - whether the target was reached before stop

## Validation rules

- Do not call the setup valid based on a single example.
- Collect multiple backtests before deciding whether the rule has edge.
- If the M5 CHoCH does not show displacement, skip the setup.
- If the H1 range is not aligned with the daily bias, skip the setup.

## Output expected from a test

When used in analysis, return:
- macro daily bias
- H1 range direction
- M5 CHoCH direction
- entry trigger
- stop location
- 3R target
- whether the setup is still only experimental
