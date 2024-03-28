create function auth.check_valid_email(email character varying) returns boolean
    language plpgsql
as
$$
begin
    return email ~ '^[a-z][a-z0-9]{2,30}@\w{4,5}.\w{2,3}$';
end;
$$;

alter function auth.check_valid_email(varchar) owner to postgres;

