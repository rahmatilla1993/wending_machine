create function category.edit_category(cat_id integer, cat_name character varying, userid integer) returns boolean
    language plpgsql
as
$$

begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if cat_name is null then
        raise exception 'Category name is null';
    end if;
    if not exists(select * from category.category where id = cat_id) then
        raise exception 'Category not found "%"', cat_id;
    end if;
    if exists(select * from category.category where name = cat_name and id <> cat_id) then
        raise exception 'This category already exists';
    end if;

    update category.category set name = cat_name where id = cat_id;
    return true;
end ;
$$;

alter function category.edit_category(integer, varchar, integer) owner to postgres;

