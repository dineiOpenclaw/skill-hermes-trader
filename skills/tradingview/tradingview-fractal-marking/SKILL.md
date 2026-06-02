---
name: tradingview-fractal-marking
description: >-
  Workflow para identificar e marcar fractais/topos/fundos no TradingView com a ferramenta Raio horizontal.
---

# TradingView Fractal Marking

Use esta skill quando o usuário pedir para:
- identificar um fractal
- localizar topo ou fundo
- marcar um nível relevante no gráfico
- confirmar um ponto estrutural em um timeframe do TradingView

## Regra principal

Sempre que o pedido for sobre fractal, topo ou fundo, **não responda só com o preço**.
Antes de finalizar, **marque o nível no gráfico com a ferramenta `Raio horizontal`** e então confirme o valor ao usuário.

## Workflow

1. Abrir ou focar o gráfico correto no TradingView.
2. Confirmar símbolo e timeframe no cabeçalho do gráfico.
3. Identificar o fractal/topo/fundo solicitado.
4. Selecionar a ferramenta **Raio horizontal**.
5. Posicionar a marcação no preço do nível identificado.
6. Verificar visualmente que a linha/raio ficou no gráfico.
7. Responder ao usuário com o nível marcado e uma leitura objetiva.

## Boas práticas

- Se houver mais de um candidato, priorize o fractal mais recente e válido pela estrutura do timeframe pedido.
- Sempre valide no gráfico depois de desenhar.
- Se o símbolo/timeframe estiver errado, corrija antes de marcar.
- Se o usuário pedir múltiplos níveis, marque todos com Raio horizontal.

## Pitfalls

- Não assumir que o desenho foi aplicado sem checar o gráfico.
- Não responder apenas de memória quando a intenção é marcar no chart.
- Não misturar timeframe de leitura com timeframe de execução sem avisar.
- Se a ferramenta não responder, revalidar o estado do TradingView antes de tentar novamente.

## Saída esperada

Ao final, forneça:
- tipo do fractal: topo ou fundo
- preço aproximado
- confirmação de que o nível foi marcado no gráfico
