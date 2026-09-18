export type ValidationLevel =
  | 'checkout_verified'
  | 'official'
  | 'user_confirmed'
  | 'probable'
  | 'unverified';

export interface Money {
  amount: number;
  currency: string;
}

export interface NormalizedOffer {
  sourceId: string;
  sourceName: string;
  merchantName: string;
  title: string;
  canonicalUrl?: string;
  couponCode?: string;
  basePrice?: Money;
  instantDiscount?: Money;
  fees?: Money;
  payNow?: Money;
  cashback?: Money;
  effectiveCost?: Money;
  available?: boolean;
  conditions: string[];
  validationLevel: ValidationLevel;
  fetchedAt: string;
  metadata?: Record<string, unknown>;
}
