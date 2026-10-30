-- Table privileges and RLS policies are both required by the Data API.
-- Keep access limited to signed-in users; existing RLS policies restrict rows.
begin;
grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.events to authenticated;
commit;
