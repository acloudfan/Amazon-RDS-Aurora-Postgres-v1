
delimiter $$
            
-- Source Schema file created by SCT using the option to save in SQL file
-- MySQL

-- ------------ Write DROP-OTHER-stage scripts -----------

USE `sakila`;$$
DROP FUNCTION IF EXISTS sakila.get_customer_balance;$$

DROP FUNCTION IF EXISTS sakila.inventory_held_by_customer;$$

DROP FUNCTION IF EXISTS sakila.inventory_in_stock;$$

DROP PROCEDURE IF EXISTS sakila.film_in_stock;$$

DROP PROCEDURE IF EXISTS sakila.film_not_in_stock;$$

DROP PROCEDURE IF EXISTS sakila.rewards_report;$$

DROP TRIGGER IF EXISTS sakila.customer_create_date;$$

DROP TRIGGER IF EXISTS sakila.del_film;$$

DROP TRIGGER IF EXISTS sakila.ins_film;$$

DROP TRIGGER IF EXISTS sakila.upd_film;$$

DROP TRIGGER IF EXISTS sakila.payment_date;$$

DROP TRIGGER IF EXISTS sakila.rental_date;$$

DROP VIEW IF EXISTS sakila.actor_info;$$

DROP VIEW IF EXISTS sakila.customer_list;$$

DROP VIEW IF EXISTS sakila.film_list;$$

DROP VIEW IF EXISTS sakila.nicer_but_slower_film_list;$$

DROP VIEW IF EXISTS sakila.sales_by_film_category;$$

DROP VIEW IF EXISTS sakila.sales_by_store;$$

DROP VIEW IF EXISTS sakila.staff_list;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE sakila.address DROP FOREIGN KEY fk_address_city;$$

ALTER TABLE sakila.city DROP FOREIGN KEY fk_city_country;$$

ALTER TABLE sakila.customer DROP FOREIGN KEY fk_customer_address;$$

ALTER TABLE sakila.customer DROP FOREIGN KEY fk_customer_store;$$

ALTER TABLE sakila.film DROP FOREIGN KEY fk_film_language;$$

ALTER TABLE sakila.film DROP FOREIGN KEY fk_film_language_original;$$

ALTER TABLE sakila.film_actor DROP FOREIGN KEY fk_film_actor_actor;$$

ALTER TABLE sakila.film_actor DROP FOREIGN KEY fk_film_actor_film;$$

ALTER TABLE sakila.film_category DROP FOREIGN KEY fk_film_category_category;$$

ALTER TABLE sakila.film_category DROP FOREIGN KEY fk_film_category_film;$$

ALTER TABLE sakila.inventory DROP FOREIGN KEY fk_inventory_film;$$

ALTER TABLE sakila.inventory DROP FOREIGN KEY fk_inventory_store;$$

ALTER TABLE sakila.payment DROP FOREIGN KEY fk_payment_customer;$$

ALTER TABLE sakila.payment DROP FOREIGN KEY fk_payment_rental;$$

ALTER TABLE sakila.payment DROP FOREIGN KEY fk_payment_staff;$$

ALTER TABLE sakila.rental DROP FOREIGN KEY fk_rental_customer;$$

ALTER TABLE sakila.rental DROP FOREIGN KEY fk_rental_inventory;$$

ALTER TABLE sakila.rental DROP FOREIGN KEY fk_rental_staff;$$

ALTER TABLE sakila.staff DROP FOREIGN KEY fk_staff_address;$$

ALTER TABLE sakila.staff DROP FOREIGN KEY fk_staff_store;$$

ALTER TABLE sakila.store DROP FOREIGN KEY fk_store_address;$$

ALTER TABLE sakila.store DROP FOREIGN KEY fk_store_staff;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-INDEX-stage scripts -----------

DROP INDEX idx_actor_last_name ON sakila.actor;$$

DROP INDEX idx_fk_city_id ON sakila.address;$$

DROP INDEX idx_location ON sakila.address;$$

DROP INDEX idx_fk_country_id ON sakila.city;$$

DROP INDEX idx_fk_address_id ON sakila.customer;$$

