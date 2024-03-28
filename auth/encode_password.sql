create function auth.encode_password(raw_password character varying) returns text
    language plpgsql
as
$$
begin
    return utils.crypt(raw_password, utils.gen_salt('bf', 4));
end;
$$;

alter function auth.encode_password(varchar) owner to postgres;

