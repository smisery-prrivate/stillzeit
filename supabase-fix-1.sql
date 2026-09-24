-- Fix 1 (2026-09-24): family code without pgcrypto.
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
