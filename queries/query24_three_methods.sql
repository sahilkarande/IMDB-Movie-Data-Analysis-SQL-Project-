/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT 
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category,
    COUNT(*) AS movie_count
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    g.genre = 'Thriller'
GROUP BY 
    movie_category
ORDER BY 
    movie_count DESC;

# Method 2
SELECT 
    -- Use a CASE statement to categorize movies based on their average rating
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit'                  -- Category for movies with avg rating > 8
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'           -- Category for movies with avg rating between 7 and 8
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch' -- Category for movies with avg rating between 5 and 7
        ELSE 'Flop'                                           -- Category for movies with avg rating < 5
    END AS movie_category,                                   -- The result of the CASE statement will be shown as movie_category
    COUNT(*) AS movie_count                                  -- Count the number of movies in each category
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id                            -- Join the 'movie' table with 'genre' table on movie_id to get genre information
JOIN 
    ratings r ON m.id = r.movie_id                          -- Join the 'ratings' table with 'movie' table on movie_id to get movie ratings
WHERE 
    g.genre = 'Thriller'                                    -- Filter only movies that belong to the 'Thriller' genre
GROUP BY 
    movie_category                                          -- Group the results by movie_category (calculated in the CASE statement)
ORDER BY 
    movie_count DESC;                                       -- Order the results by the movie_count in descending order (most popular category first);

# Method 3 
SELECT 
    movie_category,            -- Select the movie category from the subquery
    COUNT(*) AS movie_count    -- Count the number of movies in each category
FROM 
    (SELECT 
        -- Calculate movie category using CASE statement based on the avg_rating
        CASE 
            WHEN r.avg_rating > 8 THEN 'Superhit'
            WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
            WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
            ELSE 'Flop'
        END AS movie_category
     FROM 
        movie m
     JOIN 
        genre g ON m.id = g.movie_id
     JOIN 
        ratings r ON m.id = r.movie_id
     WHERE 
        g.genre = 'Thriller') AS categorized_movies  -- Subquery result is aliased as 'categorized_movies'
GROUP BY 
    movie_category  -- Group the result by movie category
ORDER BY 
    movie_count DESC;  -- Order the result by movie count in descending order

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/
