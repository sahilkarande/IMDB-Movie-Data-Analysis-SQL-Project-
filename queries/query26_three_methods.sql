-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
-- Type your code below:


-- Top 3 Genres based on most number of movies
# Method 1
WITH top_genres AS (
    -- CTE to identify the top 3 genres based on movie count
    select 
        genre                               -- Genre name
    from 
        genre
    group by 
        genre                               -- Group by genre to get count of movies per genre
    order by 
        count(movie_id) desc                -- Order genres by movie count in descending order
    limit 3                                  -- Limit to top 3 genres
),
movies_with_income AS (
    -- CTE to clean the worldwide gross income and filter movies in top genres
    select 
        m.id,                               -- Movie ID
        m.title,                            -- Movie title
        m.year,                             -- Movie release year
        g.genre,                            -- Genre of the movie
        cast(replace(replace(m.worlwide_gross_income, '$', ''), ',', '') as unsigned) as income  -- Cleaned worldwide gross income
    from 
        movie m
    join 
        genre g on m.id = g.movie_id       -- Join movie with genre table
    where 
        g.genre in (select genre from top_genres) -- Filter movies from top genres
        and m.worlwide_gross_income is not null -- Exclude movies with null worldwide income
),
ranked_movies AS (
    -- CTE to rank movies within each genre and year based on income
    select 
        genre, 
        year,
        title as movie_name,                -- Movie title
        income,                             -- Worldwide gross income
        dense_rank() over (partition by genre, year order by income desc) as movie_rank  -- Rank movies by income within genre and year
    from 
        movies_with_income
)
-- Final selection of the top 5 movies for each genre and year
select 
    genre, 
    year, 
    movie_name, 
    concat('$', format(income, 0)) as worldwide_gross_income,  -- Format income with a dollar sign
    movie_rank 
from 
    ranked_movies
where 
    movie_rank <= 5;  -- Select the top 5 movies based on income

# Method 2
WITH top_genres AS (
    -- CTE to identify the top 3 genres based on movie count
    select 
        genre                               -- Genre name
    from 
        genre
    group by 
        genre                               -- Group by genre to get count of movies per genre
    order by 
        count(movie_id) desc                -- Order genres by movie count in descending order
    limit 3                                  -- Limit to top 3 genres
)
select 
    final.genre,                           -- Genre of the movie
    final.year,                            -- Year of the movie
    final.movie_name,                      -- Movie title
    concat('$', format(final.income, 0)) as worldwide_gross_income,  -- Format income with a dollar sign
    final.movie_rank                       -- Rank of the movie within its genre and year
from (
    -- Subquery to select movies from top genres and clean their worldwide gross income
    select 
        g.genre,                           -- Genre of the movie
        m.year,                            -- Year of the movie
        m.title as movie_name,             -- Movie title
        cast(replace(replace(m.worlwide_gross_income, '$', ''), ',', '') as unsigned) as income,  -- Cleaned worldwide income
        dense_rank() over (partition by g.genre, m.year order by cast(replace(replace(m.worlwide_gross_income, '$', ''), ',', '') as unsigned) desc) as movie_rank  -- Rank by income
    from 
        genre g
    join 
        movie m on g.movie_id = m.id      -- Join genre with movie table
    where 
        g.genre in (select genre from top_genres)  -- Filter movies in the top genres
        and m.worlwide_gross_income is not null -- Exclude movies with null worldwide income
) as final
where 
    final.movie_rank <= 5;  -- Select top 5 movies for each genre and year based on income

# Method 3
WITH genre_count AS (
    -- CTE to identify the top 3 genres based on movie count
    select 
        genre                               -- Genre name
    from 
        genre
    group by 
        genre                               -- Group by genre to get count of movies per genre
    order by 
        count(movie_id) desc                -- Order genres by movie count in descending order
    limit 3                                  -- Limit to top 3 genres
),
income_clean AS (
    -- CTE to clean worldwide gross income and filter movies
    select 
        m.id,                               -- Movie ID
        m.title,                            -- Movie title
        m.year,                             -- Movie release year
        g.genre,                            -- Genre of the movie
        cast(replace(replace(m.worlwide_gross_income, '$', ''), ',', '') as unsigned) as income  -- Cleaned worldwide income
    from 
        movie m
    join 
        genre g on m.id = g.movie_id       -- Join movie with genre table
    where 
        m.worlwide_gross_income is not null -- Exclude movies with null worldwide income
),
ranked_movies AS (
    -- CTE to rank movies by income within genre and year
    select 
        genre, 
        year,
        title as movie_name,                -- Movie title
        income,                             -- Worldwide gross income
        dense_rank() over (partition by genre, year order by income desc) as movie_rank  -- Rank by income within genre and year
    from 
        income_clean
    where 
        genre in (select genre from genre_count)  -- Filter movies from top genres
)
-- Final selection of the top 5 movies for each genre and year
select 
    genre, 
    year, 
    movie_name, 
    concat('$', format(income, 0)) as worldwide_gross_income,  -- Format income with a dollar sign
    movie_rank 
from 
    ranked_movies
where 
    movie_rank <= 5;  -- Select the top 5 movies based on income