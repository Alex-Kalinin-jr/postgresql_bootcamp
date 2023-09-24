--exercise 00
select id as object_id, pizza_name as object_name
from menu
union all
select id, name from person
order by object_id, object_name;


--exercise 01
(select name from person order by name)
union all
(select pizza_name as object_name from menu order by pizza_name);


--exercise 02
select pizza_name from menu 
union
select pizza_name from menu
order by pizza_name desc;


--exercise 03
select order_date, person_id from person_order
intersect 
select visit_date, person_id from person_visits
order by order_date, person_id desc;


--exercise 04
select person_id from person_order
where order_date='2022-01-07'
intersect
(select person_id from person_visits
where visit_date='2022-01-07');


--exercise 05
(select * from person
cross join pizzeria)
order by person.id, pizzeria.id;


--exercise 06
select order_date, name from
  ((select order_date, person_id from person_order
  intersect 
  select visit_date, person_id from person_visits) as t1
  inner join
  (select name, id from person) as t2
  on t2.id=t1.person_id)
order by order_date, name desc;


--exercise 07
select order_date, concat(name,' (age:',age,')') as p from person_order
inner join
person as k
on k.id=person_id
order by order_date, p;


--exercise 08
select order_date, concat(name,' (age:',age,')') as person_information from 
  (select order_date, person_id as id from person_order) as t1
natural join
person
order by order_date, person_information;


--exercise 09
select name from pizzeria 
where pizzeria.id not in  
  (select pizzeria_id from person_visits);

select name from pizzeria as t1
where not exists 
(select pizzeria_id from person_visits as t2
  where t2.pizzeria_id=t1.id);


--exercise 10
select p.name as person_name, m.pizza_name, pz.name as pizzeria_name from
person_order as o
  join
    person as p
    on p.id=o.person_id
  join
    menu as m
    on m.id=o.menu_id
  join
    pizzeria as pz
    on m.pizzeria_id=pz.id
order by person_name, pizza_name, pizzeria_name
