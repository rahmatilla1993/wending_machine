create procedure transaction.make_transaction(IN data_params text, IN userid integer)
    language plpgsql
as
$$
declare
    dto       transaction.transaction_dto;
    data_json json;
    total_sum numeric(10, 2);
    v_product record;
    error_dto utils.error_dto;
begin

    call auth.isactive(userid);
    if data_params is null then
        raise exception 'Params is null';
    end if;
    data_json := data_params::json;
    dto.product_id := data_json ->> 'product_id';
    dto.quantity_purchased := data_json ->> 'quantity_purchased';
    select * into v_product from product.product where id = dto.product_id;
    if not FOUND then
        raise exception 'Product not found';
    end if;
    if dto.quantity_purchased > v_product.quantity then
        raise exception 'There is not enough product in the vending machine';
    end if;
    total_sum := v_product.price * dto.quantity_purchased;

    update product.product set quantity = quantity - dto.quantity_purchased where id = v_product.id;
    update auth.auth_user set balance = balance - total_sum where id = userid;
    insert into transaction.transactions(product_id,
                                         user_id,
                                         quantity_purchased,
                                         total_price)
    values (v_product.id, userid, dto.quantity_purchased, total_sum);
exception
    when check_violation then
        get stacked diagnostics
            error_dto.code = returned_sqlstate;
        rollback;
        raise exception using
            errcode = error_dto.code,
            message = 'You don''t have enough money in your account';
    when others then
        get stacked diagnostics
            error_dto.message = message_text,
            error_dto.code = returned_sqlstate;
        rollback;
        raise exception using
            errcode = error_dto.code,
            message = error_dto.message;

end;
$$;

alter procedure transaction.make_transaction(text, integer) owner to postgres;

