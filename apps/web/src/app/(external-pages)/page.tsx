import {
  BadgeCheck,
  Calculator,
  MapPin,
  Search,
  ShieldCheck,
  Sparkles,
} from 'lucide-react';

const examples = [
  'Tem cupom válido para Mercado Livre hoje?',
  'Passagem Rio → Miami de 10 a 20 de março',
  'Onde alugar um iPhone por 15 dias no Rio?',
  'MBA online em Cloud com bolsa ou desconto',
];

const principles = [
  {
    icon: BadgeCheck,
    title: 'Validação real',
    description:
      'Cada oferta informa se foi validada por checkout/API, veio de fonte oficial, foi confirmada por usuários ou ainda é apenas provável.',
  },
  {
    icon: MapPin,
    title: 'Contexto',
    description:
      'Local, datas, disponibilidade, produto correto e regras de elegibilidade entram antes do resultado ser recomendado.',
  },
  {
    icon: Calculator,
    title: 'Custo efetivo',
    description:
      'Separamos preço pago agora, taxas, desconto instantâneo e cashback posterior para comparar o que realmente custa menos.',
  },
];

export default function HomePage() {
  return (
    <div className="mx-auto flex w-full max-w-7xl flex-col px-4 py-16 sm:px-6 lg:px-8">
      <section className="mx-auto flex max-w-4xl flex-col items-center text-center">
        <div className="mb-6 inline-flex items-center gap-2 rounded-full border bg-muted/30 px-3 py-1 text-sm text-muted-foreground">
          <Sparkles className="size-4" aria-hidden="true" />
          Fundação técnica · nome provisório
        </div>

        <h1 className="text-balance text-4xl font-semibold tracking-tight sm:text-6xl">
          O que você quer economizar hoje?
        </h1>
        <p className="mt-5 max-w-2xl text-pretty text-base leading-7 text-muted-foreground sm:text-lg">
          Um único buscador para produtos, serviços, viagens, cursos, aluguel,
          marketplaces e outras categorias — com respostas refinadas e preço
          final calculado.
        </p>

        <div className="mt-10 flex w-full items-center gap-3 rounded-2xl border bg-background p-3 shadow-sm">
          <Search className="ml-2 size-5 shrink-0 text-muted-foreground" aria-hidden="true" />
          <div className="min-w-0 flex-1 text-left text-sm text-muted-foreground sm:text-base">
            Ex.: Quero comprar um notebook e encontrar o menor custo efetivo...
          </div>
          <div className="hidden rounded-xl bg-primary px-5 py-2.5 text-sm font-medium text-primary-foreground sm:block">
            Em construção
          </div>
        </div>

        <div className="mt-5 flex flex-wrap justify-center gap-2">
          {examples.map((example) => (
            <span
              key={example}
              className="rounded-full border bg-muted/20 px-3 py-1.5 text-xs text-muted-foreground"
            >
              {example}
            </span>
          ))}
        </div>
      </section>

      <section className="mt-20 grid gap-4 md:grid-cols-3">
        {principles.map(({ icon: Icon, title, description }) => (
          <article key={title} className="rounded-2xl border bg-card p-6">
            <div className="mb-4 flex size-10 items-center justify-center rounded-xl bg-primary/10 text-primary">
              <Icon className="size-5" aria-hidden="true" />
            </div>
            <h2 className="font-semibold">{title}</h2>
            <p className="mt-2 text-sm leading-6 text-muted-foreground">
              {description}
            </p>
          </article>
        ))}
      </section>

      <section className="mt-12 rounded-2xl border bg-muted/20 p-6">
        <div className="flex items-start gap-3">
          <ShieldCheck className="mt-0.5 size-5 shrink-0 text-primary" aria-hidden="true" />
          <div>
            <h2 className="font-semibold">Regra do produto</h2>
            <p className="mt-1 text-sm leading-6 text-muted-foreground">
              Resultado sem validação suficiente pode ser exibido como alternativa,
              mas nunca deve parecer tão confiável quanto uma oferta confirmada.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
