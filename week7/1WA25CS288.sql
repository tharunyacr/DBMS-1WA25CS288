create table supplier
(
sid int primary key ,
sname varchar(50),
address varchar(50)
);
desc supplier;
create table part
(
pid int primary key,
pname varchar(50),
color varchar(20)
);
create table catalog
(
sid int ,
pid int,
cost decimal(10,2) check(cost>=0),
foreign key (sid) references supplier(sid),
foreign key (pid) references part (pid)
);

insert into supplier values
(1, "acme_widget_supplier", "banglore"),
(2,"abc_supplier","mysore"),
(3,"xyz_supplier", "chennai"),
(4,"global_supplier","banglore"),
(5,"star_supplier","chitradurga");

insert into part values
( 101,"bolt","red"),
(102,"nut","blue"),
(103,"screw","red"),
(104,"washer","green"),
(105,"gear","red");

insert into catalog values
(1,101,100),
(1,102,200),
(1,103,150),
(1,104,250),

(2,101,120),
(2,102,180),
(2,103,170),
(2,104,220),
(2,105,300),

(3,101,90),
(3,103,160),
(3,105,280),

(4,101,130),
(4,102,210),
(4,103,140),
(4,104,260),
(4,105,230),

(5,102,190),
(5,104,230);

select distinct p.pname
from part p,catalog c
where p.pid =c.pid;

select s.sname
from supplier s
where not exists (
select *
from part p
where not exists (
select *
from catalog c
where c.sid = s.sid
and c.pid=p.pid
)
);

select pname
from part
where pid IN (
SELECT pid
from catalog
where sid in
(
select sid from supplier
where sname ="acme_wedge_supplier"
)
)
and pid not in (
select pid
from catalog
where sid not in (
select sid from supplier
where sname = "acme_wedge_supplier"
)
);

select distinct c1.sid
from catalog c1
where c1.cost>(
select avg(c2.cost)
from catalog c2
where c2.pid = c1.pid
);

select s.sname
from supplier s,catalog c
where s.sid =c.sid
and (c.pid,c.cost) in (
select pid ,max(cost)
from catalog
group by pid