DROP INDEX idx_fk_store_id ON sakila.customer;$$

DROP INDEX idx_last_name ON sakila.customer;$$

DROP INDEX idx_fk_language_id ON sakila.film;$$

DROP INDEX idx_fk_original_language_id ON sakila.film;$$

DROP INDEX idx_title ON sakila.film;$$

DROP INDEX idx_fk_film_id ON sakila.film_actor;$$

DROP INDEX idx_title_description ON sakila.film_text;$$

DROP INDEX idx_fk_film_id ON sakila.inventory;$$

DROP INDEX idx_store_id_film_id ON sakila.inventory;$$

DROP INDEX idx_fk_customer_id ON sakila.payment;$$

DROP INDEX idx_fk_staff_id ON sakila.payment;$$

DROP INDEX idx_fk_customer_id ON sakila.rental;$$

DROP INDEX idx_fk_inventory_id ON sakila.rental;$$

DROP INDEX idx_fk_staff_id ON sakila.rental;$$

DROP INDEX idx_fk_address_id ON sakila.staff;$$

DROP INDEX idx_fk_store_id ON sakila.staff;$$

DROP INDEX idx_fk_address_id ON sakila.store;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS sakila.actor;$$

DROP TABLE IF EXISTS sakila.address;$$

DROP TABLE IF EXISTS sakila.category;$$

DROP TABLE IF EXISTS sakila.city;$$

DROP TABLE IF EXISTS sakila.country;$$

DROP TABLE IF EXISTS sakila.customer;$$

DROP TABLE IF EXISTS sakila.film;$$

DROP TABLE IF EXISTS sakila.film_actor;$$

DROP TABLE IF EXISTS sakila.film_category;$$

DROP TABLE IF EXISTS sakila.film_text;$$

DROP TABLE IF EXISTS sakila.inventory;$$

DROP TABLE IF EXISTS sakila.language;$$

DROP TABLE IF EXISTS sakila.payment;$$

DROP TABLE IF EXISTS sakila.rental;$$

DROP TABLE IF EXISTS sakila.staff;$$

DROP TABLE IF EXISTS sakila.store;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write DROP-DATABASE-stage scripts -----------


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE DATABASE IF NOT EXISTS sakila;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE sakila.actor (
actor_id smallint unsigned NOT NULL AUTO_INCREMENT,
first_name varchar(45) NOT NULL,
last_name varchar(45) NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (actor_id)
) auto_increment=200;$$

CREATE TABLE sakila.address (
address_id smallint unsigned NOT NULL AUTO_INCREMENT,
address varchar(50) NOT NULL,
address2 varchar(50) DEFAULT NULL,
district varchar(20) NOT NULL,
city_id smallint unsigned NOT NULL,
postal_code varchar(10) DEFAULT NULL,
phone varchar(20) NOT NULL,
location geometry NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (address_id)
) auto_increment=605;$$

CREATE TABLE sakila.category (
category_id tinyint unsigned NOT NULL AUTO_INCREMENT,
name varchar(25) NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (category_id)
) auto_increment=16;$$

CREATE TABLE sakila.city (
city_id smallint unsigned NOT NULL AUTO_INCREMENT,
city varchar(50) NOT NULL,
country_id smallint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (city_id)
) auto_increment=600;$$

CREATE TABLE sakila.country (
country_id smallint unsigned NOT NULL AUTO_INCREMENT,
country varchar(50) NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (country_id)
) auto_increment=109;$$

CREATE TABLE sakila.customer (
customer_id smallint unsigned NOT NULL AUTO_INCREMENT,
store_id tinyint unsigned NOT NULL,
first_name varchar(45) NOT NULL,
last_name varchar(45) NOT NULL,
email varchar(50) DEFAULT NULL,
address_id smallint unsigned NOT NULL,
active tinyint(1) NOT NULL DEFAULT '1',
create_date datetime NOT NULL,
last_update timestamp  DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (customer_id)
) auto_increment=599;$$

