create function auth.auth_login(e_mail character varying, pswd character varying) returns text
    language plpgsql
as
$$
declare
    v_user record;
begin
    if e_mail is null then
        raise exception 'Email is null';
    end if;
    if pswd is null then
        raise exception 'Password is null';
    end if;
    if not auth.check_valid_email(e_mail) then
        raise exception 'Email did not match';
    end if;
    select * into v_user from auth.auth_user where email ilike e_mail;
    if not FOUND or not auth.match_password(pswd, v_user.password) then
        raise exception 'Bad credentials';
    end if;

    return json_build_object(
            'firstname', v_user.first_name,
            'lastname', v_user.last_name,
            'email', v_user.email
           );
end;
$$;

alter function auth.auth_login(varchar, varchar) owner to postgres;

