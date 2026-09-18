create table "public"."coupons" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "source_id" uuid not null,
    "merchant_id" uuid,
    "code" text,
    "title" text not null,
    "description" text,
    "discount_type" text not null default 'other'::text,
    "currency" text,
    "discount_value" numeric(14,4),
    "max_discount_amount" numeric(14,2),
    "min_spend_amount" numeric(14,2),
    "validation_level" text not null default 'unverified'::text,
    "status" text not null default 'active'::text,
    "starts_at" timestamp with time zone,
    "ends_at" timestamp with time zone,
    "conditions_summary" text,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."coupons" enable row level security;


  create table "public"."merchants" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "name" text not null,
    "slug" text not null,
    "website_url" text,
    "country_code" text,
    "active" boolean not null default true,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."merchants" enable row level security;


  create table "public"."offer_benefits" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "offer_id" uuid not null,
    "benefit_type" text not null,
    "amount" numeric(14,2),
    "currency" text,
    "percentage" numeric(7,4),
    "delayed" boolean not null default false,
    "description" text,
    "eligibility" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."offer_benefits" enable row level security;


  create table "public"."offer_conditions" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "offer_id" uuid,
    "coupon_id" uuid,
    "condition_key" text not null,
    "operator" text not null default 'info'::text,
    "value" jsonb,
    "description" text,
    "mandatory" boolean not null default true,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."offer_conditions" enable row level security;


  create table "public"."offer_coupons" (
    "offer_id" uuid not null,
    "coupon_id" uuid not null,
    "is_required" boolean not null default true,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."offer_coupons" enable row level security;


  create table "public"."offer_validations" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "offer_id" uuid,
    "coupon_id" uuid,
    "user_id" uuid,
    "validation_level" text not null,
    "method" text not null,
    "result" text not null,
    "confidence" numeric(5,4),
    "evidence" jsonb not null default '{}'::jsonb,
    "validated_at" timestamp with time zone not null default now(),
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."offer_validations" enable row level security;


  create table "public"."offers" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "source_id" uuid not null,
    "merchant_id" uuid,
    "product_service_id" uuid,
    "external_id" text,
    "title" text not null,
    "description" text,
    "canonical_url" text,
    "currency" text not null default 'BRL'::text,
    "base_price" numeric(14,2),
    "instant_discount_amount" numeric(14,2),
    "fees_amount" numeric(14,2),
    "pay_now_amount" numeric(14,2),
    "cashback_amount" numeric(14,2),
    "effective_cost_amount" numeric(14,2),
    "discount_percentage" numeric(7,4),
    "coupon_required" boolean not null default false,
    "available" boolean,
    "availability_context" jsonb not null default '{}'::jsonb,
    "validation_level" text not null default 'unverified'::text,
    "status" text not null default 'active'::text,
    "starts_at" timestamp with time zone,
    "ends_at" timestamp with time zone,
    "fetched_at" timestamp with time zone not null default now(),
    "last_verified_at" timestamp with time zone,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."offers" enable row level security;


  create table "public"."prices" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "offer_id" uuid not null,
    "currency" text not null,
    "base_price" numeric(14,2),
    "fees_amount" numeric(14,2),
    "pay_now_amount" numeric(14,2),
    "cashback_amount" numeric(14,2),
    "effective_cost_amount" numeric(14,2),
    "available" boolean,
    "observed_at" timestamp with time zone not null default now()
      );


alter table "public"."prices" enable row level security;


  create table "public"."products_services" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "kind" text not null,
    "title" text not null,
    "brand" text,
    "model" text,
    "category_path" text[] not null default '{}'::text[],
    "canonical_key" text,
    "attributes" jsonb not null default '{}'::jsonb,
    "active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."products_services" enable row level security;


  create table "public"."search_intents" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "query_id" uuid not null,
    "intent_kind" text not null,
    "category" text,
    "location" text,
    "origin" text,
    "destination" text,
    "start_at" timestamp with time zone,
    "end_at" timestamp with time zone,
    "quantity" integer,
    "attributes" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."search_intents" enable row level security;


  create table "public"."search_queries" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "user_id" uuid,
    "raw_query" text not null,
    "locale" text,
    "country_code" text,
    "currency" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."search_queries" enable row level security;


  create table "public"."sources" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "merchant_id" uuid,
    "name" text not null,
    "source_type" text not null,
    "base_url" text,
    "trust_score" numeric(5,2) not null default 50,
    "active" boolean not null default true,
    "capabilities" jsonb not null default '{}'::jsonb,
    "metadata" jsonb not null default '{}'::jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."sources" enable row level security;

CREATE INDEX coupons_merchant_id_idx ON public.coupons USING btree (merchant_id);

CREATE UNIQUE INDEX coupons_pkey ON public.coupons USING btree (id);

CREATE UNIQUE INDEX coupons_source_code_key ON public.coupons USING btree (source_id, lower(code)) WHERE (code IS NOT NULL);

CREATE INDEX coupons_status_ends_at_idx ON public.coupons USING btree (status, ends_at);

