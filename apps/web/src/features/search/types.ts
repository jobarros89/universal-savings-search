export type SearchIntentKind =
  | 'buy'
  | 'rent'
  | 'book'
  | 'subscribe'
  | 'learn'
  | 'hire'
  | 'travel'
  | 'other';

export type SearchIntentField =
  | 'category'
  | 'location'
  | 'origin'
  | 'destination'
  | 'startDate'
  | 'endDate'
  | 'quantity';

export interface SearchIntent {
  id?: string;
  kind: SearchIntentKind;
  query: string;
  category?: string;
  location?: string;
  origin?: string;
  destination?: string;
  startDate?: string;
  endDate?: string;
  quantity?: number;
  currency?: string;
  attributes?: Record<string, string | number | boolean>;
}

export interface SearchIntentContext {
  locale?: string;
  countryCode?: string;
  currency?: string;
  now?: string;
}

export interface ParsedSearchIntent extends SearchIntent {
  normalizedQuery: string;
  confidence: number;
  signals: string[];
  missingFields: SearchIntentField[];
  requiresClarification: boolean;
}

export interface SearchIntentInterpreter {
  interpret(
    query: string,
    context?: SearchIntentContext,
  ): Promise<ParsedSearchIntent>;
}