CREATE TABLE sakila.film (
film_id smallint unsigned NOT NULL AUTO_INCREMENT,
title varchar(128) NOT NULL,
description text(65535) DEFAULT NULL,
release_year year DEFAULT NULL,
language_id tinyint unsigned NOT NULL,
original_language_id tinyint unsigned DEFAULT NULL,
rental_duration tinyint unsigned NOT NULL DEFAULT '3',
rental_rate decimal(4,2) NOT NULL DEFAULT '4.99',
length smallint unsigned DEFAULT NULL,
replacement_cost decimal(5,2) NOT NULL DEFAULT '19.99',
rating enum('G','PG','PG-13','R','NC-17')  DEFAULT 'G',
special_features set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (film_id)
) auto_increment=1000;$$

CREATE TABLE sakila.film_actor (
actor_id smallint unsigned NOT NULL,
film_id smallint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (actor_id,film_id)
);$$

CREATE TABLE sakila.film_category (
film_id smallint unsigned NOT NULL,
category_id tinyint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (film_id,category_id)
);$$

CREATE TABLE sakila.film_text (
film_id smallint NOT NULL,
title varchar(255) NOT NULL,
description text(65535) DEFAULT NULL,
PRIMARY KEY (film_id)
);$$

CREATE TABLE sakila.inventory (
inventory_id mediumint unsigned NOT NULL AUTO_INCREMENT,
film_id smallint unsigned NOT NULL,
store_id tinyint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (inventory_id)
) auto_increment=4581;$$

CREATE TABLE sakila.language (
language_id tinyint unsigned NOT NULL AUTO_INCREMENT,
name char(20) NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (language_id)
) auto_increment=6;$$

CREATE TABLE sakila.payment (
payment_id smallint unsigned NOT NULL AUTO_INCREMENT,
customer_id smallint unsigned NOT NULL,
staff_id tinyint unsigned NOT NULL,
rental_id int DEFAULT NULL,
amount decimal(5,2) NOT NULL,
payment_date datetime NOT NULL,
last_update timestamp  DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (payment_id)
) auto_increment=16049;$$

CREATE TABLE sakila.rental (
rental_id int NOT NULL AUTO_INCREMENT,
rental_date datetime NOT NULL,
inventory_id mediumint unsigned NOT NULL,
customer_id smallint unsigned NOT NULL,
return_date datetime DEFAULT NULL,
staff_id tinyint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (rental_id),
CONSTRAINT rental_date UNIQUE (rental_date, inventory_id, customer_id)
) auto_increment=16049;$$

CREATE TABLE sakila.staff (
staff_id tinyint unsigned NOT NULL AUTO_INCREMENT,
first_name varchar(45) NOT NULL,
last_name varchar(45) NOT NULL,
address_id smallint unsigned NOT NULL,
picture blob(65535) DEFAULT NULL,
email varchar(50) DEFAULT NULL,
store_id tinyint unsigned NOT NULL,
active tinyint(1) NOT NULL DEFAULT '1',
username varchar(16) NOT NULL,
password varchar(40) DEFAULT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (staff_id)
) auto_increment=2;$$

CREATE TABLE sakila.store (
store_id tinyint unsigned NOT NULL AUTO_INCREMENT,
manager_staff_id tinyint unsigned NOT NULL,
address_id smallint unsigned NOT NULL,
last_update timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP) DEFAULT_GENERATED on update CURRENT_TIMESTAMP,
PRIMARY KEY (store_id),
CONSTRAINT idx_unique_manager UNIQUE (manager_staff_id)
) auto_increment=2;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX idx_actor_last_name
USING BTREE ON sakila.actor (last_name);$$

CREATE INDEX idx_fk_city_id
USING BTREE ON sakila.address (city_id);$$

CREATE SPATIAL INDEX idx_location
ON sakila.address (location);$$

CREATE INDEX idx_fk_country_id
USING BTREE ON sakila.city (country_id);$$

CREATE INDEX idx_fk_address_id
USING BTREE ON sakila.customer (address_id);$$

CREATE INDEX idx_fk_store_id
USING BTREE ON sakila.customer (store_id);$$

CREATE INDEX idx_last_name
USING BTREE ON sakila.customer (last_name);$$

CREATE INDEX idx_fk_language_id
USING BTREE ON sakila.film (language_id);$$