CREATE UNIQUE INDEX merchants_pkey ON public.merchants USING btree (id);

CREATE UNIQUE INDEX merchants_slug_key ON public.merchants USING btree (slug);

CREATE INDEX offer_benefits_offer_id_idx ON public.offer_benefits USING btree (offer_id);

CREATE UNIQUE INDEX offer_benefits_pkey ON public.offer_benefits USING btree (id);

CREATE INDEX offer_conditions_coupon_id_idx ON public.offer_conditions USING btree (coupon_id) WHERE (coupon_id IS NOT NULL);

CREATE INDEX offer_conditions_offer_id_idx ON public.offer_conditions USING btree (offer_id) WHERE (offer_id IS NOT NULL);

CREATE UNIQUE INDEX offer_conditions_pkey ON public.offer_conditions USING btree (id);

CREATE UNIQUE INDEX offer_coupons_pkey ON public.offer_coupons USING btree (offer_id, coupon_id);

CREATE INDEX offer_validations_coupon_id_idx ON public.offer_validations USING btree (coupon_id, validated_at DESC) WHERE (coupon_id IS NOT NULL);

CREATE INDEX offer_validations_offer_id_idx ON public.offer_validations USING btree (offer_id, validated_at DESC) WHERE (offer_id IS NOT NULL);

CREATE UNIQUE INDEX offer_validations_pkey ON public.offer_validations USING btree (id);

CREATE INDEX offers_active_effective_cost_idx ON public.offers USING btree (status, currency, effective_cost_amount) WHERE (status = 'active'::text);

CREATE INDEX offers_fetched_at_idx ON public.offers USING btree (fetched_at DESC);

CREATE INDEX offers_merchant_id_idx ON public.offers USING btree (merchant_id);

CREATE UNIQUE INDEX offers_pkey ON public.offers USING btree (id);

CREATE INDEX offers_product_service_id_idx ON public.offers USING btree (product_service_id);

CREATE UNIQUE INDEX offers_source_external_id_key ON public.offers USING btree (source_id, external_id) WHERE (external_id IS NOT NULL);

CREATE INDEX prices_offer_observed_at_idx ON public.prices USING btree (offer_id, observed_at DESC);

CREATE UNIQUE INDEX prices_pkey ON public.prices USING btree (id);

CREATE UNIQUE INDEX products_services_canonical_key_key ON public.products_services USING btree (canonical_key) WHERE (canonical_key IS NOT NULL);

CREATE INDEX products_services_category_path_idx ON public.products_services USING gin (category_path);

CREATE INDEX products_services_kind_idx ON public.products_services USING btree (kind);

CREATE UNIQUE INDEX products_services_pkey ON public.products_services USING btree (id);

CREATE UNIQUE INDEX search_intents_pkey ON public.search_intents USING btree (id);

CREATE INDEX search_intents_query_id_idx ON public.search_intents USING btree (query_id);

CREATE UNIQUE INDEX search_queries_pkey ON public.search_queries USING btree (id);

CREATE INDEX search_queries_user_created_at_idx ON public.search_queries USING btree (user_id, created_at DESC);

CREATE INDEX sources_active_type_idx ON public.sources USING btree (active, source_type);

CREATE INDEX sources_merchant_id_idx ON public.sources USING btree (merchant_id);

CREATE UNIQUE INDEX sources_pkey ON public.sources USING btree (id);

alter table "public"."coupons" add constraint "coupons_pkey" PRIMARY KEY using index "coupons_pkey";

alter table "public"."merchants" add constraint "merchants_pkey" PRIMARY KEY using index "merchants_pkey";

alter table "public"."offer_benefits" add constraint "offer_benefits_pkey" PRIMARY KEY using index "offer_benefits_pkey";

alter table "public"."offer_conditions" add constraint "offer_conditions_pkey" PRIMARY KEY using index "offer_conditions_pkey";

alter table "public"."offer_coupons" add constraint "offer_coupons_pkey" PRIMARY KEY using index "offer_coupons_pkey";

alter table "public"."offer_validations" add constraint "offer_validations_pkey" PRIMARY KEY using index "offer_validations_pkey";

alter table "public"."offers" add constraint "offers_pkey" PRIMARY KEY using index "offers_pkey";

alter table "public"."prices" add constraint "prices_pkey" PRIMARY KEY using index "prices_pkey";

alter table "public"."products_services" add constraint "products_services_pkey" PRIMARY KEY using index "products_services_pkey";

alter table "public"."search_intents" add constraint "search_intents_pkey" PRIMARY KEY using index "search_intents_pkey";

alter table "public"."search_queries" add constraint "search_queries_pkey" PRIMARY KEY using index "search_queries_pkey";

alter table "public"."sources" add constraint "sources_pkey" PRIMARY KEY using index "sources_pkey";

alter table "public"."coupons" add constraint "coupons_currency_check" CHECK (((currency IS NULL) OR (currency ~ '^[A-Z]{3}$'::text))) not valid;

