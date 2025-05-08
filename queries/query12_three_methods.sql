-- Q12. Summarise the ratings table based on the movie counts by median ratings.
-- Type your code below:

-- Order by is good to have

select * from ratings;

# Method 1
SELECT 
    median_rating,        -- The median rating value (1-10)
    COUNT(*) AS movie_count  -- Count of movies with each median rating
FROM ratings 
GROUP BY median_rating    -- Group results by each unique median_rating
ORDER BY median_rating ASC;  -- Sort results from lowest to highest rating

# Method 2
WITH mov_counts AS (
    -- This is the same query as Method 1, but defined as a CTE
    SELECT 
        median_rating, 
        COUNT(*) AS movie_count
    FROM ratings 
    GROUP BY median_rating
    ORDER BY median_rating ASC
)

-- Main query that selects from the CTE
-- CTEs can be referenced multiple times in complex queries
SELECT * FROM mov_counts;

# Method 3
DELIMITER $$
CREATE PROCEDURE mov_count()
BEGIN
    -- Same query as Method 1, but now callable as a procedure
    SELECT 
        median_rating, 
        COUNT(*) AS movie_count
    FROM ratings 
    GROUP BY median_rating
    ORDER BY median_rating ASC;
END; $$
DELIMITER ;
-- Execute the stored procedure to get results
-- Procedures can be called with parameters (though this one takes none)
CALL mov_count();

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/
