create type product.edit_product_dto as
(
    id          integer,
    name        varchar,
    price       numeric(10, 2),
    quantity    integer,
    category_id integer
);

alter type product.edit_product_dto owner to postgres;