alter table "public"."coupons" validate constraint "coupons_currency_check";

alter table "public"."coupons" add constraint "coupons_discount_type_check" CHECK ((discount_type = ANY (ARRAY['percentage'::text, 'fixed'::text, 'free_shipping'::text, 'benefit'::text, 'other'::text]))) not valid;

alter table "public"."coupons" validate constraint "coupons_discount_type_check";

alter table "public"."coupons" add constraint "coupons_merchant_id_fkey" FOREIGN KEY (merchant_id) REFERENCES public.merchants(id) ON DELETE SET NULL not valid;

alter table "public"."coupons" validate constraint "coupons_merchant_id_fkey";

alter table "public"."coupons" add constraint "coupons_non_negative_check" CHECK (((COALESCE(discount_value, (0)::numeric) >= (0)::numeric) AND (COALESCE(max_discount_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(min_spend_amount, (0)::numeric) >= (0)::numeric))) not valid;

alter table "public"."coupons" validate constraint "coupons_non_negative_check";

alter table "public"."coupons" add constraint "coupons_source_id_fkey" FOREIGN KEY (source_id) REFERENCES public.sources(id) ON DELETE CASCADE not valid;

alter table "public"."coupons" validate constraint "coupons_source_id_fkey";

alter table "public"."coupons" add constraint "coupons_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'expired'::text, 'rejected'::text]))) not valid;

alter table "public"."coupons" validate constraint "coupons_status_check";

alter table "public"."coupons" add constraint "coupons_time_window_check" CHECK (((starts_at IS NULL) OR (ends_at IS NULL) OR (starts_at <= ends_at))) not valid;

alter table "public"."coupons" validate constraint "coupons_time_window_check";

alter table "public"."coupons" add constraint "coupons_validation_level_check" CHECK ((validation_level = ANY (ARRAY['checkout_verified'::text, 'official'::text, 'user_confirmed'::text, 'probable'::text, 'unverified'::text]))) not valid;

alter table "public"."coupons" validate constraint "coupons_validation_level_check";

alter table "public"."merchants" add constraint "merchants_country_code_check" CHECK (((country_code IS NULL) OR (country_code ~ '^[A-Z]{2}$'::text))) not valid;

alter table "public"."merchants" validate constraint "merchants_country_code_check";

alter table "public"."merchants" add constraint "merchants_slug_key" UNIQUE using index "merchants_slug_key";

alter table "public"."offer_benefits" add constraint "offer_benefits_amount_check" CHECK (((COALESCE(amount, (0)::numeric) >= (0)::numeric) AND ((percentage IS NULL) OR ((percentage >= (0)::numeric) AND (percentage <= (100)::numeric))))) not valid;

alter table "public"."offer_benefits" validate constraint "offer_benefits_amount_check";

alter table "public"."offer_benefits" add constraint "offer_benefits_currency_check" CHECK (((currency IS NULL) OR (currency ~ '^[A-Z]{3}$'::text))) not valid;

alter table "public"."offer_benefits" validate constraint "offer_benefits_currency_check";

alter table "public"."offer_benefits" add constraint "offer_benefits_offer_id_fkey" FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE not valid;

alter table "public"."offer_benefits" validate constraint "offer_benefits_offer_id_fkey";

alter table "public"."offer_benefits" add constraint "offer_benefits_type_check" CHECK ((benefit_type = ANY (ARRAY['cashback'::text, 'free_shipping'::text, 'points'::text, 'miles'::text, 'upgrade'::text, 'bonus'::text, 'other'::text]))) not valid;

alter table "public"."offer_benefits" validate constraint "offer_benefits_type_check";

alter table "public"."offer_conditions" add constraint "offer_conditions_coupon_id_fkey" FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE not valid;

alter table "public"."offer_conditions" validate constraint "offer_conditions_coupon_id_fkey";

alter table "public"."offer_conditions" add constraint "offer_conditions_offer_id_fkey" FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE not valid;

alter table "public"."offer_conditions" validate constraint "offer_conditions_offer_id_fkey";

alter table "public"."offer_conditions" add constraint "offer_conditions_operator_check" CHECK ((operator = ANY (ARRAY['eq'::text, 'neq'::text, 'gte'::text, 'lte'::text, 'in'::text, 'contains'::text, 'requires'::text, 'info'::text]))) not valid;

alter table "public"."offer_conditions" validate constraint "offer_conditions_operator_check";

alter table "public"."offer_conditions" add constraint "offer_conditions_parent_check" CHECK ((((offer_id IS NOT NULL) AND (coupon_id IS NULL)) OR ((offer_id IS NULL) AND (coupon_id IS NOT NULL)))) not valid;

alter table "public"."offer_conditions" validate constraint "offer_conditions_parent_check";

alter table "public"."offer_coupons" add constraint "offer_coupons_coupon_id_fkey" FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE not valid;

alter table "public"."offer_coupons" validate constraint "offer_coupons_coupon_id_fkey";

alter table "public"."offer_coupons" add constraint "offer_coupons_offer_id_fkey" FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE not valid;

alter table "public"."offer_coupons" validate constraint "offer_coupons_offer_id_fkey";

alter table "public"."offer_validations" add constraint "offer_validations_confidence_check" CHECK (((confidence IS NULL) OR ((confidence >= (0)::numeric) AND (confidence <= (1)::numeric)))) not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_confidence_check";

alter table "public"."offer_validations" add constraint "offer_validations_coupon_id_fkey" FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_coupon_id_fkey";

alter table "public"."offer_validations" add constraint "offer_validations_level_check" CHECK ((validation_level = ANY (ARRAY['checkout_verified'::text, 'official'::text, 'user_confirmed'::text, 'probable'::text, 'unverified'::text]))) not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_level_check";

alter table "public"."offer_validations" add constraint "offer_validations_method_check" CHECK ((method = ANY (ARRAY['checkout'::text, 'official_api'::text, 'official_feed'::text, 'partner'::text, 'user_report'::text, 'manual'::text, 'other'::text]))) not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_method_check";

alter table "public"."offer_validations" add constraint "offer_validations_offer_id_fkey" FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_offer_id_fkey";

alter table "public"."offer_validations" add constraint "offer_validations_parent_check" CHECK ((((offer_id IS NOT NULL) AND (coupon_id IS NULL)) OR ((offer_id IS NULL) AND (coupon_id IS NOT NULL)))) not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_parent_check";

alter table "public"."offer_validations" add constraint "offer_validations_result_check" CHECK ((result = ANY (ARRAY['success'::text, 'failure'::text, 'inconclusive'::text]))) not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_result_check";

alter table "public"."offer_validations" add constraint "offer_validations_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."offer_validations" validate constraint "offer_validations_user_id_fkey";

alter table "public"."offers" add constraint "offers_currency_check" CHECK ((currency ~ '^[A-Z]{3}$'::text)) not valid;

alter table "public"."offers" validate constraint "offers_currency_check";

alter table "public"."offers" add constraint "offers_discount_percentage_check" CHECK (((discount_percentage IS NULL) OR ((discount_percentage >= (0)::numeric) AND (discount_percentage <= (100)::numeric)))) not valid;

alter table "public"."offers" validate constraint "offers_discount_percentage_check";

alter table "public"."offers" add constraint "offers_merchant_id_fkey" FOREIGN KEY (merchant_id) REFERENCES public.merchants(id) ON DELETE SET NULL not valid;

alter table "public"."offers" validate constraint "offers_merchant_id_fkey";

alter table "public"."offers" add constraint "offers_non_negative_money_check" CHECK (((COALESCE(base_price, (0)::numeric) >= (0)::numeric) AND (COALESCE(instant_discount_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(fees_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(pay_now_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(cashback_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(effective_cost_amount, (0)::numeric) >= (0)::numeric))) not valid;

alter table "public"."offers" validate constraint "offers_non_negative_money_check";

alter table "public"."offers" add constraint "offers_product_service_id_fkey" FOREIGN KEY (product_service_id) REFERENCES public.products_services(id) ON DELETE SET NULL not valid;

alter table "public"."offers" validate constraint "offers_product_service_id_fkey";

alter table "public"."offers" add constraint "offers_source_id_fkey" FOREIGN KEY (source_id) REFERENCES public.sources(id) ON DELETE CASCADE not valid;

alter table "public"."offers" validate constraint "offers_source_id_fkey";

alter table "public"."offers" add constraint "offers_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'expired'::text, 'rejected'::text]))) not valid;

alter table "public"."offers" validate constraint "offers_status_check";

alter table "public"."offers" add constraint "offers_time_window_check" CHECK (((starts_at IS NULL) OR (ends_at IS NULL) OR (starts_at <= ends_at))) not valid;

alter table "public"."offers" validate constraint "offers_time_window_check";

alter table "public"."offers" add constraint "offers_validation_level_check" CHECK ((validation_level = ANY (ARRAY['checkout_verified'::text, 'official'::text, 'user_confirmed'::text, 'probable'::text, 'unverified'::text]))) not valid;

alter table "public"."offers" validate constraint "offers_validation_level_check";

alter table "public"."prices" add constraint "prices_currency_check" CHECK ((currency ~ '^[A-Z]{3}$'::text)) not valid;

alter table "public"."prices" validate constraint "prices_currency_check";

alter table "public"."prices" add constraint "prices_non_negative_money_check" CHECK (((COALESCE(base_price, (0)::numeric) >= (0)::numeric) AND (COALESCE(fees_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(pay_now_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(cashback_amount, (0)::numeric) >= (0)::numeric) AND (COALESCE(effective_cost_amount, (0)::numeric) >= (0)::numeric))) not valid;

alter table "public"."prices" validate constraint "prices_non_negative_money_check";

alter table "public"."prices" add constraint "prices_offer_id_fkey" FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE not valid;

alter table "public"."prices" validate constraint "prices_offer_id_fkey";

alter table "public"."products_services" add constraint "products_services_kind_check" CHECK ((kind = ANY (ARRAY['product'::text, 'service'::text, 'travel'::text, 'course'::text, 'subscription'::text, 'rental'::text, 'ticket'::text, 'other'::text]))) not valid;

alter table "public"."products_services" validate constraint "products_services_kind_check";

alter table "public"."search_intents" add constraint "search_intents_kind_check" CHECK ((intent_kind = ANY (ARRAY['buy'::text, 'rent'::text, 'book'::text, 'subscribe'::text, 'learn'::text, 'hire'::text, 'travel'::text, 'other'::text]))) not valid;

alter table "public"."search_intents" validate constraint "search_intents_kind_check";

alter table "public"."search_intents" add constraint "search_intents_quantity_check" CHECK (((quantity IS NULL) OR (quantity > 0))) not valid;

alter table "public"."search_intents" validate constraint "search_intents_quantity_check";

alter table "public"."search_intents" add constraint "search_intents_query_id_fkey" FOREIGN KEY (query_id) REFERENCES public.search_queries(id) ON DELETE CASCADE not valid;

alter table "public"."search_intents" validate constraint "search_intents_query_id_fkey";

alter table "public"."search_intents" add constraint "search_intents_time_window_check" CHECK (((start_at IS NULL) OR (end_at IS NULL) OR (start_at <= end_at))) not valid;

alter table "public"."search_intents" validate constraint "search_intents_time_window_check";

alter table "public"."search_queries" add constraint "search_queries_country_code_check" CHECK (((country_code IS NULL) OR (country_code ~ '^[A-Z]{2}$'::text))) not valid;

alter table "public"."search_queries" validate constraint "search_queries_country_code_check";

alter table "public"."search_queries" add constraint "search_queries_currency_check" CHECK (((currency IS NULL) OR (currency ~ '^[A-Z]{3}$'::text))) not valid;

alter table "public"."search_queries" validate constraint "search_queries_currency_check";

alter table "public"."search_queries" add constraint "search_queries_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."search_queries" validate constraint "search_queries_user_id_fkey";

alter table "public"."sources" add constraint "sources_merchant_id_fkey" FOREIGN KEY (merchant_id) REFERENCES public.merchants(id) ON DELETE SET NULL not valid;

alter table "public"."sources" validate constraint "sources_merchant_id_fkey";

alter table "public"."sources" add constraint "sources_trust_score_check" CHECK (((trust_score >= (0)::numeric) AND (trust_score <= (100)::numeric))) not valid;

alter table "public"."sources" validate constraint "sources_trust_score_check";

alter table "public"."sources" add constraint "sources_type_check" CHECK ((source_type = ANY (ARRAY['official_api'::text, 'official_feed'::text, 'affiliate'::text, 'partner'::text, 'marketplace'::text, 'public_web'::text, 'user_submission'::text, 'manual'::text, 'other'::text]))) not valid;

alter table "public"."sources" validate constraint "sources_type_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.set_private_item_owner_id()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  IF NEW.owner_id IS NULL AND auth.uid() IS NOT NULL THEN
    NEW.owner_id := auth.uid();
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = timezone('utc', now());
  RETURN NEW;
END;
$function$
;

grant delete on table "public"."coupons" to "anon";

grant insert on table "public"."coupons" to "anon";

grant references on table "public"."coupons" to "anon";

grant select on table "public"."coupons" to "anon";

grant trigger on table "public"."coupons" to "anon";

grant truncate on table "public"."coupons" to "anon";

grant update on table "public"."coupons" to "anon";

grant delete on table "public"."coupons" to "authenticated";

grant insert on table "public"."coupons" to "authenticated";

grant references on table "public"."coupons" to "authenticated";

grant select on table "public"."coupons" to "authenticated";

grant trigger on table "public"."coupons" to "authenticated";

grant truncate on table "public"."coupons" to "authenticated";

grant update on table "public"."coupons" to "authenticated";

grant delete on table "public"."coupons" to "service_role";

grant insert on table "public"."coupons" to "service_role";

grant references on table "public"."coupons" to "service_role";

grant select on table "public"."coupons" to "service_role";

grant trigger on table "public"."coupons" to "service_role";

grant truncate on table "public"."coupons" to "service_role";

grant update on table "public"."coupons" to "service_role";

grant delete on table "public"."merchants" to "anon";

grant insert on table "public"."merchants" to "anon";

grant references on table "public"."merchants" to "anon";

grant select on table "public"."merchants" to "anon";

grant trigger on table "public"."merchants" to "anon";

grant truncate on table "public"."merchants" to "anon";

grant update on table "public"."merchants" to "anon";

grant delete on table "public"."merchants" to "authenticated";

grant insert on table "public"."merchants" to "authenticated";

grant references on table "public"."merchants" to "authenticated";

grant select on table "public"."merchants" to "authenticated";

grant trigger on table "public"."merchants" to "authenticated";

grant truncate on table "public"."merchants" to "authenticated";

grant update on table "public"."merchants" to "authenticated";

grant delete on table "public"."merchants" to "service_role";

grant insert on table "public"."merchants" to "service_role";

grant references on table "public"."merchants" to "service_role";

grant select on table "public"."merchants" to "service_role";

grant trigger on table "public"."merchants" to "service_role";

grant truncate on table "public"."merchants" to "service_role";

grant update on table "public"."merchants" to "service_role";

grant delete on table "public"."offer_benefits" to "anon";

grant insert on table "public"."offer_benefits" to "anon";

grant references on table "public"."offer_benefits" to "anon";

grant select on table "public"."offer_benefits" to "anon";

grant trigger on table "public"."offer_benefits" to "anon";

grant truncate on table "public"."offer_benefits" to "anon";

grant update on table "public"."offer_benefits" to "anon";

grant delete on table "public"."offer_benefits" to "authenticated";

grant insert on table "public"."offer_benefits" to "authenticated";

grant references on table "public"."offer_benefits" to "authenticated";

grant select on table "public"."offer_benefits" to "authenticated";

grant trigger on table "public"."offer_benefits" to "authenticated";

grant truncate on table "public"."offer_benefits" to "authenticated";

grant update on table "public"."offer_benefits" to "authenticated";

grant delete on table "public"."offer_benefits" to "service_role";

grant insert on table "public"."offer_benefits" to "service_role";

grant references on table "public"."offer_benefits" to "service_role";

grant select on table "public"."offer_benefits" to "service_role";

grant trigger on table "public"."offer_benefits" to "service_role";

grant truncate on table "public"."offer_benefits" to "service_role";

grant update on table "public"."offer_benefits" to "service_role";

grant delete on table "public"."offer_conditions" to "anon";

grant insert on table "public"."offer_conditions" to "anon";

grant references on table "public"."offer_conditions" to "anon";

grant select on table "public"."offer_conditions" to "anon";

grant trigger on table "public"."offer_conditions" to "anon";

grant truncate on table "public"."offer_conditions" to "anon";

grant update on table "public"."offer_conditions" to "anon";

grant delete on table "public"."offer_conditions" to "authenticated";

grant insert on table "public"."offer_conditions" to "authenticated";

grant references on table "public"."offer_conditions" to "authenticated";

grant select on table "public"."offer_conditions" to "authenticated";

grant trigger on table "public"."offer_conditions" to "authenticated";

grant truncate on table "public"."offer_conditions" to "authenticated";

grant update on table "public"."offer_conditions" to "authenticated";

grant delete on table "public"."offer_conditions" to "service_role";

grant insert on table "public"."offer_conditions" to "service_role";

grant references on table "public"."offer_conditions" to "service_role";

grant select on table "public"."offer_conditions" to "service_role";

grant trigger on table "public"."offer_conditions" to "service_role";

grant truncate on table "public"."offer_conditions" to "service_role";

grant update on table "public"."offer_conditions" to "service_role";

grant delete on table "public"."offer_coupons" to "anon";

grant insert on table "public"."offer_coupons" to "anon";

grant references on table "public"."offer_coupons" to "anon";

grant select on table "public"."offer_coupons" to "anon";

grant trigger on table "public"."offer_coupons" to "anon";

grant truncate on table "public"."offer_coupons" to "anon";

grant update on table "public"."offer_coupons" to "anon";

grant delete on table "public"."offer_coupons" to "authenticated";

grant insert on table "public"."offer_coupons" to "authenticated";

grant references on table "public"."offer_coupons" to "authenticated";

grant select on table "public"."offer_coupons" to "authenticated";

grant trigger on table "public"."offer_coupons" to "authenticated";

grant truncate on table "public"."offer_coupons" to "authenticated";

grant update on table "public"."offer_coupons" to "authenticated";

grant delete on table "public"."offer_coupons" to "service_role";

grant insert on table "public"."offer_coupons" to "service_role";

grant references on table "public"."offer_coupons" to "service_role";

grant select on table "public"."offer_coupons" to "service_role";

grant trigger on table "public"."offer_coupons" to "service_role";

grant truncate on table "public"."offer_coupons" to "service_role";

grant update on table "public"."offer_coupons" to "service_role";

grant delete on table "public"."offer_validations" to "anon";

grant insert on table "public"."offer_validations" to "anon";

grant references on table "public"."offer_validations" to "anon";

grant select on table "public"."offer_validations" to "anon";

grant trigger on table "public"."offer_validations" to "anon";

grant truncate on table "public"."offer_validations" to "anon";

grant update on table "public"."offer_validations" to "anon";

grant delete on table "public"."offer_validations" to "authenticated";

grant insert on table "public"."offer_validations" to "authenticated";

grant references on table "public"."offer_validations" to "authenticated";

grant select on table "public"."offer_validations" to "authenticated";

grant trigger on table "public"."offer_validations" to "authenticated";

grant truncate on table "public"."offer_validations" to "authenticated";

grant update on table "public"."offer_validations" to "authenticated";

grant delete on table "public"."offer_validations" to "service_role";

grant insert on table "public"."offer_validations" to "service_role";

grant references on table "public"."offer_validations" to "service_role";

grant select on table "public"."offer_validations" to "service_role";

grant trigger on table "public"."offer_validations" to "service_role";

grant truncate on table "public"."offer_validations" to "service_role";

grant update on table "public"."offer_validations" to "service_role";

grant delete on table "public"."offers" to "anon";

grant insert on table "public"."offers" to "anon";

grant references on table "public"."offers" to "anon";

grant select on table "public"."offers" to "anon";

grant trigger on table "public"."offers" to "anon";

grant truncate on table "public"."offers" to "anon";

grant update on table "public"."offers" to "anon";

grant delete on table "public"."offers" to "authenticated";

grant insert on table "public"."offers" to "authenticated";

grant references on table "public"."offers" to "authenticated";

grant select on table "public"."offers" to "authenticated";

grant trigger on table "public"."offers" to "authenticated";

grant truncate on table "public"."offers" to "authenticated";

grant update on table "public"."offers" to "authenticated";

grant delete on table "public"."offers" to "service_role";

grant insert on table "public"."offers" to "service_role";

grant references on table "public"."offers" to "service_role";

grant select on table "public"."offers" to "service_role";

grant trigger on table "public"."offers" to "service_role";

grant truncate on table "public"."offers" to "service_role";

grant update on table "public"."offers" to "service_role";

grant delete on table "public"."prices" to "anon";

grant insert on table "public"."prices" to "anon";

grant references on table "public"."prices" to "anon";

grant select on table "public"."prices" to "anon";

grant trigger on table "public"."prices" to "anon";

grant truncate on table "public"."prices" to "anon";

grant update on table "public"."prices" to "anon";

grant delete on table "public"."prices" to "authenticated";

grant insert on table "public"."prices" to "authenticated";

grant references on table "public"."prices" to "authenticated";

grant select on table "public"."prices" to "authenticated";

grant trigger on table "public"."prices" to "authenticated";

grant truncate on table "public"."prices" to "authenticated";

grant update on table "public"."prices" to "authenticated";

grant delete on table "public"."prices" to "service_role";

grant insert on table "public"."prices" to "service_role";

grant references on table "public"."prices" to "service_role";

grant select on table "public"."prices" to "service_role";

grant trigger on table "public"."prices" to "service_role";

grant truncate on table "public"."prices" to "service_role";

grant update on table "public"."prices" to "service_role";

grant delete on table "public"."products_services" to "anon";

grant insert on table "public"."products_services" to "anon";

grant references on table "public"."products_services" to "anon";

grant select on table "public"."products_services" to "anon";

grant trigger on table "public"."products_services" to "anon";

grant truncate on table "public"."products_services" to "anon";

grant update on table "public"."products_services" to "anon";

grant delete on table "public"."products_services" to "authenticated";

grant insert on table "public"."products_services" to "authenticated";

grant references on table "public"."products_services" to "authenticated";

grant select on table "public"."products_services" to "authenticated";

grant trigger on table "public"."products_services" to "authenticated";

grant truncate on table "public"."products_services" to "authenticated";

grant update on table "public"."products_services" to "authenticated";

grant delete on table "public"."products_services" to "service_role";

grant insert on table "public"."products_services" to "service_role";

grant references on table "public"."products_services" to "service_role";

grant select on table "public"."products_services" to "service_role";

grant trigger on table "public"."products_services" to "service_role";

grant truncate on table "public"."products_services" to "service_role";

grant update on table "public"."products_services" to "service_role";

grant delete on table "public"."search_intents" to "anon";

grant insert on table "public"."search_intents" to "anon";

grant references on table "public"."search_intents" to "anon";

grant select on table "public"."search_intents" to "anon";

grant trigger on table "public"."search_intents" to "anon";

grant truncate on table "public"."search_intents" to "anon";

grant update on table "public"."search_intents" to "anon";

grant delete on table "public"."search_intents" to "authenticated";

grant insert on table "public"."search_intents" to "authenticated";

grant references on table "public"."search_intents" to "authenticated";

grant select on table "public"."search_intents" to "authenticated";

grant trigger on table "public"."search_intents" to "authenticated";

grant truncate on table "public"."search_intents" to "authenticated";

grant update on table "public"."search_intents" to "authenticated";

grant delete on table "public"."search_intents" to "service_role";

grant insert on table "public"."search_intents" to "service_role";

grant references on table "public"."search_intents" to "service_role";

grant select on table "public"."search_intents" to "service_role";

grant trigger on table "public"."search_intents" to "service_role";

grant truncate on table "public"."search_intents" to "service_role";

grant update on table "public"."search_intents" to "service_role";

grant delete on table "public"."search_queries" to "anon";

grant insert on table "public"."search_queries" to "anon";

grant references on table "public"."search_queries" to "anon";

grant select on table "public"."search_queries" to "anon";

grant trigger on table "public"."search_queries" to "anon";

grant truncate on table "public"."search_queries" to "anon";

grant update on table "public"."search_queries" to "anon";

grant delete on table "public"."search_queries" to "authenticated";

grant insert on table "public"."search_queries" to "authenticated";

grant references on table "public"."search_queries" to "authenticated";

grant select on table "public"."search_queries" to "authenticated";

grant trigger on table "public"."search_queries" to "authenticated";

grant truncate on table "public"."search_queries" to "authenticated";

grant update on table "public"."search_queries" to "authenticated";

grant delete on table "public"."search_queries" to "service_role";

grant insert on table "public"."search_queries" to "service_role";

grant references on table "public"."search_queries" to "service_role";

grant select on table "public"."search_queries" to "service_role";

grant trigger on table "public"."search_queries" to "service_role";

grant truncate on table "public"."search_queries" to "service_role";

grant update on table "public"."search_queries" to "service_role";

grant delete on table "public"."sources" to "anon";

grant insert on table "public"."sources" to "anon";

grant references on table "public"."sources" to "anon";

grant select on table "public"."sources" to "anon";

grant trigger on table "public"."sources" to "anon";

grant truncate on table "public"."sources" to "anon";

grant update on table "public"."sources" to "anon";

grant delete on table "public"."sources" to "authenticated";

grant insert on table "public"."sources" to "authenticated";

grant references on table "public"."sources" to "authenticated";

grant select on table "public"."sources" to "authenticated";

grant trigger on table "public"."sources" to "authenticated";

grant truncate on table "public"."sources" to "authenticated";

grant update on table "public"."sources" to "authenticated";

grant delete on table "public"."sources" to "service_role";

grant insert on table "public"."sources" to "service_role";

grant references on table "public"."sources" to "service_role";

grant select on table "public"."sources" to "service_role";

grant trigger on table "public"."sources" to "service_role";

grant truncate on table "public"."sources" to "service_role";

grant update on table "public"."sources" to "service_role";


  create policy "coupons_public_read"
  on "public"."coupons"
  as permissive
  for select
  to public
using ((status = 'active'::text));



  create policy "merchants_public_read"
  on "public"."merchants"
  as permissive
  for select
  to public
using (active);



  create policy "offer_benefits_public_read"
  on "public"."offer_benefits"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.offers
  WHERE ((offers.id = offer_benefits.offer_id) AND (offers.status = 'active'::text)))));



  create policy "offer_conditions_public_read"
  on "public"."offer_conditions"
  as permissive
  for select
  to public
using ((((offer_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.offers
  WHERE ((offers.id = offer_conditions.offer_id) AND (offers.status = 'active'::text))))) OR ((coupon_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.coupons
  WHERE ((coupons.id = offer_conditions.coupon_id) AND (coupons.status = 'active'::text)))))));



  create policy "offer_coupons_public_read"
  on "public"."offer_coupons"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.offers
  WHERE ((offers.id = offer_coupons.offer_id) AND (offers.status = 'active'::text)))));



  create policy "offer_validations_user_read"
  on "public"."offer_validations"
  as permissive
  for select
  to authenticated
