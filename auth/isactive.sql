create procedure auth.isactive(IN userid integer)
    language plpgsql
as
$$
    begin
        if not exists(select * from auth.auth_user where id = userid) then
            raise exception 'User not found "%"', userid;
        end if;
    end;
$$;

alter procedure auth.isactive(integer) owner to postgres;

