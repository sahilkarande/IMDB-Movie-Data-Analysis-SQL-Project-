-- Q11. Which are the top 10 movies based on average rating?
-- Type your code below:

# Method 1
-- Query to get top 10 highest rated movies using DENSE_RANK()
SELECT * FROM(
    -- Subquery joins movies with their ratings and ranks them by average rating
    SELECT 
        m.title,               -- Movie title
        r.avg_rating,         -- Average rating
        DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank  -- Rank movies by rating (allowing ties)
    FROM movie m 
    JOIN ratings r 
    ON r.movie_id = m.id
) ranked_movies
WHERE movie_rank <= 10;  -- Filter to only show top 10 ranked movies

# Method 2
-- Create a stored procedure to encapsulate the top 10 movies query
DELIMITER $$
CREATE PROCEDURE movie_ranking()
BEGIN
    -- Same query as Method 1 but wrapped in a reusable procedure
    SELECT * FROM(
        SELECT 
            m.title, 
            r.avg_rating,
            DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
        FROM movie m 
        JOIN ratings r 
        ON r.movie_id = m.id
    ) ranked_movies
    WHERE movie_rank <= 10;
END; $$
DELIMITER ;

-- Execute the procedure to get results
CALL movie_ranking();
    
# Method 3
-- Create a function that returns a specific movie by its rank position
DELIMITER $$
CREATE FUNCTION mov_rank(m_rnk INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE mov_title TEXT;
    
    -- Query to find a movie by its exact rank position
    -- LIMIT 1 ensures we only get one result if there are ties
    SELECT title INTO mov_title FROM(
        SELECT 
            m.title,
            DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
        FROM movie m 
        JOIN ratings r 
        ON r.movie_id = m.id
    ) ranked_movies
    WHERE movie_rank = m_rnk
    LIMIT 1;
    
    RETURN mov_title;  -- Return the movie title for the requested rank
END; $$
DELIMITER ;

-- Example usage: Get the title of the #1 ranked movie
SELECT mov_rank(1);