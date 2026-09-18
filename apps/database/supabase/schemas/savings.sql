-- Universal savings domain model.
-- Source-specific payloads must stay in connector code or future private tables.
-- The public model below is intentionally source-agnostic.

-- =============================================================================
-- Merchants and sources
-- =============================================================================

create table if not exists public.merchants (
  id uuid primary key default extensions.uuid_generate_v4(),
  name text not null,
  slug text not null,
  website_url text,
  country_code text,
  active boolean not null default true,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint merchants_slug_key unique (slug),
  constraint merchants_country_code_check
    check (country_code is null or country_code ~ '^[A-Z]{2}$')
);

create table if not exists public.sources (
  id uuid primary key default extensions.uuid_generate_v4(),
  merchant_id uuid references public.merchants(id) on delete set null,
  name text not null,
  source_type text not null,
  base_url text,
  trust_score numeric(5,2) not null default 50,
  active boolean not null default true,
  capabilities jsonb not null default '{}'::jsonb,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint sources_type_check check (
    source_type in (
      'official_api',
      'official_feed',
      'affiliate',
      'partner',
      'marketplace',
      'public_web',
      'user_submission',
      'manual',
      'other'
    )
  ),
  constraint sources_trust_score_check check (trust_score between 0 and 100)
);

create index if not exists sources_merchant_id_idx on public.sources(merchant_id);
create index if not exists sources_active_type_idx on public.sources(active, source_type);

-- =============================================================================
-- Universal catalog
-- =============================================================================

create table if not exists public.products_services (
  id uuid primary key default extensions.uuid_generate_v4(),
  kind text not null,
  title text not null,
  brand text,
  model text,
  category_path text[] not null default '{}',
  canonical_key text,
  attributes jsonb not null default '{}'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint products_services_kind_check check (
    kind in (
      'product',
      'service',
      'travel',
      'course',
      'subscription',
      'rental',
      'ticket',
      'other'
    )
  )
);

create unique index if not exists products_services_canonical_key_key
  on public.products_services(canonical_key)
  where canonical_key is not null;

create index if not exists products_services_kind_idx
  on public.products_services(kind);

create index if not exists products_services_category_path_idx
  on public.products_services using gin(category_path);

-- =============================================================================
-- Offers
-- =============================================================================

create table if not exists public.offers (
  id uuid primary key default extensions.uuid_generate_v4(),
  source_id uuid not null references public.sources(id) on delete cascade,
  merchant_id uuid references public.merchants(id) on delete set null,
  product_service_id uuid references public.products_services(id) on delete set null,
  external_id text,
  title text not null,
  description text,
  canonical_url text,
  currency text not null default 'BRL',
  base_price numeric(14,2),
  instant_discount_amount numeric(14,2),
  fees_amount numeric(14,2),
  pay_now_amount numeric(14,2),
  cashback_amount numeric(14,2),
  effective_cost_amount numeric(14,2),
  discount_percentage numeric(7,4),
  coupon_required boolean not null default false,
  available boolean,
  availability_context jsonb not null default '{}'::jsonb,
  validation_level text not null default 'unverified',
  status text not null default 'active',
  starts_at timestamptz,
  ends_at timestamptz,
  fetched_at timestamptz not null default now(),
  last_verified_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint offers_currency_check check (currency ~ '^[A-Z]{3}$'),
  constraint offers_non_negative_money_check check (
    coalesce(base_price, 0) >= 0
    and coalesce(instant_discount_amount, 0) >= 0
    and coalesce(fees_amount, 0) >= 0
    and coalesce(pay_now_amount, 0) >= 0
    and coalesce(cashback_amount, 0) >= 0
    and coalesce(effective_cost_amount, 0) >= 0
  ),
  constraint offers_discount_percentage_check check (
    discount_percentage is null or discount_percentage between 0 and 100
  ),
  constraint offers_validation_level_check check (
    validation_level in (
      'checkout_verified',
      'official',
      'user_confirmed',
      'probable',
      'unverified'
    )
  ),
  constraint offers_status_check check (
    status in ('active', 'inactive', 'expired', 'rejected')
  ),
  constraint offers_time_window_check check (
    starts_at is null or ends_at is null or starts_at <= ends_at
  )
);

create unique index if not exists offers_source_external_id_key
  on public.offers(source_id, external_id)
  where external_id is not null;

