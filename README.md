# Netflix movies and Tv shows data analysis using sql 

![Netflix_logo](https://github.com/moninivo1318-hue/netflix_sql_project/blob/main/download%20(2).jpeg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
drop table if exists netflix ;
create table netflix (
show_id	varchar (7),
type varchar (100),	
title varchar (150), 	
director varchar (250),
casts varchar (1000),
country varchar (150),
date_added varchar (50),
release_year int , 
rating	varchar (50),
duration	varchar (50),
listed_in	varchar (150),
description varchar (350)
); 
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type ,
count(*) as total_content 
from netflix 
group by type ;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating, total_count
FROM (
    SELECT type, rating, COUNT(*) AS total_count,
           ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    WHERE rating IS NOT NULL
    GROUP BY type, rating
) AS t
WHERE rn = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    TRIM(UNNEST(string_to_array(country, ','))) AS country_name,
    COUNT(*) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country_name
ORDER BY total_titles DESC
LIMIT 5;

```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
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
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select * 
from  netflix 
where
TO_DATE ( date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years' ;
select current_date - interval '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
    title,
    duration,
    CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS seasons
FROM netflix
WHERE type = 'TV Show'
  AND duration ILIKE '%Season%'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5
ORDER BY seasons DESC;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    TRIM(UNNEST(string_to_array(listed_in, ','))) AS genre,
    COUNT(*) AS total_count
FROM netflix
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY total_count DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in ILIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL
   OR director = ''
   OR director = ' ';
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix
WHERE 
casts ILIKE '%Salman Khan%'
  AND 
  release_year >= EXTRACT (YEAR FROM CURRENT_DATE) - 10 ;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT (*) as total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10 ;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

