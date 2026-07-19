-- Roda isso pra garantir que o RLS está mesmo desligado e as permissões aplicadas
alter table public.kv_store disable row level security;
grant usage on schema public to anon;
grant select, insert, update, delete on public.kv_store to anon;

-- Checagem: relrowsecurity deve vir "false"
select relrowsecurity, relforcerowsecurity from pg_class where relname = 'kv_store';
