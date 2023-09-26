--exercise 00
select person_id, count (person_id) as count_of_visits
from person_visits
group by person_id
order by 2 desc;

--exercise 01
select p.name, cv.count_of_visits from person as p
    join 
    (select person_id, count (person_id) as count_of_visits
    from person_visits
    group by person_id
    order by 2 desc limit 4) as cv
    on p.id = cv.person_id
order by 2 desc, 1;

--exercise 02
with cte_pv as (select piz.name, count(piz.name) 
    from person_visits as pv
        join pizzeria as piz
        on piz.id = pv.pizzeria_id
    group by piz.name
    order by 2 desc limit 3),

cte_po as (select piz.name, count(piz.id)
    from person_order as po
        join menu as m
        on m.id = po.menu_id
        join pizzeria as piz
        on piz.id = m.pizzeria_id
    group by piz.id
    order by 2 desc limit 3)

select *, 'visit' from cte_pv
union all
select *, 'order' from cte_po
order by 3, 2 desc;

--exercise 03
with cte_pv as (select piz.name, count(piz.name) 
from person_visits as pv
    join pizzeria as piz
    on piz.id = pv.pizzeria_id
group by piz.name
order by 2 desc),

cte_po as (select piz.name, count(piz.id)
from person_order as po
    join menu as m
    on m.id = po.menu_id
    join pizzeria as piz
    on piz.id = m.pizzeria_id
group by piz.id
order by 2 desc)

select name, sum(count) as total_count from 
    (select * from cte_pv
    union all
    select * from cte_po) as ttl
group by name
order by 2 desc, 1;

--exercise 04
select name, count_of_visits from
    (select p.name, count(p.name) as count_of_visits 
    from person_visits as pv
        join person as p
        on p.id = pv.person_id
group by p.name) as tbl
where count_of_visits > 3;

--exercise 05
select p.name from person_order as po
    join 
    person as p
    on p.id = po.person_id
group by p.name
order by 1;

--exercise 06
select piz.name, 
count(piz.id) as count_of_orders, 
round(avg(m.price)) as average_price, 
max(m.price) as max_price, 
min(m.price) as min_price
from person_order as po
    join menu as m
    on m.id = po.menu_id
    join pizzeria as piz
    on piz.id = m.pizzeria_id
group by piz.id
order by 1;

--exercise 07
select round(avg(rating), 4) as global_rating
from pizzeria;

--exercise 08
select p.address, piz.name, count(*) as count_of_orders
from person_order as po
    join person as p
    on p.id = po.person_id
    join menu as m
    on m.id = po.menu_id
    join pizzeria as piz
    on piz.id = m.pizzeria_id
group by p.address, piz.name
order by 1,2;

--exercise 09
select address, to_char(formula, 'FM99.99'), to_char(average, 'FM99.99'),
CASE when formula > average then 'true' else 'false' end
from
    (select address,
    round(max(age) - (min(age)::numeric / max(age)::numeric), 2) as formula, 
    avg(age) as average
    from person
    group by address) as buff
order by 1;