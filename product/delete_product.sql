create function product.delete_product(prod_id integer, userid integer) returns boolean
    language plpgsql
as
$$
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if not exists(select * from product.product where id = prod_id) then
        raise exception 'Product not found';
    end if;
    delete from product.product where id = prod_id;
    return true;
end;
$$;

alter function product.delete_product(integer, integer) owner to postgres;

