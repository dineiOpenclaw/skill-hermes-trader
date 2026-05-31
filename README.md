# skill-hermes-trader

Este repositório guarda cópias das skills customizadas criadas/ajustadas para o perfil `trader` do Hermes.

## Convenção

- As skills ficam em `skills/`, preservando a mesma estrutura usada no Hermes.
- Sempre que uma skill for criada ou alterada, a cópia correspondente deve ser atualizada aqui.
- O foco inicial é manter um espelho das skills de TradingView/Forex e das skills customizadas futuras.

## Estrutura

- `skills/` — cópias das skills
- `scripts/` — utilitários de sincronização

## Sincronização

Para copiar uma skill do perfil Hermes para este repositório:

```bash
./scripts/sync_skill.sh tradingview
./scripts/sync_skill.sh tradingview/tradingview-watchlist-selection
```

O script preserva o caminho relativo completo da skill dentro de `skills/`.
