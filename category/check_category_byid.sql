create function category.check_category_byid(cat_id integer) returns boolean
    language plpgsql
as
$$

begin
    return exists(select * from category.category where id = cat_id);
end;
$$;

alter function category.check_category_byid(integer) owner to postgres;

