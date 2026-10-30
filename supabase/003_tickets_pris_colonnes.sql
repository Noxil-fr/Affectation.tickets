-- =====================================================================
-- Mise à jour 003 : colonnes Pôle, Organisation et Demandeur des tickets pris
-- À exécuter une seule fois dans Supabase > SQL Editor > New query,
-- sur une base où la mise à jour 002 a déjà été exécutée.
-- =====================================================================

alter table public.self_tickets
  add column if not exists pole         text,   -- pôle du ticket
  add column if not exists organisation text,   -- organisation du demandeur
  add column if not exists requester    text;   -- demandeur
