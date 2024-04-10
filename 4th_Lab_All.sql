USE sakila;

SELECT first_name,last_name,customer.address_id,city_id FROM customer JOIN address ON customer.address_id = address.address_id;

