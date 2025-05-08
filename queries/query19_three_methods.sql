-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)


# Method 1
WITH top_genre AS (
    -- Get top 3 genres with most high-rated movies
    SELECT g.genre, COUNT(*) AS movie_count
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
top_directors AS (
    -- Get top 3 directors in those genres
    SELECT
        n.name AS director_name,
        g.genre,
        COUNT(*) AS movie_count
    FROM ratings r
    JOIN genre g ON r.movie_id = g.movie_id
    JOIN director_mapping d ON r.movie_id = d.movie_id
    JOIN names n ON d.name_id = n.id
    WHERE r.avg_rating > 8 
      AND g.genre IN (SELECT genre FROM top_genre)
    GROUP BY n.name, g.genre
    ORDER BY movie_count DESC
    LIMIT 3
)
SELECT * FROM top_directors;

# Method 2
DELIMITER $$
CREATE PROCEDURE top_directors()
BEGIN
    -- Create temp table of top genres
    CREATE TEMPORARY TABLE top_genres
    SELECT g.genre
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3;

    -- Query directors in those genres
    SELECT 
        n.name AS director_name,
        g.genre,
        COUNT(*) AS movie_count
    FROM ratings r
    JOIN genre g ON r.movie_id = g.movie_id
    JOIN director_mapping d ON r.movie_id = d.movie_id
    JOIN names n ON d.name_id = n.id
    WHERE r.avg_rating > 8 
      AND g.genre IN (SELECT genre FROM top_genres)
    GROUP BY n.name, g.genre
    ORDER BY movie_count DESC
    LIMIT 3;

    DROP TEMPORARY TABLE top_genres;
END $$
DELIMITER ;

CALL top_directors();

# Method 3
SELECT n.name AS director_name, g.genre, COUNT(*) AS movie_count
FROM ratings r
JOIN genre g ON r.movie_id = g.movie_id
JOIN director_mapping d ON r.movie_id = d.movie_id
JOIN names n ON d.name_id = n.id
WHERE r.avg_rating > 8 AND g.genre IN (
    -- Subquery to get top 3 genres
    SELECT top_genres.genre FROM (
        SELECT g.genre 
        FROM genre g
        JOIN ratings r2 ON g.movie_id = r2.movie_id
        WHERE r2.avg_rating > 8
        GROUP BY g.genre
        ORDER BY COUNT(*) DESC
        LIMIT 3
    ) AS top_genres
)
GROUP BY n.name, g.genre
ORDER BY movie_count DESC
LIMIT 3;