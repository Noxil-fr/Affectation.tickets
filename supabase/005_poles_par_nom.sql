-- =====================================================================
-- Mise à jour 005 : pôle de chaque consultant, d'après son nom exact
-- À exécuter une seule fois dans Supabase > SQL Editor > New query,
-- après la mise à jour 004. Ajoute le pôle « Manager ».
-- =====================================================================

-- Pôles autorisés, dont le nouveau pôle Manager
alter table public.people drop constraint if exists people_poles_check;
alter table public.people
  add constraint people_poles_check check (poles <@ array['APV', 'Technique', 'VN/VO', 'Compta', 'Manager']::text[]);

-- On repart de zéro, puis un seul pôle par personne
update public.people set poles = '{}';

update public.people set poles = '{APV}' where name in (
  'Antoine LANCELOT', 'Christophe MORLEGHEM', 'Freddy KIFFER', 'Jeyson ADELLE', 'Maria SIMOES',
  'Raphael RIGAUD', 'Sophie DUPONT', 'Theo BEYENS', 'Thierry ANTOINE', 'Victor FONCILLAS GARCIA'
);

update public.people set poles = '{Technique}' where name in (
  'Diogo RIBEIRO DA COSTA', 'Hanh NGUYEN', 'Paulo DIAS DA ROCHA'
);

update public.people set poles = '{VN/VO}' where name in (
  'Loic WANSAR', 'Maria Jose HERNANDEZ', 'Sylvie RODRIGUES'
);

update public.people set poles = '{Compta}' where name in ('Luc MENARD');

update public.people set poles = '{Manager}' where name in ('Silvia BARBOSA PEREIRA');

-- Vérification : chaque personne doit avoir un pôle
select name, poles from public.people order by poles[1] nulls first, name;
