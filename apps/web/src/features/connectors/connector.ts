import type { NormalizedOffer } from '../offers/types';
import type { SearchIntent, SearchIntentKind } from '../search/types';

export interface ConnectorCapabilities {
  intents: SearchIntentKind[];
  categories?: string[];
  supportsLiveAvailability: boolean;
  supportsCheckoutValidation: boolean;
  supportsFinalPrice: boolean;
}

export interface SearchConnector {
  id: string;
  name: string;
  capabilities: ConnectorCapabilities;
  supports(intent: SearchIntent): boolean;
  search(intent: SearchIntent): Promise<NormalizedOffer[]>;
}
