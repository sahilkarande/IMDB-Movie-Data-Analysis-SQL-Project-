-- Q10. Find the minimum and maximum values in each column of the ratings table except the movie_id column?
-- Type your code below:

-- Type your code below:

SELECT * FROM ratings;

# Method 1
SELECT 
    MAX(avg_rating) AS max_avg_rating,        -- Finds highest average rating in the table
    MIN(avg_rating) AS min_avg_rating,        -- Finds lowest average rating in the table
    MAX(total_votes) AS max_total_votes,      -- Finds maximum number of total votes
    MIN(total_votes) AS min_total_votes,      -- Finds minimum number of total votes
    MAX(median_rating) AS max_median_rating,  -- Finds highest median rating
    MIN(median_rating) AS min_median_rating   -- Finds lowest median rating
FROM ratings;
  
# Method 2
  -- First query gets min and max average ratings
SELECT MAX(avg_rating) AS max_avg_rating, MIN(avg_rating) AS min_avg_rating FROM ratings
UNION ALL
-- Second query gets min and max total votes
SELECT MAX(total_votes) AS max_total_votes, MIN(total_votes) AS min_total_votes FROM ratings
UNION ALL
-- Third query gets min and max median ratings
SELECT MAX(median_rating) AS max_median_rating, MIN(median_rating) AS min_median_rating
FROM ratings;

# Method 3
-- Uses CROSS JOIN to combine results from three subqueries
SELECT * FROM (
    -- Subquery for average rating metrics
    SELECT MIN(avg_rating) AS min_avg_rating,
           MAX(avg_rating) AS max_avg_rating
    FROM ratings
) AS r1
CROSS JOIN (
    -- Subquery for total votes metrics
    SELECT MIN(total_votes) AS min_total_votes,
           MAX(total_votes) AS max_total_votes
    FROM ratings
) AS r2
CROSS JOIN (
    -- Subquery for median rating metrics
    SELECT MIN(median_rating) AS min_median_rating,
           MAX(median_rating) AS max_median_rating
    FROM ratings
) AS r3;
select * from ratings;
select * from movie;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/