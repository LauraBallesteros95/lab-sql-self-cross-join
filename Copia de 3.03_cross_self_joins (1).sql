-- Cross and Self Joins

-- Self Joins:
-- Allows you to join a table to itself, useful when comparing rows within the same table.
-- You use it if you have two or more different values in the same column, but you want to display them in different columns and in the same row.
-- More examples: https://www.sqlservertutorial.net/sql-server-basics/sql-server-self-join/

-- Find the customers that are from the same district:
select * from bank.account;

select * from bank.account a1
join bank.account a2
on a1.district_id = a2.district_id
order by a1.district_id, a1.account_id,a2.account_id;

select * from bank.account a1
join bank.account a2
on a1.district_id = a2.district_id
and a1.account_id > a2.account_id  -- the same as != (not equal to) 
order by a1.district_id, a1.account_id, a2.account_id;

-- Find the accounts that have both OWNER and DISPONENT:
select * from disp;

select * from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type
where d1.type = 'DISPONENT';


-- Cross Joins:
-- Used when you wish to create a combination of every row from two tables:
-- (A, B, C) x (1, 2): (A, 1), (A, 2), (B, 1), (B, 2), (C, 1), (C, 2)

-- Find all the combinations of different card types and ownership of account:
create temporary table card_type
select distinct type from bank.card;

create temporary table disp_type
select distinct type from bank.disp;

select * from card_type
cross join disp_type;


-- Intro to subqueries.
select * from (select distinct type from bank.card) sub1
cross join (select distinct type from bank.disp) sub2;

select * from loan
where payments > (select avg(payments) from loan);

-- EXERCISE LAB 
--
SELECT 
    a1.actor_id,
    a1.first_name,
    a1.last_name,
    a2.actor_id,
    a2.first_name,
    a2.last_name
FROM
    actor AS a1
        CROSS JOIN
    actor AS a2
        JOIN
    film_actor AS fa1 ON fa1.actor_id = a1.actor_id
        JOIN
    film_actor AS fa2 ON fa2.actor_id = a2.actor_id
WHERE
    fa1.film_id = fa2.film_id
        AND a1.actor_id != a2.actor_id;
  
-- This query starts by selecting all actors from the actor table and performing a cross join with itself using the actor AS a1 and actor AS a2 aliases. Then, it joins the film_actor table twice, once for each actor, using the actor_id column. By comparing the film_id of both film_actor records, it filters out pairs of actors that haven't worked together. Finally, the WHERE clause filters out pairs of actors that are the same.
-- Running this query will give you a result set with each pair of actors who have worked together, including their names and actor IDs.

-- Get all pairs of customers that have rented the same film more than 3 times.
SELECT c1.customer_id, c1.first_name, c1.last_name,
       c2.customer_id, c2.first_name, c2.last_name,
       f.film_id, f.title, COUNT(*) AS rental_count
FROM customer AS c1
JOIN rental AS r1 ON c1.customer_id = r1.customer_id
JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
JOIN film AS f ON i1.film_id = f.film_id
CROSS JOIN customer AS c2
JOIN rental AS r2 ON c2.customer_id = r2.customer_id
JOIN inventory AS i2 ON r2.inventory_id = i2.inventory_id
WHERE c1.customer_id < c2.customer_id
  AND f.film_id = i2.film_id
GROUP BY c1.customer_id, c2.customer_id, f.film_id, f.title
HAVING rental_count > 3;

-- This query starts by selecting all customers from the customer table and performing a cross join with itself using the aliases customer AS c1 and customer AS c2. Then, it joins the necessary tables (rental, inventory, and film) to retrieve the rental information and film details.
-- By comparing the customer_id and film_id, the query filters out pairs of customers who have rented the same film. The WHERE clause also ensures that the first customer's customer_id is less than the second customer's customer_id to avoid duplicate pairs.
-- The GROUP BY clause groups the results by the customer IDs and film IDs, and then the HAVING clause filters out pairs that have a rental count (how many times they rented the film) greater than 3.
-- Running this query will give you a result set with each pair of customers, along with the film they rented and the total rental count.

-- Get all possible pairs of actors and films.
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor AS a
CROSS JOIN film AS f;
-- This query performs a cross join between the actor table and the film table. It selects the actor_id, first_name, and last_name columns from the actor table, and the film_id and title columns from the film table.
-- By executing this query, it will give you a result set with all possible combinations of actors and films. Each row will contain an actor_id, first_name, last_name, film_id, and title.