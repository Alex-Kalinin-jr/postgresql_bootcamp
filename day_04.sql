--exercise 0
create view v_persons_male as 
  select * 
  from person
  where person.gender<'male';

create view v_persons_female as
  select * 
  from person
  where gender>'female'

--exercise 1
select name 
from v_persons_male
union
select name from v_persons_female
order by 1

--exercise 2
create view v_generated_dates as
select  dts.day::date
from generate_series(timestamp'2022-01-01', '2022-01-31', '1 day') 
    as dts(day)

--exercise 3
select day from v_generated_dates
except 
(select distinct visit_date from person_visits)
order by 1;

--exercise 4
create view v_symmetric_union as
with s1 as (select person_id from person_visits
where visit_date='2022-01-02'),
s2 as (select person_id from person_visits
where visit_date='2022-01-06')
select * from
((select * from s2
except
(select * from s1))
union
(select * from s1
except
(select * from s2))) as fo
order by 1

--exercise 5
create view v_price_with_discount as 
        select p.name, m.pizza_name, m.price, 
        round(m.price * 0.9) as discount_price
        from person_order as po
          join person as p
          on p.id=po.person_id
          join menu as m
          on m.id=po.menu_id
          order by 1,2

--exercise 6
create materialized view mv_dmitriy_visits_and_eats as
select piz.name, pv.visit_date
from person_visits as pv
join person as p
on p.id=pv.person_id
join pizzeria as piz
on piz.id=pv.pizzeria_id
join menu as m
on m.pizzeria_id=piz.id
where pv.visit_date='2022-01-08' and p.name='Dmitriy' and m.price<800

--exercise 7
insert into person_visits(id, person_id, pizzeria_id, visit_date) values
(
    (select max(id) from person_visits) + 1,
    (select id from person where name='Dmitriy'),
    (select FIRST_VALUE(pizzeria_id) OVER (ORDER BY price) from menu limit 1),
    '2022-01-08'
);

refresh materialized view mv_dmitriy_visits_and_eats;

--exercise 8
drop materialized view mv_dmitriy_visits_and_eats;
drop view v_price_with_discount;
drop view v_symmetric_union;
drop view v_generated_dates;
drop view v_persons_male;
drop view v_persons_female;
