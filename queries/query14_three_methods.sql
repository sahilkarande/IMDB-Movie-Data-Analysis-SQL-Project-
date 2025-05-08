-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
-- Type your code below:


# Method 1
select count(m.id), g.genre  -- Count movies and select genre
from movie m join genre g on g.movie_id=m.id  -- Join movie with genre tables
join ratings r on r.movie_id = m.id  -- Also join with ratings table
where date_published BETWEEN '2017-03-01' AND '2017-03-31'  -- Filter March 2017 releases
and country = "USA"  -- Only US movies
and r.total_votes > 1000  -- Only movies with >1000 votes
group by g.genre;  -- Group results by genre

# Method 2
with moivecount as (  -- Define CTE named moivecount
select count(m.id), g.genre from movie m join genre g on g.movie_id=m.id  -- Same joins as above
join ratings r on r.movie_id = m.id  -- Join ratings
where date_published BETWEEN '2017-03-01' AND '2017-03-31'  -- Same date filter
and country = "USA"  -- Same country filter
and r.total_votes > 1000  -- Same votes filter
group by g.genre  -- Same grouping
) 
select * from moivecount;  -- Select all from the CTE

# Method 3
DELIMITER $$

-- Create stored procedure named 'moviecount' with input parameter
CREATE PROCEDURE moviecount(IN p_input VARCHAR(50))
BEGIN
    -- Query to count movies by genre with specific filters:
    -- 1. Published in March 2017
    -- 2. From specified country (passed as parameter)
    -- 3. With more than 1000 votes
    SELECT 
        COUNT(m.id) AS movie_count,  -- Count of movies meeting criteria
        g.genre                      -- Genre of the movies
    FROM movie m 
    JOIN genre g ON g.movie_id = m.id       -- Join with genre table
    JOIN ratings r ON r.movie_id = m.id     -- Join with ratings table
    WHERE 
        date_published BETWEEN '2017-03-01' AND '2017-03-31'  -- March 2017 releases
        AND country = p_input               -- Filter by input country parameter
        AND r.total_votes > 1000            -- Only movies with >1000 votes
    GROUP BY g.genre;                       -- Group results by genre
END; $$

-- Reset delimiter back to semicolon
DELIMITER ;

-- Execute procedure with 'USA' as input parameter
-- This will return genre-wise movie counts for US movies from March 2017 with >1000 votes
CALL moviecount('USA');