CREATE INDEX idx_fk_original_language_id
USING BTREE ON sakila.film (original_language_id);$$

CREATE INDEX idx_title
USING BTREE ON sakila.film (title);$$

CREATE INDEX idx_fk_film_id
USING BTREE ON sakila.film_actor (film_id);$$

CREATE FULLTEXT INDEX idx_title_description
ON sakila.film_text (title, description);$$

CREATE INDEX idx_fk_film_id
USING BTREE ON sakila.inventory (film_id);$$

CREATE INDEX idx_store_id_film_id
USING BTREE ON sakila.inventory (store_id, film_id);$$

CREATE INDEX idx_fk_customer_id
USING BTREE ON sakila.payment (customer_id);$$

CREATE INDEX idx_fk_staff_id
USING BTREE ON sakila.payment (staff_id);$$

CREATE INDEX idx_fk_customer_id
USING BTREE ON sakila.rental (customer_id);$$

CREATE INDEX idx_fk_inventory_id
USING BTREE ON sakila.rental (inventory_id);$$

CREATE INDEX idx_fk_staff_id
USING BTREE ON sakila.rental (staff_id);$$

CREATE INDEX idx_fk_address_id
USING BTREE ON sakila.staff (address_id);$$

CREATE INDEX idx_fk_store_id
USING BTREE ON sakila.staff (store_id);$$

