--exercise 00
begin;
create table if not exists person_audit
( created timestamp with time zone default current_timestamp not null,
  type_event char(1),
  row_id bigint primary key not null,
  name varchar,
  age integer,
  gender varchar,
  address varchar,
  constraint ch_type_event check (type_event in ('I', 'U', 'D'))
  );
end;

begin;
  create function fnc_trg_person_insert_audit()
  returns trigger
  as $$
  begin
    insert into person_audit(type_event, row_id, name, age, gender, address) values
    ('I', (select count(*) from person_audit) + 1, 
    new.name, new.age, new.gender, new.address);
    return null;
  end;
  $$ language plpgsql;
end;

begin;
  create trigger trg_person_insert_audit
  after insert
  on person
  for each row
  execute procedure fnc_trg_person_insert_audit();
end;

begin;
  INSERT INTO person(id, name, age, gender, address) 
  VALUES (10, 'Damir', 22, 'male', 'Irkutsk');
commit;



--exercise 01
begin;
  create function fnc_trg_person_update_audit()
  returns trigger
  as $$
  begin
    insert into person_audit(type_event, row_id, name, age, gender, address) values
    ('U', (select count(*) from person_audit) + 1, 
    new.name, new.age, new.gender, new.address);
    return null;
  end;
  $$ language plpgsql;
end;

begin;
  create trigger trg_person_update_audit
  after update
  on person
  for each row
  execute procedure fnc_trg_person_update_audit();
end;

begin;
    UPDATE person SET name = 'Bulat' WHERE id = 10;
    UPDATE person SET name = 'Damir' WHERE id = 10;
commit;



--exercise 02
begin;
  create function fnc_trg_person_delete_audit()
  returns trigger
  as $$
  begin
    insert into person_audit(type_event, row_id, name, age, gender, address) values
    ('D', (select count(*) from person_audit) + 1, 
    old.name, old.age, old.gender, old.address);
    return null;
  end;
  $$ language plpgsql;
end;

begin;
  create trigger trg_person_delete_audit
  after delete
  on person
  for each row
  execute procedure fnc_trg_person_delete_audit();
end;

begin;
    DELETE FROM person WHERE id = 10;
commit;



--exercise 03
begin;
    drop trigger trg_person_insert_audit on person;
    drop trigger trg_person_update_audit on person;
    drop trigger trg_person_delete_audit on person;

    drop function fnc_trg_person_insert_audit();
    drop function fnc_trg_person_update_audit();
    drop function fnc_trg_person_delete_audit();

    delete from person_audit;
end;

begin;
  create function fnc_trg_person_audit()
  returns trigger
  as $$
  begin
    if (tg_op = 'INSERT') then
      insert into person_audit(type_event, row_id, name, age, gender, address)
      values ('I', (select count(*) from person_audit) + 1, 
      new.name, new.age, new.gender, new.address);
    elsif (tg_op = 'UPDATE') then
      insert into person_audit(type_event, row_id, name, age, gender, address)
      values ('U', (select count(*) from person_audit) + 1, 
      new.name, new.age, new.gender, new.address);
    elsif (tg_op = 'DELETE') then
      insert into person_audit(type_event, row_id, name, age, gender, address)
      values ('D', (select count(*) from person_audit) + 1, 
      old.name, old.age, old.gender, old.address);
    end if;
    return null;
  end;
  $$ language plpgsql;
end;

begin;
  create trigger trg_person_audit
  after insert or update or delete
  on person
  for each row
  execute procedure fnc_trg_person_audit();
end;

begin;
    INSERT INTO person(id, name, age, gender, address)
    VALUES (10,'Damir', 22, 'male', 'Irkutsk');
    UPDATE person SET name = 'Bulat' WHERE id = 10;
    UPDATE person SET name = 'Damir' WHERE id = 10;
    DELETE FROM person WHERE id = 10;
commit;



--exercise 04
begin;
create or replace function fnc_persons_female()
returns table (id bigint, 
                name varchar, 
                age integer, 
                gender varchar, 
                address varchar)
as $$
    select * from person where gender = 'female';
$$ language sql;
commit;

begin;
create or replace function fnc_persons_male()
returns table (id bigint, 
                name varchar, 
                age integer, 
                gender varchar, 
                address varchar)
as $$
    select * from person where gender = 'male';
$$ language sql;
commit;



--exercise 05
drop function fnc_persons_female;
drop function fnc_persons_male;

begin;
create or replace function fnc_persons(
    pgender varchar default 'female'
)
returns table (id bigint, 
                name varchar, 
                age integer, 
                gender varchar, 
                address varchar)
as $$
    select * from person where gender = pgender;
$$ language sql;
commit;



--exercise 06
begin;
create or replace function fnc_person_visits_and_eats_on_date(
    pperson varchar default 'Dmitriy',
    pprice integer default 500,
    pdate date default '2022-01-08'
)
returns table (pizza_name varchar)
as $$
begin
    return query
        select piz.name from person_visits as pv
            join pizzeria as piz on pv.pizzeria_id = piz.id
            join menu as m on m.pizzeria_id = piz.id
            join person as p on p.id = pv.person_id
        where m.price < pprice 
            and p.name = pperson 
            and pdate = pv.visit_date;
end;
$$ language plpgsql;
commit;



--exercise 07
begin;
    create function func_minimum(variadic arr numeric[])
    returns numeric as $$
    SELECT min($1[i]) FROM generate_subscripts($1, 1) g(i);
    $$ LANGUAGE SQL;
commit;



--exercise 08
create function fnc_fibonacci(pcount int default 10)
returns table(number numeric) as $$
begin
    return query
    WITH RECURSIVE cte_rec AS (
        SELECT 
            0::numeric AS fibo, 
            1::numeric AS fibo_last,
            1 as counter
        UNION 
        SELECT 
            fibo + fibo_last AS fibo, 
            fibo as fibo_last,
            counter + 1 as counter
        FROM cte_rec
        WHERE counter < pcount
    )
    SELECT fibo FROM cte_rec;
end;
$$ language plpgsql;
