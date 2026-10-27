-- Initial single-owner release. Collaboration requires explicit membership policies.
create table public.events (
 id uuid primary key,
 owner_id uuid not null references auth.users(id),
 data jsonb not null,
 updated_at timestamptz not null default now(),
 constraint event_identity check (data->>'id' = id::text),
 constraint event_title check (length(trim(data->>'title')) > 0),
 constraint event_dates check ((data->>'end') > (data->>'start')),
 constraint event_price check ((data->>'price')::numeric >= 0)
);
create index events_owner_updated on public.events(owner_id, updated_at desc);
alter table public.events enable row level security;
create policy own_events_select on public.events for select to authenticated using (auth.uid() = owner_id);
create policy own_events_insert on public.events for insert to authenticated with check (auth.uid() = owner_id);
create policy own_events_update on public.events for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy own_events_delete on public.events for delete to authenticated using (auth.uid() = owner_id and jsonb_array_length(data->'receipts') = 0 and jsonb_array_length(data->'expenses') = 0 and not jsonb_path_exists(data, '$.musicians[*] ? (@.paid > 0)'));
