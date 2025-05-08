-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating > 8) in drama genre?
-- Type your code below:


# Method 1
select actress_name, total_votes, movie_count, actress_avg_rating, actress_rank from
(select n.name as actress_name,
sum(r.total_votes) as total_votes,          -- Sum total votes per actress
count(*) as movie_count,                    -- Count movies per actress 
avg(r.avg_rating) as actress_avg_rating,    -- Calculate average rating
DENSE_RANK() OVER(ORDER BY avg(r.avg_rating) DESC) as actress_rank  -- Rank by rating
FROM ratings r 
JOIN role_mapping rm ON r.movie_id=rm.movie_id
JOIN names n ON n.id=rm.name_id
JOIN genre g ON g.movie_id=rm.movie_id
WHERE rm.category='actress'                 -- Only actresses
  and g.genre='drama'                       -- Only drama genre
  and r.avg_rating>8                        -- Only high-rated movies
GROUP BY n.name, n.id
) AS top_actress 
WHERE actress_rank<=3;                      -- Filter top 3 ranked

# Method 2
WITH top_actress AS                         -- Create CTE for actress data
(select n.name as actress_name,
sum(r.total_votes) as total_votes,          -- Aggregate votes
count(*) as movie_count,                    -- Count movies
avg(r.avg_rating) as actress_avg_rating,    -- Calculate average
DENSE_RANK() OVER(ORDER BY avg(r.avg_rating) DESC) as actress_rank  -- Rank
FROM ratings r 
JOIN role_mapping rm ON r.movie_id=rm.movie_id
JOIN names n ON n.id=rm.name_id
JOIN genre g ON g.movie_id=rm.movie_id
WHERE rm.category='actress'                 -- Actress filter
  and g.genre='drama'                       -- Drama filter
  and r.avg_rating>8                        -- Rating filter
GROUP BY n.name, n.id
)
select actress_name, total_votes, movie_count, 
       actress_avg_rating, actress_rank 
from top_actress
WHERE actress_rank<=3;                      -- Get top 3

# Method 3
DELIMITER $$
CREATE PROCEDURE top_actress()              -- Create stored procedure
BEGIN
	select actress_name, total_votes, movie_count, 
           actress_avg_rating, actress_rank 
	from
	(select n.name as actress_name,
	sum(r.total_votes) as total_votes,       -- Same logic as above
	count(*) as movie_count,
	avg(r.avg_rating) as actress_avg_rating,
	DENSE_RANK() OVER(ORDER BY avg(r.avg_rating) DESC) as actress_rank
	FROM ratings r 
	JOIN role_mapping rm ON r.movie_id=rm.movie_id
	JOIN names n ON n.id=rm.name_id
	JOIN genre g ON g.movie_id=rm.movie_id
	WHERE rm.category='actress' 
	  and g.genre='drama' 
	  and r.avg_rating>8
	GROUP BY n.name, n.id
	) AS top_actress 
	WHERE actress_rank<=3;                   -- Top 3 filter
END; $$
DELIMITER ;

call top_actress();                         -- Execute procedure