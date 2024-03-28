create type product.create_product_dto as
(
    name        varchar,
    price       numeric(10, 2),
    quantity    integer,
    category_id integer
);

alter type product.create_product_dto owner to postgres;

