# Universal Savings Search

> Codinome técnico. O nome comercial será definido depois.

Buscador universal de economia para produtos, serviços, viagens, educação, aluguel, assinaturas e outras categorias.

O usuário descreve o que quer comprar, contratar, reservar ou alugar. O sistema consulta conectores adequados, normaliza ofertas, valida contexto e desconto e devolve poucas respostas refinadas com **preço final** e **custo efetivo**.

## Princípios do produto

1. **Busca generalista** — Mercado Livre, Shopee, varejo, cursos, faculdades, viagens, hotéis, locação, SaaS e novos verticais entram pelo mesmo modelo.
2. **Validação explícita** — distinguir cupom validado, fonte oficial, confirmação de usuários e oferta apenas provável.
3. **Contexto real** — considerar local, datas, disponibilidade, elegibilidade e restrições sempre que a categoria exigir.
4. **Preço final** — não ranquear apenas por “% OFF”. Separar valor pago agora, cashback posterior e custo efetivo.
5. **Respostas refinadas** — eliminar duplicados e resultados incompatíveis antes de mostrar as melhores alternativas.
6. **Conectores desacoplados** — novas fontes devem ser adicionadas sem reescrever o motor central.

## Stack

- Next.js 16 + React 19
- TypeScript
- Supabase Postgres + Auth + RLS
- Tailwind CSS + shadcn/ui
- Vitest + Playwright
- Turborepo + pnpm

A fundação deriva do [NextBase Starter](https://github.com/imbhargav5/nextbase-nextjs-supabase-starter), distribuído sob licença MIT. A licença original é preservada neste repositório.

## Supabase

Projeto hospedado:

- project ref: `oeiweoxcjztvmmeoyccq`
- região: `sa-east-1`
- URL: `https://oeiweoxcjztvmmeoyccq.supabase.co`

A chave publishable é segura para uso no cliente, mas credenciais privilegiadas nunca devem ser versionadas.

## Desenvolvimento

```bash
pnpm install
cp .env.local.example .env.local
pnpm web#dev
```

Para o stack Supabase local, use `.env.development.local.example` e os comandos `database#start` / `supabase:sync-env`.

## Sequência planejada

- PR #1 — fundação técnica, configuração e contratos de domínio
- PR #2 — schema universal: merchants, sources, offers, coupons, prices e validations
- PR #3 — Search Intent Engine
- PR #4 — Connector Framework executável
- PR #5 — primeiro conector real
- PR #6 — normalização e deduplicação
- PR #7 — Validation Engine
- PR #8 — Effective Price Engine integrado à busca
- PR #9 — interface de busca e resultados reais
- PR #10 — favoritos, watchlists e alertas

Veja `docs/PRODUCT_SPEC.md` e `docs/ARCHITECTURE.md`.