CREATE INDEX idx_fk_address_id
USING BTREE ON sakila.store (address_id);$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE sakila.address
ADD CONSTRAINT fk_address_city FOREIGN KEY (city_id) 
REFERENCES sakila.city (city_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.city
ADD CONSTRAINT fk_city_country FOREIGN KEY (country_id) 
REFERENCES sakila.country (country_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.customer
ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id) 
REFERENCES sakila.address (address_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.customer
ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id) 
REFERENCES sakila.store (store_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film
ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) 
REFERENCES sakila.language (language_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film
ADD CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) 
REFERENCES sakila.language (language_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film_actor
ADD CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) 
REFERENCES sakila.actor (actor_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film_actor
ADD CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) 
REFERENCES sakila.film (film_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film_category
ADD CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) 
REFERENCES sakila.category (category_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.film_category
ADD CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) 
REFERENCES sakila.film (film_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.inventory
ADD CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) 
REFERENCES sakila.film (film_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.inventory
ADD CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) 
REFERENCES sakila.store (store_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.payment
ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) 
REFERENCES sakila.customer (customer_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.payment
ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) 
REFERENCES sakila.rental (rental_id)
ON DELETE SET NULL
ON UPDATE CASCADE;$$

ALTER TABLE sakila.payment
ADD CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) 
REFERENCES sakila.staff (staff_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.rental
ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) 
REFERENCES sakila.customer (customer_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.rental
ADD CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) 
REFERENCES sakila.inventory (inventory_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.rental
ADD CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) 
REFERENCES sakila.staff (staff_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.staff
ADD CONSTRAINT fk_staff_address FOREIGN KEY (address_id) 
REFERENCES sakila.address (address_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.staff
ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) 
REFERENCES sakila.store (store_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.store
ADD CONSTRAINT fk_store_address FOREIGN KEY (address_id) 
REFERENCES sakila.address (address_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$

ALTER TABLE sakila.store
ADD CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) 
REFERENCES sakila.staff (staff_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;$$


delimiter ;
            


delimiter $$
            

-- ------------ Write CREATE-OTHER-stage scripts -----------

USE `sakila`;$$
CREATE FUNCTION sakila.get_customer_balance(p_customer_id int, p_effective_date datetime) RETURNS decimal(5,2)
DETERMINISTIC
SQL SECURITY DEFINER
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END;$$

CREATE FUNCTION sakila.inventory_held_by_customer(p_inventory_id int) RETURNS int
SQL SECURITY DEFINER
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END;$$

CREATE FUNCTION sakila.inventory_in_stock(p_inventory_id int) RETURNS tinyint
SQL SECURITY DEFINER
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END;$$

CREATE PROCEDURE sakila.film_in_stock(IN p_film_id int, IN p_store_id int, OUT p_film_count int)
SQL SECURITY DEFINER
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END;$$

CREATE PROCEDURE sakila.film_not_in_stock(IN p_film_id int, IN p_store_id int, OUT p_film_count int)
SQL SECURITY DEFINER
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id)
     INTO p_film_count;
END;$$

CREATE PROCEDURE sakila.rewards_report(IN min_monthly_purchases tinyint, IN min_dollar_amount_purchased decimal(10,2), OUT count_rewardees int)
COMMENT  'Provides a customizable report on best customers'
SQL SECURITY DEFINER
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    /* Determine start and end time periods */
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    /* Clean up */
    DROP TABLE tmpCustomer;
END;$$

CREATE TRIGGER customer_create_date BEFORE INSERT
ON sakila.customer
FOR EACH ROW
SET NEW.create_date = NOW()$$

CREATE TRIGGER del_film AFTER DELETE
ON sakila.film
FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END$$

CREATE TRIGGER ins_film AFTER INSERT
ON sakila.film
FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END$$

CREATE TRIGGER upd_film AFTER UPDATE
ON sakila.film
FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END$$

CREATE TRIGGER payment_date BEFORE INSERT
ON sakila.payment
FOR EACH ROW
SET NEW.payment_date = NOW()$$

CREATE TRIGGER rental_date BEFORE INSERT
ON sakila.rental
FOR EACH ROW
SET NEW.rental_date = NOW()$$

CREATE 
SQL SECURITY INVOKER
VIEW sakila.actor_info (actor_id, first_name, last_name, film_info) AS 
select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`sakila`.`film` `f` join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`sakila`.`actor` `a` left join `sakila`.`film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `sakila`.`film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.customer_list (ID, name, address, `zip code`, phone, city, country, notes, SID) AS 
select `cu`.`customer_id` AS `ID`,concat(`cu`.`first_name`,' ',`cu`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,if(`cu`.`active`,'active','') AS `notes`,`cu`.`store_id` AS `SID` from (((`sakila`.`customer` `cu` join `sakila`.`address` `a` on((`cu`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)))$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.film_list (FID, title, description, category, price, length, rating, actors) AS 
select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(`sakila`.`actor`.`first_name`,' ',`sakila`.`actor`.`last_name`) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.nicer_but_slower_film_list (FID, title, description, category, price, length, rating, actors) AS 
select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(concat(upper(substr(`sakila`.`actor`.`first_name`,1,1)),lower(substr(`sakila`.`actor`.`first_name`,2,length(`sakila`.`actor`.`first_name`))),' ',concat(upper(substr(`sakila`.`actor`.`last_name`,1,1)),lower(substr(`sakila`.`actor`.`last_name`,2,length(`sakila`.`actor`.`last_name`)))))) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.sales_by_film_category (category, total_sales) AS 
select `c`.`name` AS `category`,sum(`p`.`amount`) AS `total_sales` from (((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`film` `f` on((`i`.`film_id` = `f`.`film_id`))) join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `c`.`name` order by `total_sales` desc$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.sales_by_store (store, manager, total_sales) AS 
select concat(`c`.`city`,',',`cy`.`country`) AS `store`,concat(`m`.`first_name`,' ',`m`.`last_name`) AS `manager`,sum(`p`.`amount`) AS `total_sales` from (((((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`store` `s` on((`i`.`store_id` = `s`.`store_id`))) join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` `c` on((`a`.`city_id` = `c`.`city_id`))) join `sakila`.`country` `cy` on((`c`.`country_id` = `cy`.`country_id`))) join `sakila`.`staff` `m` on((`s`.`manager_staff_id` = `m`.`staff_id`))) group by `s`.`store_id` order by `cy`.`country`,`c`.`city`$$

CREATE 
SQL SECURITY DEFINER
VIEW sakila.staff_list (ID, name, address, `zip code`, phone, city, country, SID) AS 
select `s`.`staff_id` AS `ID`,concat(`s`.`first_name`,' ',`s`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,`s`.`store_id` AS `SID` from (((`sakila`.`staff` `s` join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)))$$


delimiter ;
            