create index if not exists offers_active_effective_cost_idx
  on public.offers(status, currency, effective_cost_amount)
  where status = 'active';

create index if not exists offers_product_service_id_idx
  on public.offers(product_service_id);

create index if not exists offers_merchant_id_idx
  on public.offers(merchant_id);

create index if not exists offers_fetched_at_idx
  on public.offers(fetched_at desc);

-- =============================================================================
-- Price history
-- =============================================================================

create table if not exists public.prices (
  id uuid primary key default extensions.uuid_generate_v4(),
  offer_id uuid not null references public.offers(id) on delete cascade,
  currency text not null,
  base_price numeric(14,2),
  fees_amount numeric(14,2),
  pay_now_amount numeric(14,2),
  cashback_amount numeric(14,2),
  effective_cost_amount numeric(14,2),
  available boolean,
  observed_at timestamptz not null default now(),
  constraint prices_currency_check check (currency ~ '^[A-Z]{3}$'),
  constraint prices_non_negative_money_check check (
    coalesce(base_price, 0) >= 0
    and coalesce(fees_amount, 0) >= 0
    and coalesce(pay_now_amount, 0) >= 0
    and coalesce(cashback_amount, 0) >= 0
    and coalesce(effective_cost_amount, 0) >= 0
  )
);

create index if not exists prices_offer_observed_at_idx
  on public.prices(offer_id, observed_at desc);

-- =============================================================================
-- Coupons and benefits
-- =============================================================================

create table if not exists public.coupons (
  id uuid primary key default extensions.uuid_generate_v4(),
  source_id uuid not null references public.sources(id) on delete cascade,
  merchant_id uuid references public.merchants(id) on delete set null,
  code text,
  title text not null,
  description text,
  discount_type text not null default 'other',
  currency text,
  discount_value numeric(14,4),
  max_discount_amount numeric(14,2),
  min_spend_amount numeric(14,2),
  validation_level text not null default 'unverified',
  status text not null default 'active',
  starts_at timestamptz,
  ends_at timestamptz,
  conditions_summary text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint coupons_discount_type_check check (
    discount_type in ('percentage', 'fixed', 'free_shipping', 'benefit', 'other')
  ),
  constraint coupons_currency_check check (
    currency is null or currency ~ '^[A-Z]{3}$'
  ),
  constraint coupons_validation_level_check check (
    validation_level in (
      'checkout_verified',
      'official',
      'user_confirmed',
      'probable',
      'unverified'
    )
  ),
  constraint coupons_status_check check (
    status in ('active', 'inactive', 'expired', 'rejected')
  ),
  constraint coupons_non_negative_check check (
    coalesce(discount_value, 0) >= 0
    and coalesce(max_discount_amount, 0) >= 0
    and coalesce(min_spend_amount, 0) >= 0
  ),
  constraint coupons_time_window_check check (
    starts_at is null or ends_at is null or starts_at <= ends_at
  )
);

create unique index if not exists coupons_source_code_key
  on public.coupons(source_id, lower(code))
  where code is not null;

create index if not exists coupons_merchant_id_idx
  on public.coupons(merchant_id);

create index if not exists coupons_status_ends_at_idx
  on public.coupons(status, ends_at);

create table if not exists public.offer_coupons (
  offer_id uuid not null references public.offers(id) on delete cascade,
  coupon_id uuid not null references public.coupons(id) on delete cascade,
  is_required boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (offer_id, coupon_id)
);

create table if not exists public.offer_benefits (
  id uuid primary key default extensions.uuid_generate_v4(),
  offer_id uuid not null references public.offers(id) on delete cascade,
  benefit_type text not null,
  amount numeric(14,2),
  currency text,
  percentage numeric(7,4),
  delayed boolean not null default false,
  description text,
  eligibility jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint offer_benefits_type_check check (
    benefit_type in (
      'cashback',
      'free_shipping',
      'points',
      'miles',
      'upgrade',
      'bonus',
      'other'
    )
  ),
  constraint offer_benefits_currency_check check (
    currency is null or currency ~ '^[A-Z]{3}$'
  ),
  constraint offer_benefits_amount_check check (
    coalesce(amount, 0) >= 0
    and (percentage is null or percentage between 0 and 100)
  )
);

create index if not exists offer_benefits_offer_id_idx
  on public.offer_benefits(offer_id);

