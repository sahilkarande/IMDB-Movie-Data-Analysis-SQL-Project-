-- Q25. What is the genre-wise running total and moving average of the average movie duration?
-- Type your code below:


# Method 1
SELECT 
    g.genre,                                                   
    AVG(m.duration) AS avg_duration, -- Calculate average duration for each genre
    SUM(AVG(m.duration)) OVER (PARTITION BY g.genre ORDER BY m.id) AS running_total_duration,  -- Running total of average durations by genre
    AVG(m.duration) OVER (PARTITION BY g.genre ORDER BY m.id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration  -- Moving average over last 3 rows
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id -- Join movie table with genre table to get genre information
GROUP BY 
    g.genre, m.id -- Group by genre and movie ID to calculate avg duration for each genre
ORDER BY 
    g.genre, m.id; -- Order by genre and movie ID for proper window function calculation


# Method 2
select 
    g.genre,  -- Select the genre of the movie
    round(avg(m.duration), 2) as avg_duration,  -- Calculate and round the average movie duration for each genre to 2 decimal places
    round(sum(avg(m.duration)) over (order by g.genre), 2) as running_total_duration,  -- Calculate the running total of movie durations across genres, ordered by genre
    round(avg(avg(m.duration)) over (order by g.genre rows between unbounded preceding and current row), 2) as moving_avg_duration  -- Calculate the moving average of movie durations using the last n rows (in this case, all rows up to the current one)
from 
    genre g  -- From the genre table
join 
    movie m on g.movie_id = m.id  -- Join with the movie table on movie_id
group by g.genre;  -- Group the results by genre to get average, running total, and moving average per genre


# Method 3
select 
    genre,  -- Select the genre of the movie
    round(avg_duration, 2) as avg_duration,  -- Round the average movie duration to 2 decimal places
    round(sum(avg_duration) over (order by genre), 2) as running_total_duration,  -- Calculate the running total of movie durations across genres
    round(avg(avg_duration) over (order by genre rows between unbounded preceding and current row), 2) as moving_avg_duration  -- Calculate the moving average of movie durations for each genre
from (
    select 
        g.genre,  -- Select the genre from the genre table
        avg(m.duration) as avg_duration  -- Calculate the average duration of movies within each genre
    from 
        genre g  -- From the genre table
    join 
        movie m on g.movie_id = m.id  -- Join with the movie table on movie_id
    group by 
        g.genre  -- Group by genre to get average movie duration per genre
) as genre_durations;  -- Wrap the previous result set as a derived table to calculate window functions

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.