import { describe, expect, it } from 'vitest';

import { RuleBasedSearchIntentInterpreter } from './rule-based-interpreter';

const interpreter = new RuleBasedSearchIntentInterpreter();
const context = {
  now: '2026-09-18T12:00:00-03:00',
  countryCode: 'BR',
  currency: 'BRL',
  locale: 'pt-BR',
};

describe('RuleBasedSearchIntentInterpreter', () => {
  it('understands a marketplace coupon request', async () => {
    const result = await interpreter.interpret(
      'Tem cupom para Mercado Livre hoje?',
      context,
    );

    expect(result.kind).toBe('buy');
    expect(result.attributes).toMatchObject({
      couponRequested: true,
      preferredMerchant: 'mercado_livre',
    });
    expect(result.requiresClarification).toBe(false);
  });

  it('understands a phone rental with location', async () => {
    const result = await interpreter.interpret(
      'Quero alugar um iPhone no Rio por 15 dias',
      context,
    );

    expect(result.kind).toBe('rent');
    expect(result.category).toBe('smartphone');
    expect(result.location).toBe('Rio');
    expect(result.missingFields).toEqual([]);
  });

  it('understands an education discount request', async () => {
    const result = await interpreter.interpret(
      'Quero fazer MBA online com desconto',
      context,
    );

    expect(result.kind).toBe('learn');
    expect(result.category).toBe('education');
    expect(result.attributes?.discountRequested).toBe(true);
  });

  it('extracts route and future dates from a flight query', async () => {
    const result = await interpreter.interpret(
      'Passagem Rio → Miami de 10/01 a 20/01',
      context,
    );

    expect(result.kind).toBe('travel');
    expect(result.category).toBe('flight');
    expect(result.origin).toBe('Rio');
    expect(result.destination).toBe('Miami');
    expect(result.startDate).toBe('2027-01-10');
    expect(result.endDate).toBe('2027-01-20');
    expect(result.requiresClarification).toBe(false);
  });

  it('asks for clarification when required travel context is missing', async () => {
    const result = await interpreter.interpret(
      'Quero uma passagem barata para Miami',
      context,
    );

    expect(result.kind).toBe('travel');
    expect(result.missingFields).toContain('origin');
    expect(result.missingFields).toContain('destination');
    expect(result.missingFields).toContain('startDate');
    expect(result.requiresClarification).toBe(true);
  });

  it('handles an empty query safely', async () => {
    const result = await interpreter.interpret('   ', context);

    expect(result.kind).toBe('other');
    expect(result.confidence).toBe(0);
    expect(result.requiresClarification).toBe(true);
  });
});