-- =============================================================================
-- Conditions and validation evidence
-- =============================================================================

create table if not exists public.offer_conditions (
  id uuid primary key default extensions.uuid_generate_v4(),
  offer_id uuid references public.offers(id) on delete cascade,
  coupon_id uuid references public.coupons(id) on delete cascade,
  condition_key text not null,
  operator text not null default 'info',
  value jsonb,
  description text,
  mandatory boolean not null default true,
  created_at timestamptz not null default now(),
  constraint offer_conditions_parent_check check (
    (offer_id is not null and coupon_id is null)
    or (offer_id is null and coupon_id is not null)
  ),
  constraint offer_conditions_operator_check check (
    operator in (
      'eq',
      'neq',
      'gte',
      'lte',
      'in',
      'contains',
      'requires',
      'info'
    )
  )
);

create index if not exists offer_conditions_offer_id_idx
  on public.offer_conditions(offer_id)
  where offer_id is not null;

create index if not exists offer_conditions_coupon_id_idx
  on public.offer_conditions(coupon_id)
  where coupon_id is not null;

create table if not exists public.offer_validations (
  id uuid primary key default extensions.uuid_generate_v4(),
  offer_id uuid references public.offers(id) on delete cascade,
  coupon_id uuid references public.coupons(id) on delete cascade,
  user_id uuid references auth.users(id) on delete set null,
  validation_level text not null,
  method text not null,
  result text not null,
  confidence numeric(5,4),
  evidence jsonb not null default '{}'::jsonb,
  validated_at timestamptz not null default now(),
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  constraint offer_validations_parent_check check (
    (offer_id is not null and coupon_id is null)
    or (offer_id is null and coupon_id is not null)
  ),
  constraint offer_validations_level_check check (
    validation_level in (
      'checkout_verified',
      'official',
      'user_confirmed',
      'probable',
      'unverified'
    )
  ),
  constraint offer_validations_method_check check (
    method in (
      'checkout',
      'official_api',
      'official_feed',
      'partner',
      'user_report',
      'manual',
      'other'
    )
  ),
  constraint offer_validations_result_check check (
    result in ('success', 'failure', 'inconclusive')
  ),
  constraint offer_validations_confidence_check check (
    confidence is null or confidence between 0 and 1
  )
);

create index if not exists offer_validations_offer_id_idx
  on public.offer_validations(offer_id, validated_at desc)
  where offer_id is not null;

create index if not exists offer_validations_coupon_id_idx
  on public.offer_validations(coupon_id, validated_at desc)
  where coupon_id is not null;

-- =============================================================================
-- Search audit / personalization foundation
-- =============================================================================

create table if not exists public.search_queries (
  id uuid primary key default extensions.uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  raw_query text not null,
  locale text,
  country_code text,
  currency text,
  created_at timestamptz not null default now(),
  constraint search_queries_country_code_check check (
    country_code is null or country_code ~ '^[A-Z]{2}$'
  ),
  constraint search_queries_currency_check check (
    currency is null or currency ~ '^[A-Z]{3}$'
  )
);

create index if not exists search_queries_user_created_at_idx
  on public.search_queries(user_id, created_at desc);

create table if not exists public.search_intents (
  id uuid primary key default extensions.uuid_generate_v4(),
  query_id uuid not null references public.search_queries(id) on delete cascade,
  intent_kind text not null,
  category text,
  location text,
  origin text,
  destination text,
  start_at timestamptz,
  end_at timestamptz,
  quantity integer,
  attributes jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint search_intents_kind_check check (
    intent_kind in (
      'buy',
      'rent',
      'book',
      'subscribe',
      'learn',
      'hire',
      'travel',
      'other'
    )
  ),
  constraint search_intents_quantity_check check (
    quantity is null or quantity > 0
  ),
  constraint search_intents_time_window_check check (
    start_at is null or end_at is null or start_at <= end_at
  )
);

create index if not exists search_intents_query_id_idx
  on public.search_intents(query_id);

-- =============================================================================
-- updated_at triggers
-- =============================================================================

create trigger set_updated_at_merchants
  before update on public.merchants
  for each row execute function public.set_updated_at();

create trigger set_updated_at_sources
  before update on public.sources
  for each row execute function public.set_updated_at();

