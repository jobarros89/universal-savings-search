import { describe, expect, it } from 'vitest';

import { calculateEffectivePrice } from './calculate-effective-price';

describe('calculateEffectivePrice', () => {
  it('separates checkout price from delayed cashback', () => {
    const result = calculateEffectivePrice({
      basePrice: { amount: 900, currency: 'BRL' },
      instantDiscount: { amount: 90, currency: 'BRL' },
      fees: { amount: 37.3, currency: 'BRL' },
      cashback: { amount: 42.36, currency: 'BRL' },
    });

    expect(result.payNow.amount).toBe(847.3);
    expect(result.effectiveCost.amount).toBe(804.94);
  });

  it('rejects mixed currencies', () => {
    expect(() =>
      calculateEffectivePrice({
        basePrice: { amount: 100, currency: 'BRL' },
        cashback: { amount: 10, currency: 'USD' },
      }),
    ).toThrow('All price components must use the same currency');
  });
});
