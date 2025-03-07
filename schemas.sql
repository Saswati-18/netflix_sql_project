CREATE TABLE netflix();
drop table if exists netflix;
create table netflix
(    show_id varchar(5),	
     type	varchar(10),
     title	varchar(150),
     director varchar(208),
     casts	varchar(1000),
     country varchar(150),
     date_added	varchar(50),
     release_year	int,
     rating	varchar(10),
     duration	varchar(15),
     listed_in	varchar(100),
     descriptions varchar(250)
);
select * from netflix;
select count(*) from netflix;