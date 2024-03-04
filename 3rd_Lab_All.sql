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

UPDATE customer 
	SET create_date = str_to_date("Aug 10 2017", "%b %d %Y")
	WHERE customer.customer_id = 1; #Be sure to always check how to format dates for your specific RDBMS.

#From here on Lab Exercises

USE sakila;

#1st Exercise

SELECT * FROM actor WHERE first_name = 'EMILY';

UPDATE actor
	SET last_name = 'TEMPLE'
	WHERE actor_id = 148;

#2nd Exercise 

SHOW CREATE TABLE sakila.actor;

#3rd Exercise 

DESC actor;

ALTER TABLE actor
	ADD middle_name VARCHAR(45) AFTER first_name; #I have no reason to think that the max length of middle name should be different from that of first or last name.

#4th Exercise

SET SQL_SAFE_UPDATES = 0;

UPDATE actor
	SET middle_name = 'Jonathan'; #Very funny

UPDATE actor
	SET middle_name = upper('Jonathan'); #Very funny

SET SQL_SAFE_UPDATES = 1; #Good safety feature Honestly

#5th Exercise

ALTER TABLE actor
	DROP COLUMN middle_name; 

#6th Exercise

CREATE TABLE boss_records(
	number_of_actors INT,
    number_of_customers INT,
    number_of_rentals INT
);

INSERT INTO boss_records
	SELECT 
		(SELECT COUNT(*) FROM actor),
		(SELECT COUNT(*) FROM customer),
		(SELECT COUNT(*) FROM rental)
;
SELECT * FROM boss_records;
    
#7th Exercise 

USE test1;

CREATE TABLE users (
	ΑΡ_ΤΑΥΤ CHAR(7),
    ΕΠΩΝΥΜΟ VARCHAR(255),
    ΟΝΟΜΑ VARCHAR(255),
    ΗΜ_ΓΕΝΝΗΣΗΣ DATE
);

ALTER TABLE users
	ADD CONSTRAINT pk_id PRIMARY KEY (ΑΡ_ΤΑΥΤ);
    
INSERT INTO users VALUES ('Π702538','ΚΑΛΛΙΓΕΡΟΣ', 'ΔΗΜΗΤΡΗΣ', '1985-11-10');
INSERT INTO users VALUES('Χ234678', 'ΣΕΜΠΟΣ','ΒΑΣΙΛΗΣ' ,'1976-1-1');
INSERT INTO users VALUES('Χ297200','ΜΙΧΑΣ' ,'ΑΓΓΕΛΟΣ' ,'1981-3-25');

SELECT * FROM users;


	