using ((user_id = auth.uid()));



  create policy "offer_validations_user_report_insert"
  on "public"."offer_validations"
  as permissive
  for insert
  to authenticated
with check (((user_id = auth.uid()) AND (method = 'user_report'::text) AND (validation_level = 'user_confirmed'::text)));



  create policy "offers_public_read"
  on "public"."offers"
  as permissive
  for select
  to public
using ((status = 'active'::text));



  create policy "prices_public_read"
  on "public"."prices"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.offers
  WHERE ((offers.id = prices.offer_id) AND (offers.status = 'active'::text)))));



  create policy "products_services_public_read"
  on "public"."products_services"
  as permissive
  for select
  to public
using (active);



  create policy "search_intents_user_insert"
  on "public"."search_intents"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.search_queries
  WHERE ((search_queries.id = search_intents.query_id) AND (search_queries.user_id = auth.uid())))));



  create policy "search_intents_user_read"
  on "public"."search_intents"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.search_queries
  WHERE ((search_queries.id = search_intents.query_id) AND (search_queries.user_id = auth.uid())))));



  create policy "search_queries_user_insert"
  on "public"."search_queries"
  as permissive
  for insert
  to authenticated
with check ((user_id = auth.uid()));



  create policy "search_queries_user_read"
  on "public"."search_queries"
  as permissive
  for select
  to authenticated
using ((user_id = auth.uid()));



  create policy "sources_public_read"
  on "public"."sources"
  as permissive
  for select
  to public
using (active);


CREATE TRIGGER set_updated_at_coupons BEFORE UPDATE ON public.coupons FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_merchants BEFORE UPDATE ON public.merchants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_offers BEFORE UPDATE ON public.offers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_products_services BEFORE UPDATE ON public.products_services FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_sources BEFORE UPDATE ON public.sources FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
