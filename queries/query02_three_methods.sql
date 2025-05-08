-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- # Method 1

select COUNT(*) as total_rows,  -- Count all rows in table
       COUNT(title) as title_non_null,  -- Count non-null titles
       COUNT(year) as year_non_null,  -- Count non-null years
       COUNT(date_published) as date_published_non_null,  -- Count non-null publication dates
       COUNT(country) as country_non_null,  -- Count non-null countries
       COUNT(worlwide_gross_income) as worlwide_gross_income_non_null,  -- Count non-null incomes
       COUNT(languages) as languages_non_null,  -- Count non-null languages
       COUNT(production_company) as production_company_non_null  -- Count non-null production companies
from movie;  -- From movies table

-- # Method 2
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,  -- Count NULL IDs
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,  -- Count NULL titles
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,  -- Count NULL years
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,  -- Count NULL dates
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,  -- Count NULL durations
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,  -- Count NULL countries
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,  -- Count NULL incomes
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,  -- Count NULL languages
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count  -- Count NULL companies
FROM
    movie;  -- From movies table

--  # Method 3
delimiter $$
create procedure get_null_col()
begin
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM
    movie;
end;
$$

call get_null_col();
