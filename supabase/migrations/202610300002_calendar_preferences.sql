-- Per-user configuration. No Google tokens or credentials are stored here.
create table public.calendar_preferences (
 owner_id uuid primary key references auth.users(id) on delete cascade,
 primary_calendar text not null default '',
 availability_calendars text[] not null default '{}'
);
alter table public.calendar_preferences enable row level security;
grant select, insert, update, delete on public.calendar_preferences to authenticated;
create policy own_calendar_preferences on public.calendar_preferences for all to authenticated
 using (owner_id = auth.uid()) with check (owner_id = auth.uid());
