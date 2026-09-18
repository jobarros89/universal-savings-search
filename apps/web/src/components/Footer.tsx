import Link from 'next/link';

import { Brand } from '@/components/brand';
import { Button } from '@/components/ui/button';
import { Separator } from '@/components/ui/separator';

const footerLinks = [
  { href: '/about', label: 'Sobre' },
  { href: '/login', label: 'Entrar' },
  { href: '/sign-up', label: 'Criar conta' },
];

export default function Footer() {
  return (
    <footer className="border-t bg-muted/20">
      <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
        <div className="grid gap-8 md:grid-cols-[1fr_auto] md:items-start">
          <div className="max-w-md space-y-3">
            <Link href="/" aria-label="Página inicial" className="inline-flex">
              <Brand showTagline />
            </Link>
            <p className="text-sm leading-6 text-muted-foreground">
              Buscador universal de economia com validação, contexto e cálculo
              de custo efetivo.
            </p>
          </div>
          <div className="flex flex-wrap items-center gap-1 md:justify-end">
            {footerLinks.map((item) => (
              <Button key={item.href} variant="ghost" size="sm" asChild>
                <Link href={item.href}>{item.label}</Link>
              </Button>
            ))}
          </div>
        </div>
        <Separator className="my-8" />
        <div className="flex flex-col gap-2 text-xs text-muted-foreground sm:flex-row sm:items-center sm:justify-between">
          <p>Nome e identidade visual ainda são provisórios.</p>
          <p>Next.js · Supabase · TypeScript</p>
        </div>
      </div>
    </footer>
  );
}
