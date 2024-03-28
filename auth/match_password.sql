create function auth.match_password(raw_password character varying, encode_password text) returns boolean
    language plpgsql
as
$$
begin
    return encode_password = utils.crypt(raw_password, encode_password);
end;
$$;

alter function auth.match_password(varchar, text) owner to postgres;

