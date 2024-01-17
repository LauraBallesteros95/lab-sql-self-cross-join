-- SQL Self and cross join
-- Get all pairs of actors that worked together.
SELECT a1.actor_id, a1.first_name, a1.last_name,
       a2.actor_id, a2.first_name, a2.last_name
FROM actor AS a1
CROSS JOIN actor AS a2
JOIN film_actor AS fa1 ON fa1.actor_id = a1.actor_id
JOIN film_actor AS fa2 ON fa2.actor_id = a2.actor_id
WHERE fa1.film_id = fa2.film_id
  AND a1.actor_id != a2.actor_id;
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
-- Get all possible pairs of actors and films.
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor AS a
CROSS JOIN film AS f;