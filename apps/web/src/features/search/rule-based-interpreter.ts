import {
  detectCategory,
  detectKind,
  detectShoppingAttributes,
  extractDateRange,
  extractLocation,
  extractQuantity,
  extractRoute,
  normalizeQueryForMatching,
  requiredFieldsFor,
} from './helpers';
import type {
  ParsedSearchIntent,
  SearchIntentContext,
  SearchIntentInterpreter,
} from './types';

function calculateConfidence(params: {
  kindDetected: boolean;
  categoryDetected: boolean;
  contextDetected: boolean;
  dateDetected: boolean;
  commercialSignalDetected: boolean;
}) {
  let confidence = 0.4;

  if (params.kindDetected) confidence += 0.22;
  if (params.categoryDetected) confidence += 0.1;
  if (params.contextDetected) confidence += 0.1;
  if (params.dateDetected) confidence += 0.08;
  if (params.commercialSignalDetected) confidence += 0.06;

  return Math.min(0.98, Number(confidence.toFixed(2)));
}

export class RuleBasedSearchIntentInterpreter
  implements SearchIntentInterpreter
{
  async interpret(
    query: string,
    context: SearchIntentContext = {},
  ): Promise<ParsedSearchIntent> {
    const normalizedQuery = normalizeQueryForMatching(query);

    if (!normalizedQuery) {
      return {
        kind: 'other',
        query,
        normalizedQuery,
        currency: context.currency,
        confidence: 0,
        signals: ['empty_query'],
        missingFields: [],
        requiresClarification: true,
      };
    }

    const kindResult = detectKind(normalizedQuery);
    const category = detectCategory(normalizedQuery);
    const route = extractRoute(query);
    const location = extractLocation(query);
    const dates = extractDateRange(query, context);
    const quantity = extractQuantity(normalizedQuery);
    const attributes = detectShoppingAttributes(normalizedQuery);

    const signals = [kindResult.signal];

    if (category) signals.push(`category:${category}`);
    if (route) signals.push(route.signal);
    if (location) signals.push('location_detected');
    if (dates.startDate) signals.push('start_date_detected');
    if (dates.endDate) signals.push('end_date_detected');
    if (quantity) signals.push('quantity_detected');
    if (attributes.couponRequested) signals.push('coupon_requested');
    if (attributes.discountRequested) signals.push('discount_requested');
    if (attributes.preferredMerchant) signals.push('merchant_preference');

    const requiredFields = requiredFieldsFor(kindResult.kind, category);
    const available = {
      category,
      location,
      origin: route?.origin,
      destination: route?.destination,
      startDate: dates.startDate,
      endDate: dates.endDate,
      quantity,
    };

    const missingFields = requiredFields.filter(
      (field) => !available[field],
    );

    const confidence = calculateConfidence({
      kindDetected: kindResult.kind !== 'other',
      categoryDetected: Boolean(category),
      contextDetected: Boolean(route || location || quantity),
      dateDetected: Boolean(dates.startDate),
      commercialSignalDetected: Boolean(
        attributes.couponRequested ||
          attributes.discountRequested ||
          attributes.preferredMerchant,
      ),
    });

    return {
      kind: kindResult.kind,
      query,
      normalizedQuery,
      category,
      location,
      origin: route?.origin,
      destination: route?.destination,
      startDate: dates.startDate,
      endDate: dates.endDate,
      quantity,
      currency: context.currency,
      attributes: Object.keys(attributes).length ? attributes : undefined,
      confidence,
      signals,
      missingFields,
      requiresClarification:
        missingFields.length > 0 || confidence < 0.55,
    };
  }
}

export const defaultSearchIntentInterpreter =
  new RuleBasedSearchIntentInterpreter();
