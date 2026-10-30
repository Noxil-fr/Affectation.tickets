-- =====================================================================
-- Mise à jour 004 : pôles des consultants (APV, Technique, VN/VO, Compta)
-- À exécuter une seule fois dans Supabase > SQL Editor > New query.
-- Un seul pôle par personne : la colonne est une liste, seul le premier élément compte.
-- =====================================================================

alter table public.people
  add column if not exists poles text[] not null default '{}';

alter table public.people drop constraint if exists people_poles_check;
alter table public.people
  add constraint people_poles_check check (poles <@ array['APV', 'Technique', 'VN/VO', 'Compta']::text[]);

-- Le site doit pouvoir modifier les pôles d'une personne existante
drop policy if exists people_update on public.people;
create policy people_update on public.people for update to authenticated
  using (public.is_member()) with check (public.is_member());

-- ---------------------------------------------------------------------
-- Pôles des personnes déjà enregistrées (noms = prénoms, accents tolérés)
-- ---------------------------------------------------------------------
update public.people set poles = '{APV}'
  where trim(name) ~* '^(sophie|christophe|raph(a[eë]l)?|antoine|thierry|th[eé]o|freddy|jeyson|maria|victor|hafsa)$';

update public.people set poles = '{Technique}'
  where trim(name) ~* '^(hanh|diogo|paulo)$';

update public.people set poles = '{VN/VO}'
  where trim(name) ~* '^(sylvie|maria[ -]jos[eé])$';

update public.people set poles = '{Compta}'
  where trim(name) ~* '^luc$';

-- Vérification : personnes et pôles
select name, poles from public.people order by name;
