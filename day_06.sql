--exercise 00
create table person_discounts
(id bigint primary key,
person_id bigint,
pizzeria_id bigint,
discount numeric,
constraint fk_person_discounts_person_id foreign key (person_id) references person(id),
constraint fk_person_discounts_pizzeria_id foreign key (pizzeria_id) references pizzeria(id),
constraint uk_person_discounts unique (person_id, pizzeria_id));

--exercise 01
with cte_init as (
    select person_id, pizzeria_id, count(person_id) as ct from person_order po
    join menu m
    on m.id=po.menu_id
    join pizzeria piz
    on piz.id=m.pizzeria_id
    group by person_id, pizzeria_id
    order by 1)
insert into person_discounts(id, person_id, pizzeria_id, discount)
select ROW_NUMBER() over (order by person_id), 
person_id, 
pizzeria_id,
CASE when ct = 1 then 10.5 when ct = 2 then 22 else 30 end
from cte_init;

--exercise 02
select p.name, m.pizza_name, m.price, 
round (m.price * (100 - pd.discount) / 100) as discount_price, 
piz.name from person_order as po
    join person as p
    on p.id = po.person_id
    join menu as m
    on m.id = po.menu_id
    join pizzeria as piz
    on piz.id = m.pizzeria_id
    join person_discounts as pd
    on p.id = pd.person_id and piz.id = pd.pizzeria_id
order by 1,2;

--exercise 03
create unique index if not exists idx_person_discounts_unique 
on person_discounts(person_id, pizzeria_id);

set enable_seqscan = off;
explain analyze
select person_id, pizzeria_id from person_discounts
where pizzeria_id = 3 and (person_id < 10);

--exercise 04
alter table person_discounts add constraint ch_nn_person_id 
check (person_id is not null);

alter table person_discounts add constraint ch_nn_pizzeria_id 
check (pizzeria_id is not null);

alter table person_discounts add constraint ch_nn_discount 
check (discount is not null);

alter table person_discounts alter column discount set default 0;

alter table person_discounts add constraint ch_range_discount check (discount between 0 and 100);

--exercise 05
comment on table person_discounts is 'Table for storing discount values for users in pizzerias';
comment on column person_discounts.person_id is 'Column with respective visitor ids';
comment on column person_discounts.pizzeria_id is 'Column with respective pizzeria ids';
comment on column person_discounts.discount is 'Column with respective discount (%) for appropriate person/visitor entity';

--exercise 06
create sequence if not exists seq_person_discounts
owned by person_discounts.id;

SELECT setval('seq_person_discounts', max(id) + 1) FROM person_discounts;



