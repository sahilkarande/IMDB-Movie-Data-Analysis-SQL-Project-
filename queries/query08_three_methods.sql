-- Q8. What is the average duration of movies in each genre?
-- Type your code below:


# Method 1
-- Calculate average movie duration for each genre
SELECT g.genre, AVG(m.duration) AS avg_duration
FROM genre g
-- Join genre table with movie table using movie_id
JOIN movie m ON g.movie_id = m.id
-- Group by genre to calculate separate averages
GROUP BY g.genre;

# Method 2
-- Calculate average movie duration per genre and sort by highest duration
SELECT g.genre, AVG(m.duration) AS avg_duration
FROM genre g
-- Inner join between genre and movie tables based on movie_id
INNER JOIN movie m ON g.movie_id = m.id
-- Group by genre to get one average duration per genre
GROUP BY g.genre
-- Order the results by average duration in descending order (longest movies first)
ORDER BY avg_duration DESC;

# Method 3
-- First step: Create a CTE (temporary result set) with genre and duration
WITH genre_durations AS (
    SELECT g.genre, m.duration
    FROM genre g
    -- Join genre and movie tables based on movie_id
    JOIN movie m ON g.movie_id = m.id
)
-- Second step: Calculate the average duration for each genre from the CTE
SELECT genre, AVG(duration) AS avg_duration
FROM genre_durations
-- Group by genre
GROUP BY genre
-- Order by average duration descending to get genres with longest movies first
ORDER BY avg_duration DESC;