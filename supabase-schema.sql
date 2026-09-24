-- Stillzeit v3 family sync — paste into the Supabase SQL Editor and Run.
-- Shares the Brain Relieve project; every object carries the sz_ prefix.

create extension if not exists pgcrypto;

create table if not exists public.sz_households (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Familie',
  code text not null unique,
  created_by uuid not null default auth.uid() references auth.users (id) on delete cascade,
  created_at bigint not null
);

create table if not exists public.sz_members (
  household_id uuid not null references public.sz_households (id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  joined_at bigint not null,
  primary key (household_id, user_id)
);

create table if not exists public.sz_children (
  id text not null,
  household_id uuid not null references public.sz_households (id) on delete cascade,
  name text not null,
  born bigint,
  created_at bigint not null,
  updated_at bigint not null,
  deleted boolean not null default false,
  primary key (household_id, id)
);

create table if not exists public.sz_events (
  id text not null,
  household_id uuid not null references public.sz_households (id) on delete cascade,
  child_id text not null,
  type text not null,
  start_ts bigint not null,
  end_ts bigint,
  value double precision,
  unit text,
  note text,
  side text,
  created_by uuid not null default auth.uid(),
  created_at bigint not null,
  updated_at bigint not null,
  deleted boolean not null default false,
  primary key (household_id, id)
);

create index if not exists sz_events_hh_updated on public.sz_events (household_id, updated_at);
create index if not exists sz_children_hh_updated on public.sz_children (household_id, updated_at);

-- membership check used by every policy (security definer avoids recursive RLS)
create or replace function public.sz_is_member(hid uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from public.sz_members where household_id = hid and user_id = auth.uid());
$$;

alter table public.sz_households enable row level security;
alter table public.sz_members   enable row level security;
alter table public.sz_children  enable row level security;
alter table public.sz_events    enable row level security;

create policy "sz hh select" on public.sz_households for select using (public.sz_is_member(id));

create policy "sz mem select" on public.sz_members for select using (user_id = auth.uid() or public.sz_is_member(household_id));

create policy "sz ch select" on public.sz_children for select using (public.sz_is_member(household_id));
create policy "sz ch insert" on public.sz_children for insert with check (public.sz_is_member(household_id));
create policy "sz ch update" on public.sz_children for update using (public.sz_is_member(household_id));

create policy "sz ev select" on public.sz_events for select using (public.sz_is_member(household_id));
create policy "sz ev insert" on public.sz_events for insert with check (public.sz_is_member(household_id));
create policy "sz ev update" on public.sz_events for update using (public.sz_is_member(household_id));

-- create a household and become its first member; returns {id, code}
create or replace function public.sz_create(p_name text default 'Familie') returns json
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid; v_code text; v_now bigint := (extract(epoch from now()) * 1000)::bigint;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  loop
    v_code := upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 4) || '-' || substr(replace(gen_random_uuid()::text, '-', ''), 1, 4));
    exit when not exists (select 1 from public.sz_households where code = v_code);
  end loop;
  insert into public.sz_households (name, code, created_by, created_at) values (coalesce(p_name, 'Familie'), v_code, auth.uid(), v_now) returning id into v_id;
  insert into public.sz_members (household_id, user_id, joined_at) values (v_id, auth.uid(), v_now);
  return json_build_object('id', v_id, 'code', v_code);
end $$;

-- join an existing household by its code; returns {id, code}
create or replace function public.sz_join(p_code text) returns json
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid; v_now bigint := (extract(epoch from now()) * 1000)::bigint;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  select id into v_id from public.sz_households where code = upper(trim(p_code));
  if v_id is null then raise exception 'unknown code'; end if;
  insert into public.sz_members (household_id, user_id, joined_at) values (v_id, auth.uid(), v_now) on conflict do nothing;
  return json_build_object('id', v_id, 'code', upper(trim(p_code)));
end $$;

grant execute on function public.sz_create(text) to authenticated;
grant execute on function public.sz_join(text) to authenticated;
grant execute on function public.sz_is_member(uuid) to authenticated;
