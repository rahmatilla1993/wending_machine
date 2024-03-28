create function product.edit_product(data_params text, userid integer) returns boolean
    language plpgsql
as
$$
declare
    data_json json;
    dto       product.edit_product_dto;
    v_product record;
    error_dto utils.error_dto;
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if data_params is null then
        raise exception 'Params is null';
    end if;
    data_json := data_params::json;
    dto.id := data_json ->> 'id';
    if dto.id is null then
        raise exception 'Product id is null';
    end if;

    select * into v_product from product.product where id = dto.id;
    if not category.check_category_byid(v_product.category_id) then
        raise exception 'Category not found';
    end if;

    dto.name := coalesce(data_json ->> 'name', v_product.name);
    dto.price := coalesce(data_json ->> 'price', v_product.price::text);
    dto.quantity := coalesce(data_json ->> 'quantity', v_product.quantity::text);
    dto.category_id := coalesce(data_json ->> 'category_id', v_product.category_id::text);

    update product
    set name        = dto.name,
        quantity    = dto.quantity,
        price       = dto.price,
        category_id = dto.category_id
    where id = dto.id;
    return true;

exception
    when foreign_key_violation then
        get stacked diagnostics
            error_dto.code = returned_sqlstate,
            error_dto.message = pg_exception_detail;
        raise exception using
            message = error_dto.message,
            errcode = error_dto.code;
end;
$$;

alter function product.edit_product(text, integer) owner to postgres;

