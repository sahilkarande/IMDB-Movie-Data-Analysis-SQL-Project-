-- Q20. Who are the top two actors whose movies have a median rating >= 8?
-- Type your code below:


# Method 1
SELECT 
    n.name,                      -- Actor/actress name
    COUNT(r.movie_id) AS movie_count  -- Count of movies they've appeared in
FROM names n                     -- Names table (actors/actresses)
JOIN role_mapping rm ON n.id = rm.name_id  -- Join to role mapping
JOIN ratings r ON rm.movie_id = r.movie_id  -- Join to ratings
GROUP BY n.name                  -- Group results by actor name
HAVING AVG(r.avg_rating) >= 8    -- Filter for actors with average movie rating >= 8
ORDER BY movie_count DESC        -- Sort by movie count (highest first)
LIMIT 2;                        -- Return only top 2 results

# Method 2
SELECT 
    actor_name,                  -- Actor/actress name
    movie_count                  -- Count of qualifying movies
FROM (
    -- Subquery calculates metrics for each actor
    SELECT 
        n.name AS actor_name,    -- Actor name
        COUNT(r.movie_id) AS movie_count,  -- Movie count
        AVG(r.avg_rating) AS avg_rating  -- Average rating across their movies
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN ratings r ON rm.movie_id = r.movie_id
    GROUP BY n.name              -- Group by actor
) AS actor_stats                -- Name the subquery result set
WHERE avg_rating >= 8           -- Filter for high average ratings
ORDER BY movie_count DESC       -- Sort by movie count
LIMIT 2;                       -- Return top 2

# Method 3
DELIMITER $$
CREATE PROCEDURE top_actors()
BEGIN
    -- Same logic as Method 1 but encapsulated in a procedure
    SELECT 
        n.name AS actor_name,    -- Actor name
        COUNT(r.movie_id) AS movie_count  -- Movie count
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN ratings r ON rm.movie_id = r.movie_id
    GROUP BY n.name
    HAVING AVG(r.avg_rating) >= 8  -- High average rating filter
    ORDER BY movie_count DESC     -- Sort by productivity
    LIMIT 2;                     -- Return top 2
END $$
DELIMITER ;

-- Execute the procedure to get results
CALL top_actors();

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/