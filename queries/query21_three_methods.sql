-- Q21. Which are the top three production houses based on the number of votes received by their movies?
-- Type your code below:


# Method 1
select production_company, sum(total_votes) as vote_count,  -- Select production company and sum of votes
       rank() over (order by sum(total_votes) desc) as prod_comp_rank  -- Rank companies by vote count
from movie m  -- From movies table
join ratings r on m.id = r.movie_id  -- Joined with ratings table
group by production_company  -- Group by production company
limit 3;  -- WRONG: Limits before ranking is complete

# Method 2
with top_prod_h3 as (  -- Define CTE with complete ranked list
    select production_company, sum(total_votes) as vote_count,  -- Select company and vote sum
           rank() over (order by sum(total_votes) desc) as prod_comp_rank  -- Rank all companies
    from movie m  -- From movies table
    join ratings r on m.id = r.movie_id  -- Joined with ratings
    group by production_company  -- Group by company
)
select * from top_prod_h3  -- Select from CTE
where prod_comp_rank <= 3;  -- Filter to top 3 ranked companies

# Method 3

select * from (  -- Outer query selecting from subquery
    select production_company, sum(total_votes) as vote_count,  -- Select company and votes
           rank() over (order by sum(total_votes) desc) as prod_comp_rank  -- Rank all companies
    from movie m  -- From movies table
    join ratings r on m.id = r.movie_id  -- Joined with ratings
    group by production_company  -- Group by company
) abc  -- Subquery alias
where prod_comp_rank <= 3;  -- Filter to top 3 ranked companies

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/
