create role web_anon nologin;
grant web_anon to dba;

grant usage on schema public to web_anon;
grant select on public."ATM locations" to web_anon;
