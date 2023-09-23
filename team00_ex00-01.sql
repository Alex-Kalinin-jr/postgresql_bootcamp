create table data_table(
    point_one varchar(4),
    point_two varchar(4),
    weight int
);

insert into data_table (point_one, point_two, weight)
values
('A', 'B', 7),
('B', 'A', 7),

('A', 'C', 5),
('C', 'A', 5),

('A', 'D', 4),
('D', 'A', 4),

('C', 'B', 2),
('B', 'C', 2),

('B', 'D', 3),
('D', 'B', 3),

('C', 'D', 8),
('D', 'C', 8);


--exercise 00
with recursive path_table(tour, 
                        last_point, 
                        total_cost, count) as (
    select concat(dt.point_one,',', dt.point_two), 
            dt.point_two, 
            dt.weight,
            1
    from data_table as dt
    where dt.point_one='A'
    union all
    select concat(pt.tour, ',', dt.point_two), 
            dt.point_two, 
            pt.total_cost + dt.weight,
            pt.count+1
    from 
        path_table as pt, data_table as dt
    where dt.point_one=pt.last_point and
        ((position(dt.point_two in pt.tour)=0 and pt.count<3) or
        (position(dt.point_two in pt.tour)=1  and dt.point_one=pt.last_point) and pt.count=3)),
full_table as (
    select pt.tour, pt.total_cost from path_table as pt
    where pt.count=4
)
select total_cost, concat('{',tour,'}') from full_table as ft
join (select min(total_cost) as m from full_table) as ft2
on ft2.m=ft.total_cost;



--exercise 01
select total_cost, concat('{',tour,'}') from full_table
order by 1,2;


