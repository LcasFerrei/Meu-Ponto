-- Meu Ponto — schema do Supabase
-- Cole e rode este script inteiro no SQL Editor do seu projeto Supabase
-- (Supabase Dashboard > SQL Editor > New query > colar > Run)

create table if not exists kv_store (
  key text primary key,
  value text not null,
  updated_at timestamptz not null default now()
);

-- Acesso aberto via chave anon (sem login), conforme escolhido.
-- Se um dia quiser restringir o acesso, habilite RLS e crie policies aqui.
alter table kv_store disable row level security;

grant select, insert, update, delete on kv_store to anon;
