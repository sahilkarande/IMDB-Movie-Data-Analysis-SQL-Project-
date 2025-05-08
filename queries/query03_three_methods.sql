-- Q3. Find the total number of movies released each year? How does the trend look month-wise?

-- Type your code below:

-- # Method 1
-- Movie count by release year
SELECT YEAR(date_published) AS year_of, 
       COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY year_of;

-- Movie count by release month (ordered 1-12)
SELECT MONTH(date_published) AS month_of, 
       COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY month_of 
ORDER BY month_of;

-- # Method 2
-- Monthly movie count using subquery
DELIMITER $$
CREATE PROCEDURE get_movie_count()
BEGIN
    -- Count movies by year
    SELECT YEAR(date_published) AS year_of, COUNT(id) AS number_of_movies 
    FROM movie 
    GROUP BY year_of;
    
    -- Count movies by month
    SELECT MONTH(date_published) AS month_of, COUNT(id) AS number_of_movies 
    FROM movie 
    GROUP BY month_of 
    ORDER BY month_of;
END$$
DELIMITER ;

-- Execute procedure
CALL get_movie_count();

-- # Method 3
-- Monthly movie counts by year and month
select 
    year,
    month(date_published) as released_month,
    count(*) over(partition by year, month(date_published)) as monthly_movie_count 
from movie 
order by year, released_month;

-- Yearly movie counts
select distinct 
    year,
    count(*) over(partition by year) as yearly_movie_count 
from movie 
order by year;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  

