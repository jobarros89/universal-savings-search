# Search Intent Engine

## Objetivo

Transformar uma pergunta em linguagem natural em uma intenção estruturada e estável para o restante do sistema.

O motor central não conhece Mercado Livre, Shopee, Booking ou qualquer outra fonte. Ele produz um `ParsedSearchIntent`; o Connector Router usa esse contrato para decidir quais conectores consultar.

## Primeira implementação

A primeira implementação é deliberadamente determinística e sem dependência de LLM:

- identifica intenção: compra, aluguel, viagem, educação, reserva, assinatura ou serviço;
- identifica categorias iniciais;
- detecta pedido de cupom/desconto;
- detecta preferência explícita por marketplace;
- extrai localização simples;
- extrai rota;
- normaliza datas;
- detecta campos obrigatórios ausentes;
- calcula confiança;
- sinaliza quando precisa de esclarecimento.

Isso cria uma baseline testável. Um interpretador com IA poderá implementar a mesma interface posteriormente.

## Exemplos

```text
Tem cupom para Mercado Livre hoje?
→ buy / couponRequested / preferredMerchant=mercado_livre

Quero alugar um iPhone no Rio por 15 dias
→ rent / smartphone / location=Rio

Passagem Rio → Miami de 10/01 a 20/01
→ travel / flight / Rio / Miami / datas estruturadas
```

## Regra importante

Nenhum conector deve interpretar linguagem natural por conta própria.

```text
texto do usuário
      ↓
Search Intent Engine
      ↓
ParsedSearchIntent
      ↓
Connector Router
      ↓
connectors
```

## Próxima evolução

Adicionar um interpretador por LLM para casos ambíguos e entidades complexas, mantendo fallback determinístico e o mesmo contrato.
