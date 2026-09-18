export type SearchIntentKind =
  | 'buy'
  | 'rent'
  | 'book'
  | 'subscribe'
  | 'learn'
  | 'hire'
  | 'travel'
  | 'other';

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
