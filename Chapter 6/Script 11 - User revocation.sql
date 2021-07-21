create schema auth; 
grant usage on schema auth to web_anon, atm_user; 

create or replace function auth.check_token() returns void 
    language plpgsql
    as $$ 
begin 
    if current_setting('request.jwt.claim.email', true) = 'not.good@mypostgrest.com' then 
        raise insufficient_privilege using hint = 'Nope, we are on to you'; 
    end if; 
end $$;
