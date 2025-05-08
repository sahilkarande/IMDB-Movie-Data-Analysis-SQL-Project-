-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)


# Method 1
SELECT production_company, SUM(total_votes) AS vote_count,
       RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
JOIN ratings r ON m.id = r.movie_id
GROUP BY production_company 
LIMIT 3;  -- Simple limit but doesn't handle ranking ties properly

# Method 2
WITH top_prod_h3 AS (
    SELECT production_company, SUM(total_votes) AS vote_count,
           RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY production_company
)
SELECT * FROM top_prod_h3 
WHERE prod_comp_rank <= 3;  -- Correctly includes all companies tied for top 3 ranks

# Method 3
SELECT * FROM (
    SELECT production_company, SUM(total_votes) AS vote_count,
           RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY production_company
) abc
WHERE prod_comp_rank <= 3;  -- Same results as CTE version, just different syntax

-- Top actor is Vijay Sethupathi