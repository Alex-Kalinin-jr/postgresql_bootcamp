--exercise 00
with cte_po as (select m.id as mid, pizzeria_id, pizza_name, price, pz.id as pzid, name as pzname
                from menu as m
                join pizzeria as pz
                on pz.id=m.pizzeria_id)
select pizza_name, price, pzname, pv.visit_date from cte_po
join person_visits as pv
on cte_po.pizzeria_id=pv.pizzeria_id
join person as p
on p.id=pv.person_id
where (cte_po.price >=800 and cte_po.price<=1000) and p.name='Kate'
order by 1,2,3


--exercise 01
select id from menu where id not in (select menu_id from person_order)
order by 1


--exercise 02
select m.pizza_name , m.price, piz.name as pizzeria_name from menu as m
join pizzeria as piz
on piz.id=m.pizzeria_id
where m.id not in (select menu_id from person_order)
order by 1,2


--exercise 03
with cte_all as (select piz.name, person.gender from person_visits as pv
                join person
                on person.id=pv.person_id
                join pizzeria as piz
                on piz.id=pv.pizzeria_id),
cte_m as (select name from cte_all where gender='male'),
cte_w as (select name from cte_all where gender='female')
    (select NAME AS pizzeria_name from cte_w except all (select * from cte_m))
    UNION ALL
    (select NAME AS pizzeria_name from cte_m except all (select * from cte_w))
order by 1


--exercise 04
with cte_all as (select piz.name, person.gender from person_order as po
                join person
                on person.id=po.person_id
                join menu as m
                on m.id=po.menu_id
                join pizzeria as piz
                on piz.id=m.pizzeria_id)
select name as pizzeria_name from cte_all 
except (select distinct name from cte_all where cte_all.gender<>'male')
UNION
select name as pizzeria_name from cte_all
except (select distinct name from cte_all where cte_all.gender<>'female')
order by 1


--exercise 05
with visits as (select piz.name from person_visits as pv
                                      join person as p
                                      on pv.person_id=p.id
                                      join pizzeria as piz
                                      on piz.id=pv.pizzeria_id
                where p.name='Andrey'),
orders as (select piz.name from person_order as po
                                      join person as p
                                      on po.person_id=p.id
                                      join menu as m
                                      on m.id=po.menu_id
                                      join pizzeria as piz
                                      on piz.id=m.pizzeria_id
                where p.name='Andrey')
select distinct name as pizza_name from (
  select * from visits
  except all
  select * from orders
) as aliasee


--exercise 06
with cte_all as (select m.pizza_name, m.price, piz.name as pn from menu as m
    join
    (select name, id from pizzeria) as piz
    on piz.id=m.pizzeria_id)
select distinct fi.pizza_name, fi.pn as pizzeria_name_1, sec.pn as pizzeria_name_2, fi.price 
from cte_all as fi
    join cte_all as sec
    on fi.price=sec.price and fi.pizza_name=sec.pizza_name and fi.pn<sec.pn
order by 1


--exercise 07
insert into menu(id, pizzeria_id, pizza_name, price)
values (19, 2, 'greek pizza', 800)


--exercise 08
insert into menu(id, pizzeria_id, pizza_name, price)
values ((select max(id) from menu) + 1, 
    (select id from pizzeria where name='Dominos'), 'sicilian pizza', 900)


--exercise 09
insert into person_visits(id, person_id, pizzeria_id, visit_date) values
((select max(id) from person_visits) + 1,
  (select id from person where name='Denis'),
  (select id from pizzeria where name='Dominos'),
  '2022-02-24');
insert into person_visits(id, person_id, pizzeria_id, visit_date) values
((select max(id) from person_visits) + 1,
  (select id from person where name='Irina'),
  (select id from pizzeria where name='Dominos'),
  '2022-02-24');


--exercise 10
insert into person_order(id, person_id, menu_id, order_date) values
((select max(id) from person_order) + 1, 
(select id from person where name='Denis'), 
(select id from menu where pizza_name='sicilian pizza'), 
'2022-02-24');

insert into person_order(id, person_id, menu_id, order_date) values
((select max(id) from person_order) + 1, 
(select id from person where name='Irina'), 
(select id from menu where pizza_name='sicilian pizza'), 
'2022-02-24');


--exercise 11
update menu
set price = (select price from menu where pizza_name='greek pizza') * 0.9
where pizza_name='greek pizza';


--exercise 12
insert into person_order
  select (SELECT g.id + (select max(id) from person_order)),
  (g.id),
  (select id from menu where pizza_name='greek pizza'), 
  '2022-02-25'
  FROM generate_series(1, (select count(id) from person)) AS g(id)


--exercise 13
delete from person_order
where order date='2022-02-25';
delete from menu
where pizza_name='greek pizza';



