import type {
  SearchIntentContext,
  SearchIntentField,
  SearchIntentKind,
} from './types';

const KIND_PATTERNS: Array<{
  kind: SearchIntentKind;
  patterns: RegExp[];
  signal: string;
}> = [
  {
    kind: 'travel',
    patterns: [
      /\bpassagem\b/,
      /\bvoo\b/,
      /\bflight\b/,
      /\bviaj(?:ar|em)\b/,
    ],
    signal: 'travel_keyword',
  },
  {
    kind: 'rent',
    patterns: [/\balug(?:ar|uel)\b/, /\blocar\b/, /\bloca(?:cao|ção)\b/],
    signal: 'rental_keyword',
  },
  {
    kind: 'learn',
    patterns: [
      /\bcurso\b/,
      /\bfaculdade\b/,
      /\buniversidade\b/,
      /\bmba\b/,
      /\bpos[- ]?graduacao\b/,
      /\bgraduacao\b/,
    ],
    signal: 'education_keyword',
  },
  {
    kind: 'subscribe',
    patterns: [/\bassinatura\b/, /\bsubscription\b/, /\bplano mensal\b/],
    signal: 'subscription_keyword',
  },
  {
    kind: 'hire',
    patterns: [/\bcontratar\b/, /\bservico\b/, /\bservice\b/],
    signal: 'service_keyword',
  },
  {
    kind: 'book',
    patterns: [/\breservar\b/, /\breserva\b/, /\bhotel\b/, /\bhospedagem\b/],
    signal: 'booking_keyword',
  },
  {
    kind: 'buy',
    patterns: [
      /\bcomprar\b/,
      /\bpreco\b/,
      /\bmais barato\b/,
      /\bcupom\b/,
      /\bdesconto\b/,
      /\boferta\b/,
      /\bmercado livre\b/,
      /\bshopee\b/,
      /\bamazon\b/,
    ],
    signal: 'shopping_keyword',
  },
];

const CATEGORY_PATTERNS: Array<{
  category: string;
  patterns: RegExp[];
}> = [
  { category: 'flight', patterns: [/\bpassagem\b/, /\bvoo\b/, /\bflight\b/] },
  { category: 'hotel', patterns: [/\bhotel\b/, /\bhospedagem\b/] },
  {
    category: 'smartphone',
    patterns: [/\biphone\b/, /\bcelular\b/, /\bsmartphone\b/],
  },
  {
    category: 'education',
    patterns: [
      /\bcurso\b/,
      /\bfaculdade\b/,
      /\buniversidade\b/,
      /\bmba\b/,
      /\bgraduacao\b/,
    ],
  },
  {
    category: 'electronics',
    patterns: [
      /\bnotebook\b/,
      /\blaptop\b/,
      /\bairpods?\b/,
      /\bfone\b/,
      /\btelevisao\b/,
      /\btv\b/,
    ],
  },
  { category: 'automotive_tires', patterns: [/\bpneu(?:s)?\b/] },
];

export function normalizeQueryForMatching(query: string) {
  return query
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim();
}

export function detectKind(normalizedQuery: string) {
  for (const candidate of KIND_PATTERNS) {
    if (candidate.patterns.some((pattern) => pattern.test(normalizedQuery))) {
      return { kind: candidate.kind, signal: candidate.signal };
    }
  }

  return { kind: 'other' as const, signal: 'no_intent_keyword' };
}

export function detectCategory(normalizedQuery: string) {
  return CATEGORY_PATTERNS.find((candidate) =>
    candidate.patterns.some((pattern) => pattern.test(normalizedQuery)),
  )?.category;
}

export function detectShoppingAttributes(normalizedQuery: string) {
  const attributes: Record<string, string | number | boolean> = {};

  if (/\bcupom\b|\bvoucher\b|codigo promocional/.test(normalizedQuery)) {
    attributes.couponRequested = true;
  }

  if (/\bdesconto\b|\bmais barato\b|\beconomizar\b|\boferta\b/.test(normalizedQuery)) {
    attributes.discountRequested = true;
  }

  const marketplaces = [
    ['mercado livre', 'mercado_livre'],
    ['shopee', 'shopee'],
    ['amazon', 'amazon'],
  ] as const;

  for (const [pattern, value] of marketplaces) {
    if (normalizedQuery.includes(pattern)) {
      attributes.preferredMerchant = value;
      break;
    }
  }

  return attributes;
}

