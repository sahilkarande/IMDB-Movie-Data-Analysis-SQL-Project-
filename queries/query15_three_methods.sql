-- Q15. Find movies of each genre that start with the word �The� and which have an average rating > 8?
-- Type your code below:


# Method 1
SELECT 
    COUNT(m.id) AS movie_count,  -- Count of movies meeting criteria
    g.genre                      -- Movie genre
FROM 
    movie m                      -- From movie table (aliased as 'm')
JOIN 
    genre g ON g.movie_id = m.id  -- Join with genre table (aliased as 'g')
JOIN 
    ratings r ON m.id = r.movie_id  -- Join with ratings table (aliased as 'r')
WHERE 
    r.avg_rating > 8             -- Filter for movies with average rating > 8
    AND m.title LIKE 'The%'      -- Filter for movies where title starts with 'The'
GROUP BY 
    g.genre;                     -- Group results by genre

# Method 2
WITH MovieCounts AS (
    -- Base query that counts high-rated movies starting with 'The' by genre
    SELECT 
        COUNT(m.id) AS movie_count,  -- Count of qualifying movies
        g.genre                      -- Genre classification
    FROM 
        movie m                      -- Primary movie table
    JOIN 
        genre g ON g.movie_id = m.id  -- Join to get genre information
    JOIN 
        ratings r ON m.id = r.movie_id  -- Join to access rating data
    WHERE 
        r.avg_rating > 8             -- Filter for excellent ratings (>8)
        AND m.title LIKE 'The%'      -- Filter for titles starting with 'The'
    GROUP BY 
        g.genre                      -- Aggregate counts by genre
)
-- Main query that selects from the CTE
-- CTEs can be referenced multiple times in more complex queries
SELECT * FROM MovieCounts;
# Method 3
DELIMITER $$
-- Create stored procedure named 'GetHighRatedTheMovies'
-- Takes one input parameter: genre_filter (string up to 50 chars)
CREATE PROCEDURE GetHighRatedTheMovies(IN genre_filter VARCHAR(50))
BEGIN
    -- Query to retrieve detailed information about high-rated movies:
    -- 1. With average rating > 8
    -- 2. Titles starting with 'The'
    -- 3. Filtered by specified genre
    SELECT 
        m.id,            -- Movie database ID
        m.title,         -- Movie title
        g.genre,         -- Movie genre (filtered by input parameter)
        r.avg_rating     -- Average rating from ratings table
    FROM 
        movie m          -- Primary movie table (aliased as 'm')
    JOIN 
        genre g ON g.movie_id = m.id  -- Join with genre table
    JOIN 
        ratings r ON m.id = r.movie_id  -- Join with ratings table
    WHERE 
        r.avg_rating > 8             -- Only include highly rated movies (>8)
        AND m.title LIKE 'The%'      -- Only titles starting with 'The'
        AND g.genre = genre_filter;   -- Filter by specified genre parameter
END$$

-- Reset delimiter back to semicolon
DELIMITER ;


-- Execute procedure for Drama genre
CALL GetHighRatedTheMovies('Drama');
