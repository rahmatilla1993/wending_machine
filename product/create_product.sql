create function product.create_product(data_params text, userid integer) returns integer
    language plpgsql
as
$$
declare
    dto       product.create_product_dto;
    data_json json;
    error_dto utils.error_dto;
    rowID     int;
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if data_params is null then
        raise exception 'Params is null';
    end if;

    data_json := data_params::json;
    dto.name := data_json ->> 'name';
    dto.price := data_json ->> 'price';
    dto.quantity := data_json ->> 'quantity';
    dto.category_id := data_json ->> 'category_id';

    insert into product (name, price, quantity, category_id)
    values (dto.name,
            dto.price,
            dto.quantity,
            dto.category_id)
    returning id into rowID;
    return rowID;
exception
    when not_null_violation then
        get stacked diagnostics
            error_dto.code = returned_sqlstate,
            error_dto.column_name = column_name;
        raise exception using
            message = concat(error_dto.column_name, ' must be not empty'),
            errcode = error_dto.code;
    when foreign_key_violation then
        get stacked diagnostics
            error_dto.code = returned_sqlstate,
            error_dto.message = pg_exception_detail;
        raise exception using
            message = error_dto.message,
            errcode = error_dto.code;

end;
$$;

alter function product.create_product(text, integer) owner to postgres;

