-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.


# Method 1
-- First, check if the movie language is German or Italian
-- Then group by language and add up (SUM) all the total votes
SELECT
    CASE
        WHEN m.languages LIKE '%German%' THEN 'German'
        WHEN m.languages LIKE '%Italian%' THEN 'Italian'
    END AS language,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.languages LIKE '%German%' OR m.languages LIKE '%Italian%' # In this line we check the word german and italian using like function in where that column accouring
GROUP BY language;

    
# Mehtod 2
-- Use IF() to directly label the language as 'German' or 'Italian'
-- Then group by that label and sum the votes
SELECT 
    IF(m.languages LIKE '%German%', 'German', 'Italian') AS language,  # In this we use the if clause where check that country languages are present.
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.languages LIKE '%German%' OR m.languages LIKE '%Italian%'
GROUP BY language;


# Method 3
WITH movie_votes AS ( 
    SELECT 
        m.id,
        r.total_votes, 
        CASE
            WHEN m.languages LIKE '%German%' THEN 'German' -- If 'languages' contains 'German', label it as 'German'
            WHEN m.languages LIKE '%Italian%' THEN 'Italian' -- If 'languages' contains 'Italian', label it as 'Italian'
        END AS language -- Alias the result of CASE as 'language'
    FROM movie m 
    JOIN ratings r ON m.id = r.movie_id -- Join with the 'ratings' table where movie IDs match
    WHERE m.languages LIKE '%German%' OR m.languages LIKE '%Italian%' -- Only include movies that have German or Italian in their languages
)
SELECT 
    language, -- Select the language ('German' or 'Italian')
    SUM(total_votes) AS total_votes -- Sum up the total votes for each language
FROM movie_votes 
GROUP BY language; -- Group the results by language
