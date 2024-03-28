create function auth.balance_payment(amount numeric, userid integer) returns boolean
    language plpgsql
as
$$
begin
    call auth.isactive(userid);
    update auth.auth_user set balance = balance + amount where id = userid;
    return true;
end
$$;

alter function auth.balance_payment(numeric, integer) owner to postgres;

