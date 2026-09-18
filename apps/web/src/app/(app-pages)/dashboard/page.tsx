import { BadgeCheck, Database, Search, Workflow } from 'lucide-react';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { DashboardHeading } from './dashboard-heading';

const foundation = [
  {
    icon: Search,
    title: 'Search Intent Engine',
    description:
      'Interpreta a intenção da busca antes de escolher fontes e conectores.',
  },
  {
    icon: Database,
    title: 'Schema universal',
    description:
      'Ofertas, cupons, preços, benefícios e validações em um modelo único.',
  },
  {
    icon: BadgeCheck,
    title: 'Validação explícita',
    description:
      'Resultados distinguem fonte oficial, confirmação, probabilidade e checkout validado.',
  },
  {
    icon: Workflow,
    title: 'Connector Framework',
    description:
      'Próxima etapa: conectar fontes reais sem acoplar o núcleo a um marketplace.',
  },
];

export default function DashboardPage() {
  return (
    <div className="mx-auto flex w-full max-w-7xl flex-1 flex-col gap-8 p-4 sm:p-6 lg:p-8">
      <DashboardHeading />
      <section className="grid gap-4 md:grid-cols-2">
        {foundation.map(({ icon: Icon, title, description }) => (
          <Card key={title} className="shadow-none">
            <CardHeader className="flex flex-row items-center gap-3">
              <div className="flex size-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
                <Icon className="size-4" aria-hidden="true" />
              </div>
              <CardTitle className="text-base">{title}</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm leading-6 text-muted-foreground">
                {description}
              </p>
            </CardContent>
          </Card>
        ))}
      </section>
    </div>
  );
}
