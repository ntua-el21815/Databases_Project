#Example of DDL (Data Definition Language Aspect of SQL)

CREATE DATABASE test1;

USE test1;

CREATE TABLE movies(
	title VARCHAR(50) NOT NULL,
	genre VARCHAR(30) NOT NULL,
	director VARCHAR(60) NOT NULL,
	release_year INT NOT NULL,
	PRIMARY KEY(title)
);

INSERT INTO movies VALUE ("Joker", "psychological thriller", "Todd Phillips", 2019);

SELECT * FROM movies;

SHOW DATABASES;

SHOW TABLES; 

CREATE TABLE parts (
	part_no VARCHAR(18),
	description VARCHAR(40),
	cost DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
	price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
	PRIMARY KEY (part_no)
);

DROP TABLE parts;

CREATE VIEW minimum_release_year AS
	SELECT title FROM movies WHERE release_year>1990;
    
SELECT * FROM minimum_release_year;

TRUNCATE TABLE movies; #Deletes all data from a table.

SELECT * FROM movies; 

SELECT * FROM minimum_release_year;

DROP TABLE movies;

DROP VIEW minimum_release_year;

CREATE TABLE customers (
	customerNumber int(11) NOT NULL,
	customerName varchar(50) NOT NULL,
	PRIMARY KEY (customerNumber)
);

CREATE TABLE orders (
	orderNumber int(11) NOT NULL,
	orderDate date NOT NULL,
	customerNumber int(11) NOT NULL,
	PRIMARY KEY (orderNumber),
	CONSTRAINT orders_ibfk_1 FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);

USE sakila;

INSERT INTO actor (first_name,last_name) VALUES('Zach','Galifianakis');

SELECT * FROM actor;

INSERT INTO actor(actor_id,first_name,last_name) VALUES(NULL,'Maria','Menounos');

INSERT INTO actor(actor_id,first_name,last_name) VALUES(300,'Maria','Menounos');

UPDATE actor
SET first_name = 'ZACH', last_name = upper('Galifianakis')
WHERE actor_id = 201;

DELETE FROM actor WHERE actor_id = 300;

UPDATE actor
SET first_name = upper(first_name), last_name = upper(last_name)
WHERE actor_id = 202;

INSERT INTO actor (actor_id, first_name, last_name) VALUES (1, 'Irene', 'Papas'); #Error Duplicate Primary

INSERT INTO film_actor (actor_id, film_id) VALUES (201, 1050);#Error Foreign Key doesn't exist

UPDATE film SET length = -1 WHERE film_id = 1;#Error,Violation of constraint

DESC customer;

SELECT * FROM customer WHERE customer_id = 1;

update customer set create_date = str_to_date("Aug 10 2017", "%b %d %Y")
WHERE customer.customer_id = 1; #Be sure to always check how to format dates for your specific RDBMS.