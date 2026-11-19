-- Atelier Boucherie : schema complet Supabase (peut etre relance sans risque)
-- SQL Editor > New query > coller > Run

create table if not exists public.students (
  id bigint primary key,
  site text not null,
  groupe text not null,
  nom text not null
);

create table if not exists public.records (
  id bigint primary key,
  date date not null,
  site text not null,
  groupe text not null,
  student_id bigint,
  nom text not null,
  absent boolean not null default false,
  espece text,
  morceau text,
  quantite integer not null default 0,
  evaluation text check (evaluation in ('A','B','C','D')),
  evaluation_num smallint check (evaluation_num between 1 and 4),
  observation text
);
alter table public.records add column if not exists archive boolean not null default false;
alter table public.records add column if not exists annee smallint;
alter table public.records drop constraint if exists records_student_id_fkey;

create table if not exists public.photos (
  student_id bigint primary key,
  data text not null
);

create table if not exists public.meta (
  key text primary key,
  value jsonb not null default '{}'::jsonb
);

create index if not exists records_site_date_idx on public.records (site, date);
create index if not exists records_student_idx on public.records (student_id);

-- Securite : seuls les comptes connectes (formateurs) accedent aux donnees
alter table public.students enable row level security;
alter table public.records enable row level security;
alter table public.photos enable row level security;
alter table public.meta enable row level security;

drop policy if exists "lecture test" on public.students;
drop policy if exists "lecture test" on public.records;
drop policy if exists "formateurs" on public.students;
drop policy if exists "formateurs" on public.records;
drop policy if exists "formateurs" on public.photos;
drop policy if exists "formateurs" on public.meta;

create policy "formateurs" on public.students for all to authenticated using (true) with check (true);
create policy "formateurs" on public.records  for all to authenticated using (true) with check (true);
create policy "formateurs" on public.photos   for all to authenticated using (true) with check (true);
create policy "formateurs" on public.meta     for all to authenticated using (true) with check (true);

-- Temps reel (les changements d'un formateur apparaissent chez les autres)
do $$ begin alter publication supabase_realtime add table public.students; exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table public.records;  exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table public.photos;   exception when others then null; end $$;
do $$ begin alter publication supabase_realtime add table public.meta;     exception when others then null; end $$;
