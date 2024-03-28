create type auth.auth_role as enum ('USER', 'ADMIN');

alter type auth.auth_role owner to postgres;

