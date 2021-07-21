create role atm_user nologin;
grant atm_user to dba;

grant usage on schema public to atm_user;
grant all on public."ATM locations" to atm_user;
grant usage, select on sequence public."ATM locations_ID_seq" to atm_user;
