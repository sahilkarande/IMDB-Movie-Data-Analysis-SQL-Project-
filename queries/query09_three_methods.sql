-- Q9. What is the rank of the �thriller� genre of movies among all the genres in terms of number of movies produced?
-- Type your code below:


## 1. Using CTE and window function rank
use imdb;
select * from genre;
select * from movie;
WITH genre_counts AS 
(SELECT genre, COUNT(*) AS movie_total
    FROM genre
    GROUP BY genre
),
genre_ranks AS 
(SELECT genre, movie_total, RANK() OVER (ORDER BY movie_total DESC) AS genre_rank
    FROM genre_counts
)
SELECT genre, movie_total, genre_rank          
FROM genre_ranks
WHERE genre = 'Thriller';

#2. using subquery
SELECT genre, movie_total, genre_rank
FROM (SELECT genre, COUNT(*) AS movie_total,
RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre
GROUP BY genre
) AS ranked_genres
WHERE genre = 'Thriller';

# 3. Using dense rank
WITH genre_ranked AS (SELECT genre, COUNT(*) AS movie_total,
DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT genre, movie_total, genre_rank
FROM genre_ranked
WHERE genre = 'Thriller';