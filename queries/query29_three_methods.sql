-- Q29. Get the following details for top 9 directors (based on number of movies): Director id, Name, Number of movies, Average inter-movie duration in days, Average movie ratings, Total votes, Min rating, Max rating, Total movie durations
-- Type your code below:
-- Director id
-- Name
-- Number of movies
-- Average inter movie duration in days
-- Average movie ratings
-- Total votes
-- Min rating
-- Max rating
-- total movie durations





# Method 1
with director_movies as (  -- Create CTE with director statistics
    select 
        dm.name_id as director_id,  -- Director ID from mapping table
        n.name as director_name,  -- Director name from names table
        count(*) as number_of_movies,  -- Count of movies per director
        avg(r.avg_rating) as avg_rating,  -- Average rating across all movies
        sum(r.total_votes) as total_votes,  -- Sum of all votes for director's movies
        min(r.avg_rating) as min_rating,  -- Director's lowest rated movie
        max(r.avg_rating) as max_rating,  -- Director's highest rated movie
        sum(m.duration) as total_duration,  -- Total runtime of all movies
        group_concat(m.date_published order by m.date_published) as movie_dates  -- Comma-separated list of movie dates
    from 
        director_mapping dm  -- Start with director mapping table
    join 
        movie m on dm.movie_id = m.id  -- Join to movie details
    join 
        ratings r on m.id = r.movie_id  -- Join to ratings
    join 
        names n on dm.name_id = n.id  -- Join to get director names
    group by 
        dm.name_id, n.name  -- Group by director
)
select 
    director_id,
    director_name,
    number_of_movies,
    -- Calculate average days between movie releases
    avg(datediff(
        substring_index(movie_dates, ',', n.n),  -- Get nth movie date
        substring_index(movie_dates, ',', n.n - 1)  -- Get (n-1)th movie date
    )) as avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
from 
    director_movies
join 
    -- Generate sequence numbers to help calculate date differences between movies
    (select 1 as n union all select 2 union all select 3 union all select 4 
     union all select 5 union all select 6 union all select 7 
     union all select 8 union all select 9) n on n.n <= number_of_movies
group by 
    director_id, director_name
order by 
    number_of_movies desc  -- Order by most prolific directors first
limit 9;  -- Get top 9 only

# Method 2

with director_movies as (  -- Same CTE as Query 1
    select 
        dm.name_id as director_id,
        n.name as director_name,
        count(*) as number_of_movies,
        avg(r.avg_rating) as avg_rating,
        sum(r.total_votes) as total_votes,
        min(r.avg_rating) as min_rating,
        max(r.avg_rating) as max_rating,
        sum(m.duration) as total_duration,
        group_concat(m.date_published order by m.date_published) as movie_dates
    from 
        director_mapping dm
    join 
        movie m on dm.movie_id = m.id
    join 
        ratings r on m.id = r.movie_id
    join 
        names n on dm.name_id = n.id
    group by 
        dm.name_id, n.name
)
select 
    director_id,
    director_name,
    number_of_movies,
    avg(datediff(
        substring_index(movie_dates, ',', n.n), 
        substring_index(movie_dates, ',', n.n - 1)
    )) as avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
from 
    director_movies
join 
    (select 1 as n union all select 2 union all select 3 union all select 4 
     union all select 5 union all select 6 union all select 7 
     union all select 8 union all select 9) n on n.n <= number_of_movies
group by 
    director_id, director_name
order by 
    total_votes desc  -- Order by most popular directors (total votes) first
limit 9;

# Method 3

with director_movies as (  -- Same CTE as previous queries
    select 
        dm.name_id as director_id,
        n.name as director_name,
        count(*) as number_of_movies,
        avg(r.avg_rating) as avg_rating,
        sum(r.total_votes) as total_votes,
        min(r.avg_rating) as min_rating,
        max(r.avg_rating) as max_rating,
        sum(m.duration) as total_duration,
        group_concat(m.date_published order by m.date_published) as movie_dates
    from 
        director_mapping dm
    join 
        movie m on dm.movie_id = m.id
    join 
        ratings r on m.id = r.movie_id
    join 
        names n on dm.name_id = n.id
    group by 
        dm.name_id, n.name
)
select 
    director_id,
    director_name,
    number_of_movies,
    avg(datediff(
        substring_index(movie_dates, ',', n.n), 
        substring_index(movie_dates, ',', n.n - 1)
    )) as avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
from 
    director_movies
join 
    (select 1 as n union all select 2 union all select 3 union all select 4 
     union all select 5 union all select 6 union all select 7 
     union all select 8 union all select 9) n on n.n <= number_of_movies
group by 
    director_id, director_name
order by 
    avg_rating desc  -- Order by highest average rating first
limit 9;
