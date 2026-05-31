# Watchlist-first workflow

User preference:
- When the user asks for a symbol/pair in TradingView, prefer the symbols saved in the *Lista de observação* (watchlist) before typing or searching manually.
- If the desired pair is already in the watchlist, select it from there to preserve the user's curated set of markets.
- Use manual search only if the pair is not present in the watchlist or the watchlist cannot be accessed.

Practical intent:
- Reduces symbol typos.
- Keeps the workflow aligned with the user's saved trading universe.

Observed session detail:
- In the active TradingView layout, the watchlist panel can be opened via the button labeled **"Lista de observação e detalhes e notícias"**.
- After selecting a saved pair (for example GBPUSD), the timeframe can be changed independently by clicking the interval button (for example **1h** for H1).
- When verifying the result, read the top-left chart label/timeframe rather than relying only on a URL change.
- See `references/watchlist-symbol-selection.md` for the click-vs-selection pitfall and the exact verification flow.
