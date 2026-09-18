import { PageHeader } from '@/components/page-header';

export async function DashboardHeading() {
  'use cache';

  return (
    <PageHeader
      title="Busca universal"
      description="Fundação do motor que transforma linguagem natural em oportunidades de economia comparáveis."
    />
  );
}
