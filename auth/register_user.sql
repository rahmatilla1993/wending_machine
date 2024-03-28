create function auth.register_user(data_params text) returns integer
    language plpgsql
as
$$
declare
    dto       auth.auth_register_dto;
    data_json json;
    rowID     int;
    error_dto utils.error_dto;
begin
    if data_params is null then
        raise exception 'Params is empty';
    end if;
    data_json = data_params::json;
    dto.first_name = data_json ->> 'firstname';
    dto.last_name = data_json ->> 'lastname';
    dto.email = data_json ->> 'email';
    dto.password = data_json ->> 'password';

    if exists(select * from auth.auth_user where email ilike dto.email) then
        raise exception 'This email already taken';
    end if;
    insert into auth.auth_user (first_name, last_name, email, password)
    values (dto.first_name,
            dto.last_name,
            dto.email,
            auth.encode_password(dto.password))
    returning id into rowID;
    return rowID;
exception
    when check_violation then
        raise exception using
            message = 'Did not match email pattern',
            errcode = '23514';
    when not_null_violation then
        get stacked diagnostics
            error_dto.code = returned_sqlstate,
            error_dto.column_name = column_name;
        raise exception using
            message = concat(error_dto.column_name, ' must be not empty'),
--             message = concat(regexp_substr(e_message, '[^"]+', 1, 2), ' ', 'must be not empty'),
            errcode = error_dto.code;
end;
$$;

alter function auth.register_user(text) owner to postgres;

