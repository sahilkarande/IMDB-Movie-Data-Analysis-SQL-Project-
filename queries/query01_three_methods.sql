-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


-- # Method 1
select 'Movie' as table_name, count(*) as number_of_rows from movie  -- Count rows in movie table
UNION ALL
select 'Genre' as table_name, count(*) as number_of_rows from genre -- Count rows in genre table
UNION ALL
select 'Names' as table_name, count(*) as number_of_rows from names  -- Count rows in names table
UNION ALL
select 'Role_Mapping' as table_name, count(*) as number_of_rows from role_mapping  -- Count rows in role_mapping
UNION ALL
select 'Director_Mapping' as table_name, count(*) as number_of_rows from director_mapping  -- Count rows in director_mapping
UNION ALL
select 'Ratings' as table_name, count(*) as number_of_rows from ratings;  -- Count rows in ratings table

-- # Method 2
-- Define a stored procedure named 'get_number_of_rows1' with no parameters
delimiter $$
create procedure get_number_of_rows1()
begin
    -- Select table names and their row counts from information_schema
    -- Specifically for tables in the 'imdb' database
    select table_name, table_rows as number_of_rows 
    from information_schema.tables 
    where table_schema = 'imdb';
end;
$$

-- Change the delimiter back to semicolon
delimiter ;

-- Execute the stored procedure to get the row counts for all tables in the 'imdb' database
call get_number_of_rows1();

--  # Method 3
select table_name,table_rows as number_of_rows  -- Select table names and row counts
from information_schema.tables  -- From system metadata tables
where table_schema='imdb';  -- Filter for our database schema