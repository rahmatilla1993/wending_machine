create function auth.password_match(raw_password character varying, encode_password text) returns boolean
    language plpgsql
as
$$
begin
    return encode_password = utils.crypt(raw_password, encode_password);
end;
$$;

alter function auth.password_match(varchar, text) owner to postgres;