function cleanRoutePart(value: string) {
  return value
    .replace(/^\s*(?:passagem|voo|viagem)\s*/i, '')
    .replace(
      /\s+(?:de|em|no|na|dia|entre)\s+\d{1,4}.*$/i,
      '',
    )
    .replace(/\s+/g, ' ')
    .trim();
}

export function extractRoute(query: string) {
  const arrow = query.match(
    /(?:passagem|voo|viagem)?\s*([\p{L} .'-]{2,50})\s*(?:→|->)\s*([\p{L} .'-]{2,50})/iu,
  );

  if (arrow) {
    const origin = cleanRoutePart(arrow[1]);
    const destination = cleanRoutePart(arrow[2]);

    if (origin && destination) {
      return { origin, destination, signal: 'route_arrow' };
    }
  }

  const prose = query.match(
    /\bde\s+([\p{L} .'-]{2,50}?)\s+(?:para|ate|até)\s+([\p{L} .'-]{2,50}?)(?=\s+(?:em|dia|entre|de\s+\d|\d{1,2}[/-]\d{1,2}|$))/iu,
  );

  if (prose) {
    const origin = cleanRoutePart(prose[1]);
    const destination = cleanRoutePart(prose[2]);

    if (origin && destination) {
      return { origin, destination, signal: 'route_prose' };
    }
  }

  return undefined;
}

export function extractLocation(query: string) {
  const match = query.match(
    /\b(?:em|no|na)\s+([\p{L} .'-]{2,40}?)(?=\s+(?:por|durante|com|sem|de\s+\d|entre|$))/iu,
  );

  return match?.[1]?.trim();
}

function resolveDate(
  raw: string,
  context: SearchIntentContext,
): string | undefined {
  const iso = raw.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (iso) {
    return raw;
  }

  const match = raw.match(/^(\d{1,2})[/-](\d{1,2})(?:[/-](\d{2,4}))?$/);
  if (!match) {
    return undefined;
  }

  const day = Number(match[1]);
  const month = Number(match[2]);

  if (day < 1 || day > 31 || month < 1 || month > 12) {
    return undefined;
  }

  const reference = context.now ? new Date(context.now) : new Date();
  let year = match[3]
    ? Number(match[3].length === 2 ? `20${match[3]}` : match[3])
    : reference.getUTCFullYear();

  if (!match[3]) {
    const candidate = new Date(Date.UTC(year, month - 1, day));
    const today = new Date(
      Date.UTC(
        reference.getUTCFullYear(),
        reference.getUTCMonth(),
        reference.getUTCDate(),
      ),
    );

    if (candidate < today) {
      year += 1;
    }
  }

  const candidate = new Date(Date.UTC(year, month - 1, day));

  if (
    candidate.getUTCFullYear() !== year ||
    candidate.getUTCMonth() !== month - 1 ||
    candidate.getUTCDate() !== day
  ) {
    return undefined;
  }

  return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

export function extractDateRange(
  query: string,
  context: SearchIntentContext,
) {
  const candidates = query.match(
    /\b(?:\d{4}-\d{2}-\d{2}|\d{1,2}[/-]\d{1,2}(?:[/-]\d{2,4})?)\b/g,
  );

  if (!candidates?.length) {
    return {};
  }

  const resolved = candidates
    .map((candidate) => resolveDate(candidate, context))
    .filter((candidate): candidate is string => Boolean(candidate));

  return {
    startDate: resolved[0],
    endDate: resolved[1],
  };
}

export function extractQuantity(normalizedQuery: string) {
  const match = normalizedQuery.match(
    /\b(\d{1,3})\s+(?:pessoas?|passageiros?|hospedes?|hóspedes?|unidades?|itens?)\b/,
  );

  if (!match) {
    return undefined;
  }

  const quantity = Number(match[1]);
  return quantity > 0 ? quantity : undefined;
}

export function requiredFieldsFor(
  kind: SearchIntentKind,
  category?: string,
): SearchIntentField[] {
  if (kind === 'travel' || category === 'flight') {
    return ['origin', 'destination', 'startDate'];
  }

  if (kind === 'rent') {
    return ['location'];
  }

  if (kind === 'book' && category === 'hotel') {
    return ['location', 'startDate'];
  }

  return [];
}
