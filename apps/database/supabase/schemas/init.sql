-- =============================================================================
-- Extensions
-- =============================================================================

create extension if not exists "uuid-ossp" with schema "extensions";
create extension if not exists "pgcrypto" with schema "extensions";

-- =============================================================================
-- Shared functions
-- =============================================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

revoke execute on function public.set_updated_at() from public;
revoke execute on function public.set_updated_at() from anon;
revoke execute on function public.set_updated_at() from authenticated;
grant execute on function public.set_updated_at() to service_role;

-- =============================================================================
-- Schema grants
-- =============================================================================

grant usage on schema public to postgres;
grant usage on schema public to anon;
grant usage on schema public to authenticated;
grant usage on schema public to service_role;
grant usage on schema public to supabase_auth_admin;

alter default privileges for role postgres in schema public grant all on sequences to postgres;
alter default privileges for role postgres in schema public grant all on sequences to service_role;

alter default privileges for role postgres in schema public grant all on functions to postgres;
alter default privileges for role postgres in schema public grant all on functions to service_role;

alter default privileges for role postgres in schema public grant all on tables to postgres;
alter default privileges for role postgres in schema public grant all on tables to service_role;
