-- BRND FIT – database in Supabase. Plak dit in Supabase → SQL Editor → Run.

-- 1. Alle app-gegevens (trainingen, planningen, profielen, metingen, gezondheid, ...)
create table if not exists public.docs (
  col text not null,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);
alter table public.docs enable row level security;
drop policy if exists "ingelogde leden" on public.docs;
create policy "ingelogde leden" on public.docs for all to authenticated using (true) with check (true);

-- Live bijwerken tussen jullie telefoons
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

-- 2. Koppelcodes voor Apple Gezondheid (één per persoon)
create table if not exists public.health_tokens (
  token text primary key,
  person text not null,
  created_at timestamptz not null default now()
);
alter table public.health_tokens enable row level security;
drop policy if exists "ingelogde leden" on public.health_tokens;
create policy "ingelogde leden" on public.health_tokens for all to authenticated using (true) with check (true);

-- 3. Brievenbus voor de iPhone-automatisering. Werkt zonder inloggen, maar alleen met een geldige koppelcode.
--    p_sleep mag in seconden, minuten of uren: de functie rekent het om naar minuten.
create or replace function public.ingest_health(
  p_token text, p_date date, p_steps numeric default null, p_active_kcal numeric default null, p_sleep numeric default null
) returns text language plpgsql security definer set search_path = public as $$
declare v_person text; v_sleep int; v_new jsonb;
begin
  select person into v_person from health_tokens where token = p_token;
  if v_person is null then raise exception 'Onbekende koppelcode'; end if;
  v_sleep := case when p_sleep is null then null
                  when p_sleep > 2000 then round(p_sleep / 60)
                  when p_sleep <= 24 then round(p_sleep * 60)
                  else round(p_sleep) end;
  v_new := jsonb_strip_nulls(jsonb_build_object('user', v_person, 'date', p_date::text, 'steps', round(p_steps),
             'activeKcal', round(p_active_kcal), 'sleepMin', v_sleep, 'source', 'apple', 'syncedAt', now()));
  insert into docs(col, id, data, updated_at) values ('health', v_person || '_' || p_date::text, v_new, now())
  on conflict (col, id) do update set data = docs.data || excluded.data, updated_at = now();
  return 'ok ' || v_person;
end $$;
revoke all on function public.ingest_health(text, date, numeric, numeric, numeric) from public;
grant execute on function public.ingest_health(text, date, numeric, numeric, numeric) to anon, authenticated;

-- Eenvoudige variant voor de opdracht op de iPhone: alleen code + waarden, datum = vandaag (NL-tijd).
create or replace function public.brnd_sync(
  code text, stappen numeric default null, slaap numeric default null, kcal numeric default null
) returns text language sql security definer set search_path = public as $$
  select public.ingest_health(code, (now() at time zone 'Europe/Amsterdam')::date, stappen, kcal, slaap);
$$;
revoke all on function public.brnd_sync(text, numeric, numeric, numeric) from public;
grant execute on function public.brnd_sync(text, numeric, numeric, numeric) to anon, authenticated;
