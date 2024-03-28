create function product.get_all_products() returns text
    language plpgsql
as
$$
begin
    return (select json_agg(json_build_object(
            'category_id', cat_id,
            'category_name', cat_name,
            'products', products
                            ))
            from (select c.id as cat_id,
                         c.name  cat_name,
                         json_agg(
                                 json_build_object(
                                         'id', p.id,
                                         'name', p.name,
                                         'price', p.price,
                                         'quantity', p.quantity
                                 )
                         )       products
                  from product.product p
                           inner join category.category c on c.id = p.category_id
                  group by c.id) as all_products)::text;
end;
$$;

alter function product.get_all_products() owner to postgres;

