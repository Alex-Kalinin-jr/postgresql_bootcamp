--exercise 00
select name from pizzeria
where id not in (select pizzeria_id from person_visits);


--exercise 01
select gs::date as missing_date
from generate_series('2022-01-01'::timestamp, '2022-01-10', '1 day') gs   
    left join
    (select visit_date from person_visits 
    where person_id=1 or person_id=2) as pv
    on pv.visit_date=gs
where visit_date is null
order by 1


--exercise 02
-- it's just for you.


--exercise 03
with l as (select gs::date as missing_date
          from generate_series('2022-01-01'::timestamp, '2022-01-10', '1 day') gs) 
select l.missing_date from l
where l.missing_date not in
    (select visit_date from person_visits 
    where person_id=1 or person_id=2)
order by 1


--exercise 04
with filtred_menu as (select * from menu 
                      where pizza_name='mushroom pizza' or pizza_name='pepperoni pizza')
select  pizza_name, pizzeria_name, price from filtred_menu
    right join 
    (select name as pizzeria_name, id from pizzeria ) as pizz
    on pizz.id=filtred_menu.pizzeria_id
where pizza_name is not null
order by 1,2


--exercise 05
select name from person
where gender='female' and age>25
order by 1


--exercise 06
select m.pizza_name, pz.name as pizzeria_name from person_order as o
    left join menu as m
    on m.id=o.menu_id
    left join person as p
    on p.id=o.person_id
    left join pizzeria as pz
    on m.pizzeria_id=pz.id
where p.name='Denis' or p.name='Anna'
order by 1,2


--exercise 07
select pz.name as pizzeria_name from person_visits as pv
    join
    (select * from person where name='Dmitriy') as p
    on p.id=pv.person_id
    join menu as m
    on m.pizzeria_id=pv.pizzeria_id
    join pizzeria as pz
    on pz.id=pv.pizzeria_id
where pv.visit_date='2022-01-08' and m.price<800


--exercise 08
with nname as (select id, name from person 
              where gender='male' and address in ('Moscow', 'Samara'))
select nname.name from person_order as po
    join nname
    on nname.id=po.person_id
    join menu as m
    on m.id=po.menu_id
where m.pizza_name in ('pepperoni pizza', 'mushroom pizza')
order by 1 desc


--exercise 09
with orders as (select * from person_order as po
                join menu as m
                on m.id=po.menu_id)
select p.name from person as p
    join (select * from orders where orders.pizza_name='pepperoni pizza') as g
    on p.id=g.person_id
    join (select * from orders where orders.pizza_name='cheese pizza') as g2
    on p.id=g2.person_id
where gender='female'


--exercise 10
select n1.name as person_name1, n2.name as person_name2, 
n1.address as common_address from person as n1
    join
    person as n2
    on n1.address=n2.address and n1.name<n2.name
order by 1,2
