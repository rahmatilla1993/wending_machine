create procedure auth.check_admin_permission(IN userid integer)
    language plpgsql
as
$$
declare
    v_user record;
begin
    select * into v_user from auth.auth_user where id = userid;
    if v_user.role <> 'ADMIN' then
        raise exception 'Permission denied';
    end if;
end;
$$;

alter procedure auth.check_admin_permission(integer) owner to postgres;

