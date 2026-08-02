-- Meu Ponto — bucket de Storage para fotos/anexos + tabela de backups automáticos
-- Cole e rode este script inteiro no SQL Editor do Supabase.

-- 1) Bucket de Storage "fotos" (acesso aberto, mesmo modelo do kv_store)
insert into storage.buckets (id, name, public)
values ('fotos', 'fotos', true)
on conflict (id) do nothing;

create policy "fotos - leitura publica" on storage.objects
  for select using (bucket_id = 'fotos');
create policy "fotos - upload publico" on storage.objects
  for insert with check (bucket_id = 'fotos');
create policy "fotos - update publico" on storage.objects
  for update using (bucket_id = 'fotos');
create policy "fotos - delete publico" on storage.objects
  for delete using (bucket_id = 'fotos');

-- 2) Tabela de backups automáticos (1 snapshot por dia, mantém os últimos 30)
create table if not exists backups (
  id text primary key, -- data no formato AAAA-MM-DD
  snapshot text not null,
  created_at timestamptz not null default now()
);
alter table backups disable row level security;
grant select, insert, update, delete on backups to anon;
