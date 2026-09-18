# Architecture

## Fluxo principal

```text
query
  ↓
Search Intent Engine
  ↓
Connector Router
  ↓
parallel connectors
  ↓
Normalization
  ↓
Context / availability filtering
  ↓
Validation Engine
  ↓
Effective Price Engine
  ↓
Deduplication + ranking
  ↓
refined results
```

## Módulos

### search

Transforma a entrada do usuário em `SearchIntent`. Não conhece APIs de parceiros.

### connectors

Cada integração implementa um contrato comum. O conector traduz `SearchIntent` para a API/fonte externa e retorna candidatos.

### offers

Modelo normalizado independente de Mercado Livre, Shopee, Booking, afiliados ou qualquer outra origem.

### validation

Registra como a oferta foi confirmada e quão fresca é a evidência.

### pricing

Calcula `payNow` e `effectiveCost`. Não decide relevância.

### ranking

Etapa futura que combina custo, validação, aderência ao contexto, confiança da fonte e frescor.

## Regra de dependência

Conectores dependem dos contratos centrais; os contratos centrais não dependem de nenhum conector.

Não criar arquivos como `mercado-livre-search-engine.ts` dentro do núcleo. A lógica específica de uma fonte pertence ao respectivo conector.

## Supabase

O projeto hospedado está em `sa-east-1`.

PR #2 definirá o schema de domínio e RLS. Até lá, Auth e infraestrutura permanecem herdados da base NextBase.
