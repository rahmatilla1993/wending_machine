create function product.add_product_quantity(prod_count integer, prod_id integer, userid integer) returns boolean
    language plpgsql
as
$$
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if not exists(select * from product.product where id = prod_id) then
        raise exception 'Product not found "%"', prod_id;
    end if;
    update product.product set quantity = quantity + prod_count where id = prod_id;
    return true;
end;
$$;

alter function product.add_product_quantity(integer, integer, integer) owner to postgres;

