-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)


# Method 1
WITH ActressMovieStats AS (
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,                -- Total votes across all movies
        COUNT(DISTINCT m.id) AS movie_count,              -- Number of distinct movies
        -- Weighted average rating (by vote count)
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating
    FROM 
        role_mapping rm
    JOIN 
        names n ON rm.name_id = n.id                      -- Join to get actress names
    JOIN 
        movie m ON rm.movie_id = m.id                      -- Join to get movie details
    JOIN 
        ratings r ON m.id = r.movie_id                    -- Join to get rating data
    WHERE 
        m.country = 'India'                               -- Only Indian movies
        AND m.languages LIKE '%Hindi%'                    -- Only Hindi language films
        AND rm.category = 'actress'                       -- Only actress roles
    GROUP BY 
        n.name
    HAVING 
        COUNT(DISTINCT m.id) >= 3                         -- Minimum 3 movies requirement
)
-- Main query to rank and display results
SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,  -- Round average to 2 decimals
    -- Rank by rating then votes (with possible gaps)
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM 
    ActressMovieStats
ORDER BY 
    actress_rank                                         -- Order by computed rank
LIMIT 5;                                                -- Return only top 5

# Method 2
WITH ActressMovieStats AS (
    -- Base query to aggregate performance metrics for Indian Hindi film actresses
    SELECT 
        n.name AS actress_name,                      -- Actress name
        SUM(r.total_votes) AS total_votes,           -- Sum of all votes received
        COUNT(DISTINCT m.id) AS movie_count,         -- Count of distinct movies
        -- Calculate weighted average rating (votes-weighted)
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating
    FROM 
        role_mapping rm                              -- Role mapping table
    JOIN 
        names n ON rm.name_id = n.id                 -- Join to get actress names
    JOIN 
        movie m ON rm.movie_id = m.id                -- Join to get movie details
    JOIN 
        ratings r ON m.id = r.movie_id               -- Join to get rating data
    WHERE 
        m.country = 'India'                          -- Filter for Indian movies
        AND m.languages LIKE '%Hindi%'               -- Filter for Hindi language films
        AND rm.category = 'actress'                  -- Filter for actresses only
    GROUP BY 
        n.name                                       -- Group results by actress
    HAVING 
        COUNT(DISTINCT m.id) >= 3                    -- Only include actresses with ≥3 qualifying movies
)
-- Main query to rank and display top actresses
SELECT 
    actress_name,                                    -- Actress name
    total_votes,                                     -- Total votes across all movies
    movie_count,                                     -- Number of qualifying movies
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,  -- Rounded weighted average rating
    -- Rank actresses by rating (primary) and total votes (secondary)
    DENSE_RANK() OVER (
        ORDER BY actress_avg_rating DESC, 
        total_votes DESC
    ) AS actress_rank
FROM 
    ActressMovieStats                                -- Source data from CTE
ORDER BY 
    actress_rank                                     -- Sort by computed rank
LIMIT 5;                                            -- Return top 5 results

# Method 3
SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM (
    -- Subquery with identical calculation logic as the CTE
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating
    FROM 
        role_mapping rm
    JOIN 
        names n ON rm.name_id = n.id
    JOIN 
        movie m ON rm.movie_id = m.id
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        m.country = 'India'
        AND m.languages LIKE '%Hindi%'
        AND rm.category = 'actress'
    GROUP BY 
        n.name
    HAVING 
        COUNT(DISTINCT m.id) >= 3
) AS ActressStats
ORDER BY 
    actress_rank
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

