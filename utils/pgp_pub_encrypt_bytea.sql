create function utils.pgp_pub_encrypt_bytea(bytea, bytea) returns bytea
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function utils.pgp_pub_encrypt_bytea(bytea, bytea) owner to postgres;

create function utils.pgp_pub_encrypt_bytea(bytea, bytea, text) returns bytea
    strict
    parallel safe
    language c
as
$$
begin
-- missing source code
end;
$$;

alter function utils.pgp_pub_encrypt_bytea(bytea, bytea, text) owner to postgres;

