-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


# Method 1
SELECT m.* 
FROM movie m 
JOIN ratings r ON r.movie_id = m.id  -- Join with ratings table
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'  -- Date range filter
AND median_rating = 8;  -- Rating filter

# Method 2

WITH moviesmedian8 AS (
    SELECT m.* 
    FROM movie m 
    JOIN ratings r ON r.movie_id = m.id  -- Join ratings
    WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'  -- Date filter
    AND median_rating = 8  -- Rating filter
)
SELECT * FROM moviesmedian8;  -- Output results from CTE

# Method 3
-- Create stored procedure with parameter for flexible rating search
DELIMITER $$
CREATE PROCEDURE moviesmedian8(IN p_input INT(50))
BEGIN
    -- Query with parameterized rating value
    SELECT m.* 
    FROM movie m 
    JOIN ratings r ON r.movie_id = m.id  -- Join ratings
    WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'  -- Fixed date range
    AND median_rating = p_input;  -- Use input parameter for rating
END; $$
DELIMITER ;

-- Execute procedure to find movies with median rating 8
CALL moviesmedian8(8);