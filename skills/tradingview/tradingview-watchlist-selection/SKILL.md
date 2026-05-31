---
name: tradingview-watchlist-selection
description: >-
  Procedure for selecting a forex pair in TradingView from the watchlist and
  verifying that the chart actually switched before changing timeframe.
---

# TradingView watchlist selection procedure

Use this skill when the user asks to open or change a pair on TradingView.

## Goal
Select the desired pair from the saved watchlist first, then verify the chart truly changed, and only after that switch the timeframe.

## Procedure

1. **Open the watchlist if it is hidden**
   - Click **"Lista de observação e detalhes e notícias"** if the sidebar is collapsed.

2. **Prefer the saved watchlist pair**
   - Use the row already saved in the watchlist before any manual search or direct symbol typing.
   - Prefer the exact saved row whose DOM exposes:
     - `data-symbol-full` (example: `OANDA:EURUSD`)
     - `data-symbol-short` (example: `EURUSD`)

3. **Click the exact row for the pair**
   - Do not rely only on a visible highlight.
   - Some rows can appear selected without changing the chart.

4. **Fallback to manual search only if the pair is not found in the watchlist**
   - For forex, manually search using the `OANDA:` server prefix.
   - Example: `OANDA:EURUSD`

5. **Close the watchlist after selecting the pair**
   - After the pair is selected and the chart is confirmed, close the **"Lista de observação"** panel.
   - Do not leave the watchlist open unless it is needed for another selection.

6. **Verify the chart actually switched**
   - Confirm the chart header/top-left symbol label matches the desired pair.
   - Confirm the URL/query state reflects the new symbol.
   - If the chart did not switch, retry the exact row.
   - If needed, use direct symbol navigation as a fallback only after the watchlist attempt.

7. **Change timeframe separately**
   - After the symbol is confirmed, change the timeframe.
   - For `M5`, use the `5m` interval.
   - Do not assume the symbol click also changed the timeframe.

8. **Redefine the chart view after symbol and timeframe are set**
   - Click **"Redefinir visão do gráfico"**.
   - This should happen after the pair and timeframe are both confirmed.

7. **Change timeframe separately**

   - For `M5`, use the `5m` interval.
   - Do not assume the symbol click also changed the timeframe.

## Important pitfall
A watchlist row can be visually highlighted while the chart remains on the previous symbol. Treat the change as incomplete until the chart header/top-left label and URL both confirm the new pair.

## Validation checklist
- Watchlist row is the saved pair
- Chart header/top-left label shows the new pair
- URL/query state shows the new symbol
- Timeframe is changed separately and confirmed
