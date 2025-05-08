-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


# Methode 1
SELECT DISTINCT genre  -- first select the column that you want find unique things we used function distnict keyword and not repeated genres 
FROM genre; -- and then from which table mention table name it will give the unique things

-- # Methode 2
SELECT genre -- select the genre column from the genre table
FROM genre -- group rows by genre so that each genre appears only once
GROUP BY genre;

-- # Method 3
-- create a temporary table called "ranked_genres"
-- in this step, we are giving a number to each genre (like 1st, 2nd, 3rd...) 
-- based on the order of movie_id for that genre

WITH genre_check AS(
SELECT genre , RANK() OVER(PARTITION BY genre ORDER BY movie_id) AS rank_id
FROM genre
)
-- select only the rows where the rank is 1
-- this gives one row for each genre (the first one based on movie_id)
SELECT genre FROM genre_check WHERE rank_id=1;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

