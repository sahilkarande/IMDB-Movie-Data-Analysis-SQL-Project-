-- Q7. How many movies belong to only one genre?
-- Type your code below:


# Method 1
SELECT COUNT(*) AS single_genre_movies
FROM movie 
WHERE id IN (
    -- Subquery: Select movie IDs that have exactly one genre
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1
);

# Method 2
SELECT COUNT(DISTINCT g.movie_id) AS single_genre_movies_count
FROM genre g
LEFT JOIN (
    -- Subquery: Select movie IDs that have more than one genre
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(genre) > 1
) multi_genre ON g.movie_id = multi_genre.movie_id
-- Keep only those movies that did not match (i.e., have only one genre)
WHERE multi_genre.movie_id IS NULL;

# Method 3
WITH genre_counts AS (
    -- Create a temporary table with movie_id and their genre count
    SELECT movie_id, COUNT(genre) AS genre_count
    FROM genre
    GROUP BY movie_id
)
SELECT COUNT(*) AS single_genre
FROM genre_counts
WHERE genre_count = 1;