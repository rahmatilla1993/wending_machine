create type auth.auth_register_dto as
(
    first_name varchar,
    last_name  varchar,
    email      varchar,
    password   varchar
);

alter type auth.auth_register_dto owner to postgres;

