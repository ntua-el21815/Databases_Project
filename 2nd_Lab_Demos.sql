USE sakila;

SELECT actor_id,first_name,last_name FROM actor ORDER BY 3,2;

SELECT actor_id,first_name,last_name FROM actor WHERE last_name IN ("WILLIAMS","DAVIS");

SELECT title,description,rating,length FROM film WHERE length >= 180;

SELECT last_name "Unique last names" FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;#

SELECT AVG(length) FROM film;