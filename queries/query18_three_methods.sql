-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format */


# Method 1
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, -- Count NULLs in 'name' column
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls, -- Count NULLs in 'height' column
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls, -- Count NULLs in 'date_of_birth' column
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls -- Count NULLs in 'known_for_movies' column
FROM names; 

# Method 2

SELECT 
    COUNT(*) - COUNT(name) AS name_nulls, -- Total rows minus non-null 'name' values
    COUNT(*) - COUNT(height) AS height_nulls, -- Total rows minus non-null 'height' values
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls, -- Total rows minus non-null 'date_of_birth' values
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls -- Total rows minus non-null 'known_for_movies' values
FROM names; 

# Method 3

SELECT 'name' AS column_name, COUNT(*) - COUNT(name) AS null_count FROM names -- Count NULLs in 'name' column and label the column name
UNION ALL
SELECT 'height', COUNT(*) - COUNT(height) FROM names -- Count NULLs in 'height' column and label the column name
UNION ALL
SELECT 'date_of_birth', COUNT(*) - COUNT(date_of_birth) FROM names -- Count NULLs in 'date_of_birth' column and label the column name
UNION ALL
SELECT 'known_for_movies', COUNT(*) - COUNT(known_for_movies) FROM names; -- Count NULLs in 'known_for_movies' column and label the column name


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/
