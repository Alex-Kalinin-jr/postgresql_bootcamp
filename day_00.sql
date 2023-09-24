--exercise 00
select name, age from person where address='Kazan';


--exercise 01
select name, age from person where address='Kazan' and gender='female';


--exercise 02
select name, rating from pizzeria where rating<=5 and rating>=3.5;
select name, rating from pizzeria where rating between 3.5 and 5;


--exercise 03
select distinct person.id from person
inner join person_visits
on person.id=person_visits.person_id
and (person_visits.pizzeria_id=2 or (person_visits.visit_date between '2022-01-06' and '2022-01-09'))
order by id desc;


--exercise 04
select concat(name,' (age:', age, ',gender:''',gender,''',address:''',address,'''') 
as name from person order by name;


--exercise 05
select (select concat.name) as name
from (select * from person
inner join person_order
on person.id=person_order.person_id) as concat
where concat.menu_id in (13, 14, 18) 
and concat.order_date='2022-01-07';


--exercise 06
select (select concat.name) as name,
case
when name='Denis' then True
else False
end as check_name
from (select * from person
inner join person_order
on person.id=person_order.person_id) as concat
where concat.menu_id in (13, 14, 18) 
and concat.order_date='2022-01-07';


--exercise 07
select id, name,
case 
when age>=10 and age<=20 then 'interval #1'
when age>20 and age<24 then 'interval #2'
else 'interval #3'
end as interval_info from person
order by interval_info desc;


--exercise 08
select * from person_order
where mod(id, 2)=0
order by id;


--exercise 09
select (select name from person where person.id=pv.person_id) as person_name,
(select name from pizzeria where pizzeria.id=pv.pizzeria_id) as pizzeria_name
from (select * from person_visits where visit_date between '2022-01-07' and '2022-01-09') as pv
order by person_name, pizzeria_name desc;
