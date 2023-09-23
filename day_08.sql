--exercise 00
----session one
begin transaction isolation level read committed;
update pizzeria set rating = 5 where name = 'Pizza Hut';
commit;
select * from pizzeria;

----session two
select * from pizzeria;



--exercise 01
----session one
begin transaction isolation level read committed;
select rating from pizzeria where name = 'Pizza Hut';

----session two
begin transaction isolation level read committed;
select rating from pizzeria where name = 'Pizza Hut';

----session one
update pizzeria set rating = 4 where name = 'Pizza Hut';

----session two
update pizzeria set rating = 3.6 where name = 'Pizza Hut';

----session one
commit;

----session two
commit;

----session one
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';



--exercise 02
----session one
begin transaction isolation level repeatable read;

----session two
begin transaction isolation level repeatable read;

----session one
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';

----session one
update pizzeria set rating = 4 where name = 'Pizza Hut';

----session two
update pizzeria set rating = 3.6 where name = 'Pizza Hut';

----session one
commit;

----session two
commit;

----session one
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';



--exercise 03
----session one
begin transaction isolation level read committed;

----session two
begin transaction isolation level read committed;

----session one
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';
update pizzeria set rating = 3.6 where name = 'Pizza Hut';
commit;

----session one
select rating from pizzeria where name = 'Pizza Hut';
commit;
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';


--exercise 04
----session one
begin transaction isolation level serializable;

----session two
begin transaction isolation level serializable;

----session one
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';
update pizzeria set rating = 3.0 where name = 'Pizza Hut';
commit;

----session one
select rating from pizzeria where name = 'Pizza Hut';
commit;
select rating from pizzeria where name = 'Pizza Hut';

----session two
select rating from pizzeria where name = 'Pizza Hut';


--exercise 05
----session one
begin transaction isolation level read committed;

----session two
begin transaction isolation level read committed;

----session one
select sum(rating) from pizzeria;

----session two
select sum(rating) from pizzeria;
update pizzeria set rating = 1 where name = 'Pizza Hut';
commit;

----session one
select sum(rating) from pizzeria;
commit;
select sum(rating) from pizzeria;

----session two
select sum(rating) from pizzeria;


--exercise 06
----session one
begin transaction isolation level repeatable read;

----session two
begin transaction isolation level repeatable read;

----session one
select sum(rating) from pizzeria;

----session two
select sum(rating) from pizzeria;
update pizzeria set rating = 5 where name = 'Pizza Hut';
commit;

----session one
select sum(rating) from pizzeria;
commit;
select sum(rating) from pizzeria;

----session two
select sum(rating) from pizzeria;


--exercise 07
----session one
begin transaction isolation level read committed;

----session two
begin transaction isolation level read committed;

----session one
update pizzeria set rating = 5 where id = 1;

----session two
update pizzeria set rating = 5 where id = 2;

----session one
update pizzeria set rating = 5 where id = 2;

----session two
update pizzeria set rating = 5 where id = 1;

----session one
commit;

----session two
commit;