create trigger set_updated_at_products_services
  before update on public.products_services
  for each row execute function public.set_updated_at();

create trigger set_updated_at_offers
  before update on public.offers
  for each row execute function public.set_updated_at();

create trigger set_updated_at_coupons
  before update on public.coupons
  for each row execute function public.set_updated_at();

-- =============================================================================
-- Row Level Security
-- =============================================================================

alter table public.merchants enable row level security;
alter table public.sources enable row level security;
alter table public.products_services enable row level security;
alter table public.offers enable row level security;
alter table public.prices enable row level security;
alter table public.coupons enable row level security;
alter table public.offer_coupons enable row level security;
alter table public.offer_benefits enable row level security;
alter table public.offer_conditions enable row level security;
alter table public.offer_validations enable row level security;
alter table public.search_queries enable row level security;
alter table public.search_intents enable row level security;

create policy merchants_public_read
  on public.merchants for select
  using (active);

create policy sources_public_read
  on public.sources for select
  using (active);

create policy products_services_public_read
  on public.products_services for select
  using (active);

create policy offers_public_read
  on public.offers for select
  using (status = 'active');

create policy prices_public_read
  on public.prices for select
  using (
    exists (
      select 1
      from public.offers
      where offers.id = prices.offer_id
        and offers.status = 'active'
    )
  );

create policy coupons_public_read
  on public.coupons for select
  using (status = 'active');

create policy offer_coupons_public_read
  on public.offer_coupons for select
  using (
    exists (
      select 1 from public.offers
      where offers.id = offer_coupons.offer_id
        and offers.status = 'active'
    )
  );

create policy offer_benefits_public_read
  on public.offer_benefits for select
  using (
    exists (
      select 1 from public.offers
      where offers.id = offer_benefits.offer_id
        and offers.status = 'active'
    )
  );

create policy offer_conditions_public_read
  on public.offer_conditions for select
  using (
    (
      offer_id is not null
      and exists (
        select 1 from public.offers
        where offers.id = offer_conditions.offer_id
          and offers.status = 'active'
      )
    )
    or
    (
      coupon_id is not null
      and exists (
        select 1 from public.coupons
        where coupons.id = offer_conditions.coupon_id
          and coupons.status = 'active'
      )
    )
  );

create policy offer_validations_user_read
  on public.offer_validations for select
  to authenticated
  using (user_id = auth.uid());

create policy offer_validations_user_report_insert
  on public.offer_validations for insert
  to authenticated
  with check (
    user_id = auth.uid()
    and method = 'user_report'
    and validation_level = 'user_confirmed'
  );

create policy search_queries_user_read
  on public.search_queries for select
  to authenticated
  using (user_id = auth.uid());

create policy search_queries_user_insert
  on public.search_queries for insert
  to authenticated
  with check (user_id = auth.uid());

create policy search_intents_user_read
  on public.search_intents for select
  to authenticated
  using (
    exists (
      select 1
      from public.search_queries
      where search_queries.id = search_intents.query_id
        and search_queries.user_id = auth.uid()
    )
  );

create policy search_intents_user_insert
  on public.search_intents for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.search_queries
      where search_queries.id = search_intents.query_id
        and search_queries.user_id = auth.uid()
    )
  );

-- =============================================================================
-- Grants
-- =============================================================================

grant select on public.merchants to anon, authenticated;
grant select on public.sources to anon, authenticated;
grant select on public.products_services to anon, authenticated;
grant select on public.offers to anon, authenticated;
grant select on public.prices to anon, authenticated;
grant select on public.coupons to anon, authenticated;
grant select on public.offer_coupons to anon, authenticated;
grant select on public.offer_benefits to anon, authenticated;
grant select on public.offer_conditions to anon, authenticated;

grant select, insert on public.offer_validations to authenticated;
grant select, insert on public.search_queries to authenticated;
grant select, insert on public.search_intents to authenticated;

grant all on public.merchants to service_role;
grant all on public.sources to service_role;
grant all on public.products_services to service_role;
grant all on public.offers to service_role;
grant all on public.prices to service_role;
grant all on public.coupons to service_role;
grant all on public.offer_coupons to service_role;
grant all on public.offer_benefits to service_role;
grant all on public.offer_conditions to service_role;
grant all on public.offer_validations to service_role;
grant all on public.search_queries to service_role;
grant all on public.search_intents to service_role;
