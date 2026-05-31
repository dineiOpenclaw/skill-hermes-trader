# TradingView watchlist selection + view reset workflow

Session-tested notes for selecting forex pairs from the watchlist and normalizing the chart afterward.

## Watchlist-first selection
- Prefer a saved pair from **Lista de observação** before any manual search or direct symbol entry.
- If the sidebar is collapsed, open **"Lista de observação e detalhes e notícias"** first.
- Saved rows often expose:
  - `data-symbol-full` (example: `OANDA:EURUSD`)
  - `data-symbol-short` (example: `EURUSD`)

## Verification rule
- A highlighted row is not enough.
- Treat the symbol as changed only after the chart header/top-left label updates and the URL/query state reflects the new symbol.
- If the chart did not switch, retry the exact row or use direct navigation as fallback.

## Close the watchlist after selection
- After the pair is selected and confirmed, close the watchlist panel.
- Do not leave the sidebar open unless another selection is needed.

## Timeframe handling
- Change the timeframe separately after the symbol is confirmed.
- For M5, use the `5m` interval / `tv timeframe 5` equivalent.

## Reset chart view
- When the user asks to normalize or reset the chart view, use the chart control whose title is **"Redefinir visão do gráfico"**.
- This is useful after selection or when the visible scale/pan looks stale.

## Useful UI clues
- Watchlist toggle aria-label: **"Lista de observação e detalhes e notícias"**
- Reset view control title: **"Redefinir visão do gráfico"**
- Visible watchlist text can be misleading; rely on the chart header and URL for confirmation.
