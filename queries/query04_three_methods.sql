-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Type your code below:

-- # Method 1
SELECT
    SUM(CASE WHEN country LIKE '%USA%' THEN 1 ELSE 0 END) AS produced_in_USA,  -- Count USA movies
    SUM(CASE WHEN country LIKE '%India%' THEN 1 ELSE 0 END) AS produced_in_India,  -- Count India movies
    SUM(CASE WHEN country LIKE '%USA%' OR country LIKE '%India%' THEN 1 ELSE 0 END) AS total_produced_in_USA_or_India  -- Count USA or India movies
FROM
    movie  -- From movies table
WHERE
    year = 2019  -- Only 2019 movies
GROUP BY
    id;  -- WRONG: Grouping by id gives counts per movie (always 0 or 1)

-- # Method 2
select  
    sum(case when country like '%USA%' then 1 else 0 end) as produced_in_USA,  -- Count USA movies
    sum(case when country like '%India%' then 1 else 0 end) as produced_in_India,  -- Count India movies
    COUNT(CASE WHEN country LIKE '%USA%' OR country LIKE '%India%' THEN id END) AS total_produced_in_USA_or_India  -- Count USA or India movies
from movie  -- From movies table
where year = 2019  -- Only 2019 movies
and (country LIKE '%USA%' OR country LIKE '%India%');  -- Only USA/India movies

-- # Method 3
select 
    (select COUNT(*) from movie where year = 2019 and country like '%USA%') as produced_in_USA,  -- Subquery for USA count
    (select COUNT(*) from movie where year = 2019 and country like '%India%') as produced_in_India,  -- Subquery for India count
    (SELECT COUNT(distinct id) FROM movie where year = 2019  -- Subquery for total
    and (country like '%USA%' or country like '%India%')) as total_produced_in_USA_or_India;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/