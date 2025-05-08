-- Q27. Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
-- Type your code below:


# Method 1
WITH multilingual_movies AS (
    -- CTE to select movies that have multiple languages
    select 
        id,                               -- Movie ID
        production_company                -- Production company
    from 
        movie
    where 
        languages like '%,%'             -- Filter for movies with more than one language
),
hits AS (
    -- CTE to select movies with median rating >= 8 and associated production companies
    select 
        r.movie_id,                       -- Movie ID
        m.production_company              -- Production company
    from 
        ratings r
    join 
        multilingual_movies m on r.movie_id = m.id  -- Join with multilingual_movies CTE
    where 
        r.median_rating >= 8             -- Filter for movies with median rating >= 8
),
production_count AS (
    -- CTE to count the number of movies for each production company
    select 
        production_company,              -- Production company
        count(*) as movie_count          -- Count of movies produced
    from 
        hits
    where 
        production_company is not null  -- Exclude rows with null production companies
    group by 
        production_company              -- Group by production company
),
ranked_productions AS (
    -- CTE to rank production companies based on the number of movies
    select 
        production_company,              -- Production company name
        movie_count,                     -- Number of movies produced
        dense_rank() over (order by movie_count desc) as prod_comp_rank -- Rank based on movie count
    from 
        production_count
)
select 
    production_company,                 -- Production company
    movie_count,                         -- Number of movies produced
    prod_comp_rank                      -- Rank of production company based on movie count
from 
    ranked_productions
where 
    prod_comp_rank <= 2;                -- Select the top 2 production companies
    
# Method 2
select 
    final.production_company,            -- Production company name
    final.movie_count,                   -- Number of movies produced
    final.prod_comp_rank                -- Rank based on the movie count
from (
    -- Subquery that calculates movie count and ranks production companies
    select 
        m.production_company,            -- Production company
        count(*) as movie_count,         -- Number of movies produced
        dense_rank() over (order by count(*) desc) as prod_comp_rank -- Rank based on movie count
    from 
        movie m
    join 
        ratings r on m.id = r.movie_id  -- Join with ratings to get ratings data
    where 
        m.languages like '%,%'           -- Filter for multilingual movies
        and r.median_rating >= 8         -- Filter for movies with median rating >= 8
        and m.production_company is not null -- Exclude null production companies
    group by 
        m.production_company             -- Group by production company
) as final
where 
    final.prod_comp_rank <= 2;           -- Select top 2 production companies
    
# Method 3
WITH multilingual_hits AS (
    -- CTE to filter multilingual movies with median rating >= 8
    select 
        m.production_company              -- Production company name
    from 
        movie m
    join 
        ratings r on m.id = r.movie_id  -- Join movie with ratings table
    where 
        m.languages like '%,%'           -- Filter for multilingual movies
        and r.median_rating >= 8         -- Filter for movies with median rating >= 8
        and m.production_company is not null -- Exclude null production companies
),
ranked_productions AS (
    -- CTE to count the number of multilingual movies for each production company and rank them
    select 
        production_company,              -- Production company name
        count(*) as movie_count,         -- Number of movies produced
        dense_rank() over (order by count(*) desc) as prod_comp_rank -- Rank production companies by movie count
    from 
        multilingual_hits                -- From the previous CTE result
    group by 
        production_company               -- Group by production company
)
select 
    production_company,                 -- Production company name
    movie_count,                         -- Number of movies produced
    prod_comp_rank                      -- Rank based on movie count
from 
    ranked_productions
where 
    prod_comp_rank <= 2;                -- Select the top 2 production companies


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

