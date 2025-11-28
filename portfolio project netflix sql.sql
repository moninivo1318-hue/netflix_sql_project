-- Netflix project 
-- drop table if exists netflix ;
-- create table netflix (
-- show_id	varchar (7),
-- type varchar (100),	
-- title varchar (150), 	
-- director varchar (250),
-- casts varchar (1000),
-- country varchar (150),
-- date_added varchar (50),
-- release_year int , 
-- rating	varchar (50),
-- duration	varchar (50),
-- listed_in	varchar (150),
-- description varchar (350)
-- ); 

select * from netflix ;
-- 15 business pronblems 
-- 1. count the number of movies vs tv shows 

select type ,
count(*) as total_content 
from netflix 
group by type ;

-- 2. find the most common rating for the movies and tv shows 
SELECT type, rating, total_count
FROM (
    SELECT type, rating, COUNT(*) AS total_count,
           ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    WHERE rating IS NOT NULL
    GROUP BY type, rating
) AS t
WHERE rn = 1;

-- 3. list all movies releases in a specific year (example2020)

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;

 -- 4. Find the top 5 countries with the most content on Netflix

SELECT 
    TRIM(UNNEST(string_to_array(country, ','))) AS country_name,
    COUNT(*) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country_name
ORDER BY total_titles DESC
LIMIT 5;

-- 5. Identify the longest movie or TV show duration

SELECT 
    title,
    duration,
    CAST(NULLIF(SPLIT_PART(duration, ' ', 1), '') AS INTEGER) AS duration_value
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL
  AND duration <> ''
  AND duration LIKE '%min%'
ORDER BY duration_value DESC
LIMIT 1;

-- 6. Find content added in the last 5 years
select * 
from  netflix 
where
TO_DATE ( date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years' ;
select current_date - interval '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT 
    title,
    duration,
    CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS seasons
FROM netflix
WHERE type = 'TV Show'
  AND duration ILIKE '%Season%'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5
ORDER BY seasons DESC;


-- 9. Count the number of content items in each genre
SELECT 
    TRIM(UNNEST(string_to_array(listed_in, ','))) AS genre,
    COUNT(*) AS total_count
FROM netflix
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY total_count DESC;

-- 10. Find each year and the average numbers of content release by India on netflix.
WITH yearly AS (
    SELECT 
        release_year,
        COUNT(*) AS total_titles
    FROM netflix
    WHERE country ILIKE '%India%'
    GROUP BY release_year
)
SELECT 
    release_year,
    total_titles,
    (SELECT ROUND(AVG(total_titles), 2) FROM yearly) AS avg_indian_releases_per_year
FROM yearly
ORDER BY release_year;


-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL
   OR director = ''
   OR director = ' ';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
casts ILIKE '%Salman Khan%'
  AND 
  release_year >= EXTRACT (YEAR FROM CURRENT_DATE) - 10 ;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT (*) as total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10 ;

 -- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in
-- the description field. Label content containing these keywords as 'Bad' and all other
-- content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE 
        WHEN description ILIKE '%kill%' 
          OR description ILIKE '%violence%' 
        THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_items
FROM netflix
GROUP BY content_category;








