create type transaction.transaction_dto as
(
    product_id         integer,
    quantity_purchased integer
);

alter type transaction.transaction_dto owner to postgres;

