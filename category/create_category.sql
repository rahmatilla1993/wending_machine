create function category.create_category(cat_name character varying, userid integer) returns integer
    language plpgsql
as
$$
declare
    rowID  int;
begin
    call auth.isactive(userid);
    call auth.check_admin_permission(userid);
    if cat_name is null then
        raise exception 'Category name is null';
    end if;
    insert into category.category(name) values (cat_name) returning id into rowID;
    return rowID;
exception
    when unique_violation then
        raise exception 'This category already exists';
end;
$$;

alter function category.create_category(varchar, integer) owner to postgres;

