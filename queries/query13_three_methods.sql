-- Q13. Which production house has produced the most number of hit movies (average rating > 8)?
-- Type your code below:


# Method 1
select m.production_company  -- Select just the production company name
from movie m join ratings r on m.id = r.movie_id  -- Join movies with their ratings
where avg_rating > 8;  -- Filter for movies with average rating above 8

# Method 2
with prod_house as (  -- Create a Common Table Expression (CTE) named prod_house
select m.production_company,  -- Select production company name
       count(*) as tota_hit_movie  -- Count number of movies per company
from movie m  -- From movies table
join ratings r  -- Join with ratings table
on m.id = r.movie_id  -- Join condition
where avg_rating > 8  -- Only include highly rated movies (avg_rating > 8)
group by m.production_company  -- Group results by production company
order by tota_hit_movie desc  -- Order by movie count in descending order
limit 1  -- Return only the top result (company with most hits)
) 
select * from prod_house;  -- Select all columns from the CTE

# Method 3
select production_company  -- Select production company name
from movie  -- From movies table
where id in (  -- Filter for movies where ID exists in the subquery results
      select movie_id  -- Subquery selects movie IDs
      from ratings  -- From ratings table
      where avg_rating >8  -- Where rating is above 8
);  -- Note: This returns ALL companies with any highly rated movie, not just the top one

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both