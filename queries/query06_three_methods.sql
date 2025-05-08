-- Q6. Which genre had the highest number of movies produced overall?
-- Type your code below:



# Method 1
-- selects the genre and counts how many movies are associated with each genre
SELECT genre, COUNT(m.id) AS movie_count
FROM movie m
-- joins the movie table with the genre table using the movie ID
JOIN genre g ON m.id = g.movie_id
-- groups the result by genre so we can count the number of movies per genre
GROUP BY genre
-- sorts the results by the number of movies in descending order
ORDER BY movie_count DESC
-- limits the result to only the top genre (with the highest count)
LIMIT 1;


# Method 2
-- creates a common table expression (CTE) to calculate movie counts per genre
WITH GenreMovieCounts AS (
    SELECT genre, COUNT(m.id) AS movie_count
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    GROUP BY genre
)
-- selects the genre with the highest movie count from the CTE
SELECT genre, movie_count
FROM GenreMovieCounts
ORDER BY movie_count DESC
LIMIT 1;


# Method 3
-- selects the top genre from a subquery that calculates movie counts per genre
SELECT genre, movie_count
FROM (
    SELECT genre, COUNT(m.id) AS movie_count
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    GROUP BY genre
) AS GenreMovieCounts
ORDER BY movie_count DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/