import type { Money } from '../offers/types';

export interface EffectivePriceInput {
  basePrice: Money;
  instantDiscount?: Money;
  fees?: Money;
  cashback?: Money;
}

export interface EffectivePriceResult {
  payNow: Money;
  effectiveCost: Money;
}

function ensureSameCurrency(reference: Money, candidate?: Money) {
  if (candidate && candidate.currency !== reference.currency) {
    throw new Error('All price components must use the same currency');
  }
}

function roundMoney(value: number) {
  return Math.round((value + Number.EPSILON) * 100) / 100;
}

export function calculateEffectivePrice(
  input: EffectivePriceInput,
): EffectivePriceResult {
  ensureSameCurrency(input.basePrice, input.instantDiscount);
  ensureSameCurrency(input.basePrice, input.fees);
  ensureSameCurrency(input.basePrice, input.cashback);

  const payNow = Math.max(
    0,
    input.basePrice.amount -
      (input.instantDiscount?.amount ?? 0) +
      (input.fees?.amount ?? 0),
  );

  const effectiveCost = Math.max(
    0,
    payNow - (input.cashback?.amount ?? 0),
  );

  return {
    payNow: {
      amount: roundMoney(payNow),
      currency: input.basePrice.currency,
    },
    effectiveCost: {
      amount: roundMoney(effectiveCost),
      currency: input.basePrice.currency,
    },
  };
}
