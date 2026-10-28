-- =====================================================================
-- Mise à jour 002 : tickets pris directement par les consultants
-- À exécuter une seule fois dans Supabase > SQL Editor > New query,
-- sur une base déjà créée avec schema.sql.
-- =====================================================================

create table public.self_tickets (
  id         text primary key,            -- identifiant du ticket (ex. n° de ticket)
  person     text not null,               -- consultant qui a pris le ticket
  taken_on   date not null,               -- date prise en compte dans les statistiques
  label      text,                        -- sujet, pour mémoire
  created_at timestamptz not null default now(),
  created_by uuid default auth.uid()
);
create index self_tickets_taken_on_idx on public.self_tickets (taken_on);

alter table public.self_tickets enable row level security;

create policy self_tickets_select on public.self_tickets for select to authenticated using (public.is_member());
create policy self_tickets_insert on public.self_tickets for insert to authenticated with check (public.is_member());
create policy self_tickets_update on public.self_tickets for update to authenticated
  using (public.is_member()) with check (public.is_member());
create policy self_tickets_delete on public.self_tickets for delete to authenticated using (public.is_member());

alter publication supabase_realtime add table public.self_tickets;
