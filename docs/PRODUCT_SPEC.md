# Product Specification

## Visão

Criar um buscador universal de economia. A unidade central não é “cupom”, mas **oportunidade de economia**.

O usuário fornece uma intenção em linguagem natural. O produto deve interpretar o pedido, consultar fontes relevantes, remover ruído e responder com poucas opções comparáveis.

## Entradas suportadas

Exemplos:

- comprar um produto específico;
- reservar viagem para origem, destino e datas;
- alugar carro, smartphone ou equipamento;
- encontrar curso, faculdade ou pós-graduação com benefício;
- contratar serviço ou assinatura;
- encontrar cupom de uma loja ou marketplace;
- monitorar queda de preço ou nova promoção.

## Saída mínima de uma oferta

- comerciante/provedor;
- produto ou serviço;
- fonte;
- preço-base conhecido;
- desconto instantâneo;
- taxas conhecidas;
- preço a pagar agora;
- cashback/benefício posterior;
- custo efetivo;
- disponibilidade/contexto;
- condições relevantes;
- nível de validação;
- horário da última atualização.

## Níveis de validação

1. `checkout_verified` — aplicação confirmada por checkout/API equivalente.
2. `official` — dado publicado por fonte oficial/integração oficial.
3. `user_confirmed` — uso recente confirmado por usuários com evidência operacional.
4. `probable` — evidência recente, mas sem confirmação final.
5. `unverified` — encontrado, porém sem validação suficiente.

A UI nunca deve apresentar `probable` ou `unverified` como se fossem confirmados.

## Preço

Manter três números distintos quando aplicável:

- **base price** — referência antes de descontos;
- **pay now** — valor previsto no checkout;
- **effective cost** — pay now menos benefícios monetários posteriores elegíveis.

Cashback não reduz artificialmente “pay now”.

## Contexto

Cada categoria pode exigir contexto diferente: localização, datas, quantidade, ocupação, modelo, modalidade, campus, entrega, elegibilidade de cartão, novo cliente etc.

Conectores devem declarar capacidades e limitações.

## Fora da primeira fase

- app nativo;
- extensão de navegador;
- WhatsApp;
- automação de compra;
- tentativa de burlar anti-bot;
- ingestão massiva sem política de fonte;
- ranking baseado apenas em percentual de desconto.
