create type utils.error_dto as
(
    code        varchar,
    message     varchar,
    column_name varchar
);

alter type utils.error_dto owner to postgres;

