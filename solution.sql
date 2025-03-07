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

select distinct type from netflix;

-- 1. Count the number of Movies vs TV Shows
 
 SELECT type,COUNT(type)
 FROM netflix
 GROUP BY type;

-- 2. Find the most common rating for movies and TV shows 
select type, rating
from (
SELECT type,
       rating,
	   count(*),
	   rank() over(partition by type order by  count(*) desc ) as ranking
FROM netflix 
group by 1,2) as t1
where ranking = 1;
-- 3. List all movies released in a specific year (e.g., 2020)
select *  
from netflix
where release_year = 2020 and type = 'Movie';
-- 4. Find the top 5 countries with the most content on Netflix
select 
      unnest(string_to_array(country,',')) as new_country,
      count(show_id) as num_content
from netflix
group by new_country
order by num_content desc
limit 5;
-- 5. Identify the longest movie
select *
from netflix
where type = 'Movie' and duration = (select max(duration) from netflix);
-- 6. Find content added in the last 5 years
select * 
from netflix
where to_date(date_added,'month DD,yyyy')>= current_date - interval '5 years;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka.
select 
      *
      from netflix
where director like '%Rajiv Chilaka%';
-- 8. List all TV shows with more than 5 seasons
select * from netflix
where 
    type = 'TV Show' 
	and 
	split_part(duration,' ',1)::numeric > 5;
-- 9. Count the number of content items in each genre
select 
      unnest(string_to_array(listed_in,',')) as genre,
	  count(show_id) as total_content
from netflix
group by genre
order by total_content desc;
-- 10.Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!
select 
      extract (year from to_date(date_added,'month DD,yyyy' )) as year,
	  count(*),
	  round(count(*)::numeric/ (select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content
from netflix
where country ='India'	
 group by 1
order by year desc;
-- 11. List all movies that are documentaries
select * 
from netflix
where  listed_in ilike '%Documentaries%';
-- 12. Find all content without a director
select *
from netflix
where director is null;
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where casts ilike '%salman Khan%'
      and
	  release_year >= extract(year from current_date) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
      unnest(string_to_array(casts,',')) as actors,
	  count(show_id) as num_movie
from netflix
where type ='Movie' and country ilike '%india%'
group by 1
order by 2 desc
limit 10;
-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select 
       case 
	   when descriptions ilike '%kill%' or descriptions ilike '%violence%' then 'Bad' else 'good'
	   end as lebel,
	   count(show_id)
from netflix
group by 1;



