--exercise 00
create index IF NOT EXISTS idx_menu_pizzeria_id 
on menu (pizzeria_id) with (deduplicate_items = on);
create index IF NOT EXISTS idx_person_order_person_id 
on person_order (person_id) with (deduplicate_items = on);
create index IF NOT EXISTS idx_person_order_menu_id 
on person_order (menu_id) with (deduplicate_items = on);
create index IF NOT EXISTS idx_person_visits_person_id 
on person_visits (person_id) with (deduplicate_items = on);
create index IF NOT EXISTS idx_person_visits_pizzeria_id 
on person_visits (pizzeria_id) with (deduplicate_items = on);

--exercise 01
set enable_seqscan = off;
explain analyze
select m.pizza_name, piz.name from menu as m
join pizzeria as piz
on m.pizzeria_id=piz.id

--exercise 02
create index if not exists idx_person_name 
on person (upper(name));

set enable_seqscan = off;
EXPLAIN ANALYZE
select *
from person as p
where upper(p.name) like 'DENIS';

--exercise 03
create index if not exists idx_person_order_multi 
on person_order(person_id, menu_id);

set enable_seqscan = off;
explain analyze
SELECT person_id, menu_id,order_date
FROM person_order
WHERE person_id = 8 AND menu_id = 19;

--exercise 04
create index if not exists idx_menu_unique 
    on menu(pizzeria_id, pizza_name) with (deduplicate_items = on);

set enable_seqscan = off;
explain analyze
select * from menu
where pizza_name = 'cheese pizza' and pizzeria_id < 15;

--exercise 05
create unique index if not exists idx_person_order_order_date
on person_order(person_id, menu_id)
where person_order.order_date='2022-01-01';

set enable_seqscan = off;
explain analyze
select person_id, menu_id from person_order
where order_date='2022-01-01';

--exercise 06
drop index if exists idx_1;

create index idx_1
on pizzeria(rating);

set enable_seqscan = off;
explain analyze
SELECT
m.pizza_name AS pizza_name, 
max(rating) OVER (PARTITION BY rating ORDER BY rating 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
    FROM  menu m
    INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
    ORDER BY 1,2;

