# Watchlist symbol-selection pitfall

Session lesson:
- A watchlist row can appear selected or highlighted without the chart actually changing.
- Do not treat a symbol as opened until the chart header/top-left label updates to the new symbol and the URL/query state reflects it.

Observed DOM clues:
- Saved rows expose `data-symbol-full` and `data-symbol-short` (for example `OANDA:EURUSD` / `EURUSD`).
- The visible text may be nested several levels deep (`symbol-RsFlttSS`, `firstItem-RsFlttSS`, `inner-RsFlttSS`).

Recommended workflow:
1. Open the watchlist via **"Lista de observação e detalhes e notícias"** if needed.
2. Click the exact saved row for the desired pair.
3. Verify the chart actually switched by reading the header/top-left symbol and timeframe.
4. If the chart did not switch, retry on the exact row or use a direct symbol navigation fallback.
5. Change the timeframe separately after the symbol is confirmed.
