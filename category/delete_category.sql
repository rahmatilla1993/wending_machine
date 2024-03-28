create function category.delete_category(cat_id integer, userid integer) returns boolean
    language plpgsql
as
$$
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if not exists(select * from category.category where id = cat_id) then
        raise exception 'Category not found "%"', cat_id;
    end if;
    delete from category.category where id = cat_id;
    return true;
end;
$$;

alter function category.delete_category(integer, integer) owner to postgres;

