-- Fix 2 (2026-10-09): side accepts only L, R or empty. Second line of defence behind the app's own check (v16).
-- Run the three steps one after the other in the Supabase SQL Editor.

-- 1) Look first. This must return no rows.
select household_id, id, side, created_by, to_timestamp(updated_at / 1000.0) as changed
from public.sz_events
where side is not null and side not in ('L','R');

-- 2) The rule for every new or changed row from now on (existing rows are not checked yet).
alter table public.sz_events
  add constraint sz_events_side_chk check (side is null or side in ('L','R')) not valid;

-- 3) Check the existing rows too. Passes only when step 1 returned nothing.
alter table public.sz_events validate constraint sz_events_side_chk;
