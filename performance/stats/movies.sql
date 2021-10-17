
-- Target Schema file created by SCT using the option to save in SQL file
-- Aurora PostgreSQL Compatible

-- ------------ Write DROP-TRIGGER-stage scripts -----------

DROP TRIGGER IF EXISTS customer_create_date
ON pagila.customer;



DROP TRIGGER IF EXISTS del_film
ON pagila.film;



DROP TRIGGER IF EXISTS ins_film
ON pagila.film;



DROP TRIGGER IF EXISTS upd_film
ON pagila.film;



DROP TRIGGER IF EXISTS payment_date
ON pagila.payment;



DROP TRIGGER IF EXISTS rental_date
ON pagila.rental;



-- ------------ Write DROP-FUNCTION-stage scripts -----------

DROP FUNCTION IF EXISTS pagila.get_customer_balance( INTEGER,  TIMESTAMP WITHOUT TIME ZONE);



DROP FUNCTION IF EXISTS pagila.inventory_held_by_customer( INTEGER);



DROP FUNCTION IF EXISTS pagila.inventory_in_stock( INTEGER);



DROP FUNCTION IF EXISTS pagila.customer_create_date$customer();



DROP FUNCTION IF EXISTS pagila.del_film$film();



DROP FUNCTION IF EXISTS pagila.ins_film$film();



DROP FUNCTION IF EXISTS pagila.payment_date$payment();



DROP FUNCTION IF EXISTS pagila.rental_date$rental();



DROP FUNCTION IF EXISTS pagila.upd_film$film();



-- ------------ Write DROP-PROCEDURE-stage scripts -----------

DROP ROUTINE IF EXISTS pagila.film_in_stock( INTEGER,  INTEGER, INOUT INTEGER, INOUT refcursor);



DROP ROUTINE IF EXISTS pagila.film_not_in_stock( INTEGER,  INTEGER, INOUT INTEGER, INOUT refcursor);



DROP ROUTINE IF EXISTS pagila.rewards_report( SMALLINT,  NUMERIC, INOUT INTEGER, INOUT refcursor, INOUT refcursor, INOUT refcursor);



-- ------------ Write DROP-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE pagila.address DROP CONSTRAINT fk_address_city;



ALTER TABLE pagila.city DROP CONSTRAINT fk_city_country;



ALTER TABLE pagila.customer DROP CONSTRAINT fk_customer_address;



ALTER TABLE pagila.customer DROP CONSTRAINT fk_customer_store;



ALTER TABLE pagila.film DROP CONSTRAINT fk_film_language;



ALTER TABLE pagila.film DROP CONSTRAINT fk_film_language_original;



ALTER TABLE pagila.film_actor DROP CONSTRAINT fk_film_actor_actor;



ALTER TABLE pagila.film_actor DROP CONSTRAINT fk_film_actor_film;



ALTER TABLE pagila.film_category DROP CONSTRAINT fk_film_category_category;



ALTER TABLE pagila.film_category DROP CONSTRAINT fk_film_category_film;



ALTER TABLE pagila.inventory DROP CONSTRAINT fk_inventory_film;



ALTER TABLE pagila.inventory DROP CONSTRAINT fk_inventory_store;



ALTER TABLE pagila.payment DROP CONSTRAINT fk_payment_customer;



ALTER TABLE pagila.payment DROP CONSTRAINT fk_payment_rental;



ALTER TABLE pagila.payment DROP CONSTRAINT fk_payment_staff;



ALTER TABLE pagila.rental DROP CONSTRAINT fk_rental_customer;



ALTER TABLE pagila.rental DROP CONSTRAINT fk_rental_inventory;



ALTER TABLE pagila.rental DROP CONSTRAINT fk_rental_staff;



ALTER TABLE pagila.staff DROP CONSTRAINT fk_staff_address;



ALTER TABLE pagila.staff DROP CONSTRAINT fk_staff_store;



ALTER TABLE pagila.store DROP CONSTRAINT fk_store_address;



ALTER TABLE pagila.store DROP CONSTRAINT fk_store_staff;



-- ------------ Write DROP-CONSTRAINT-stage scripts -----------

ALTER TABLE pagila.actor DROP CONSTRAINT pk_actor;



ALTER TABLE pagila.address DROP CONSTRAINT pk_address;



ALTER TABLE pagila.category DROP CONSTRAINT pk_category;



ALTER TABLE pagila.city DROP CONSTRAINT pk_city;



ALTER TABLE pagila.country DROP CONSTRAINT pk_country;



ALTER TABLE pagila.customer DROP CONSTRAINT pk_customer;



ALTER TABLE pagila.film DROP CONSTRAINT pk_film;



ALTER TABLE pagila.film_actor DROP CONSTRAINT pk_film_actor;



ALTER TABLE pagila.film_category DROP CONSTRAINT pk_film_category;



ALTER TABLE pagila.film_text DROP CONSTRAINT pk_film_text;



ALTER TABLE pagila.inventory DROP CONSTRAINT pk_inventory;



ALTER TABLE pagila.language DROP CONSTRAINT pk_language;



ALTER TABLE pagila.payment DROP CONSTRAINT pk_payment;



ALTER TABLE pagila.rental DROP CONSTRAINT pk_rental;



ALTER TABLE pagila.rental DROP CONSTRAINT rental_date_rental;



ALTER TABLE pagila.staff DROP CONSTRAINT pk_staff;



ALTER TABLE pagila.store DROP CONSTRAINT idx_unique_manager_store;



ALTER TABLE pagila.store DROP CONSTRAINT pk_store;



-- ------------ Write DROP-INDEX-stage scripts -----------

DROP INDEX IF EXISTS pagila.idx_actor_last_name_actor;



DROP INDEX IF EXISTS pagila.idx_fk_city_id_address;



DROP INDEX IF EXISTS pagila.idx_location_address;



DROP INDEX IF EXISTS pagila.idx_fk_country_id_city;



DROP INDEX IF EXISTS pagila.idx_fk_address_id_customer;



DROP INDEX IF EXISTS pagila.idx_fk_store_id_customer;



DROP INDEX IF EXISTS pagila.idx_last_name_customer;



DROP INDEX IF EXISTS pagila.idx_fk_language_id_film;



DROP INDEX IF EXISTS pagila.idx_fk_original_language_id_film;



DROP INDEX IF EXISTS pagila.idx_title_film;



DROP INDEX IF EXISTS pagila.idx_fk_film_id_film_actor;



DROP INDEX IF EXISTS pagila.idx_title_description_film_text;



DROP INDEX IF EXISTS pagila.idx_fk_film_id_inventory;



DROP INDEX IF EXISTS pagila.idx_store_id_film_id_inventory;



DROP INDEX IF EXISTS pagila.idx_fk_customer_id_payment;



DROP INDEX IF EXISTS pagila.idx_fk_staff_id_payment;



DROP INDEX IF EXISTS pagila.idx_fk_customer_id_rental;



DROP INDEX IF EXISTS pagila.idx_fk_inventory_id_rental;



DROP INDEX IF EXISTS pagila.idx_fk_staff_id_rental;



DROP INDEX IF EXISTS pagila.idx_fk_address_id_staff;



DROP INDEX IF EXISTS pagila.idx_fk_store_id_staff;



DROP INDEX IF EXISTS pagila.idx_fk_address_id_store;



-- ------------ Write DROP-VIEW-stage scripts -----------

DROP VIEW IF EXISTS pagila.actor_info;



DROP VIEW IF EXISTS pagila.customer_list;



DROP VIEW IF EXISTS pagila.film_list;



DROP VIEW IF EXISTS pagila.nicer_but_slower_film_list;



DROP VIEW IF EXISTS pagila.sales_by_film_category;



DROP VIEW IF EXISTS pagila.sales_by_store;



DROP VIEW IF EXISTS pagila.staff_list;



-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS pagila.actor;



DROP TABLE IF EXISTS pagila.address;



DROP TABLE IF EXISTS pagila.category;



DROP TABLE IF EXISTS pagila.city;



DROP TABLE IF EXISTS pagila.country;



DROP TABLE IF EXISTS pagila.customer;



DROP TABLE IF EXISTS pagila.film;



DROP TABLE IF EXISTS pagila.film_actor;



DROP TABLE IF EXISTS pagila.film_category;



DROP TABLE IF EXISTS pagila.film_text;



DROP TABLE IF EXISTS pagila.inventory;



DROP TABLE IF EXISTS pagila.language;



DROP TABLE IF EXISTS pagila.payment;



DROP TABLE IF EXISTS pagila.rental;



DROP TABLE IF EXISTS pagila.staff;



DROP TABLE IF EXISTS pagila.store;



-- ------------ Write DROP-TYPE-stage scripts -----------

DROP TYPE IF EXISTS pagila.rating_enum;



-- ------------ Write DROP-SEQUENCE-stage scripts -----------

DROP SEQUENCE IF EXISTS pagila.actor_seq;



DROP SEQUENCE IF EXISTS pagila.address_seq;



DROP SEQUENCE IF EXISTS pagila.category_seq;



DROP SEQUENCE IF EXISTS pagila.city_seq;



DROP SEQUENCE IF EXISTS pagila.country_seq;



DROP SEQUENCE IF EXISTS pagila.customer_seq;



DROP SEQUENCE IF EXISTS pagila.film_seq;



DROP SEQUENCE IF EXISTS pagila.inventory_seq;



DROP SEQUENCE IF EXISTS pagila.language_seq;



DROP SEQUENCE IF EXISTS pagila.payment_seq;



DROP SEQUENCE IF EXISTS pagila.rental_seq;



DROP SEQUENCE IF EXISTS pagila.staff_seq;



DROP SEQUENCE IF EXISTS pagila.store_seq;



-- ------------ Write DROP-DATABASE-stage scripts -----------

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS pagila;



-- ------------ Write CREATE-SEQUENCE-stage scripts -----------

CREATE SEQUENCE IF NOT EXISTS pagila.actor_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.address_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.category_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.city_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.country_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.customer_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.film_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.inventory_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.language_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.payment_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.rental_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.staff_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



CREATE SEQUENCE IF NOT EXISTS pagila.store_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;



-- ------------ Write CREATE-TYPE-stage scripts -----------

CREATE TYPE pagila.rating_enum AS ENUM
('G','PG','PG-13','R','NC-17');



-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE pagila.actor(
    actor_id SMALLINT NOT NULL DEFAULT nextval('pagila.actor_seq'),
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.address(
    address_id SMALLINT NOT NULL DEFAULT nextval('pagila.address_seq'),
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50) DEFAULT NULL,
    district VARCHAR(20) NOT NULL,
    city_id SMALLINT NOT NULL,
    postal_code VARCHAR(10) DEFAULT NULL,
    phone VARCHAR(20) NOT NULL,
    location VARCHAR(8000) NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.category(
    category_id SMALLINT NOT NULL DEFAULT nextval('pagila.category_seq'),
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.city(
    city_id SMALLINT NOT NULL DEFAULT nextval('pagila.city_seq'),
    city VARCHAR(50) NOT NULL,
    country_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.country(
    country_id SMALLINT NOT NULL DEFAULT nextval('pagila.country_seq'),
    country VARCHAR(50) NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.customer(
    customer_id SMALLINT NOT NULL DEFAULT nextval('pagila.customer_seq'),
    store_id SMALLINT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50) DEFAULT NULL,
    address_id SMALLINT NOT NULL,
    active SMALLINT NOT NULL DEFAULT 1,
    create_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.film(
    film_id SMALLINT NOT NULL DEFAULT nextval('pagila.film_seq'),
    title VARCHAR(128) NOT NULL,
    description TEXT DEFAULT NULL,
    release_year SMALLINT DEFAULT NULL,
    language_id SMALLINT NOT NULL,
    original_language_id SMALLINT DEFAULT NULL,
    rental_duration SMALLINT NOT NULL DEFAULT 3,
    rental_rate NUMERIC(4,2) NOT NULL DEFAULT 4.99,
    length SMALLINT DEFAULT NULL,
    replacement_cost NUMERIC(5,2) NOT NULL DEFAULT 19.99,
    rating sakila.rating_enum DEFAULT 'G',
    special_features VARCHAR(8000),
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.film_actor(
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.film_category(
    film_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.film_text(
    film_id SMALLINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT DEFAULT NULL
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.inventory(
    inventory_id INTEGER NOT NULL DEFAULT nextval('pagila.inventory_seq'),
    film_id SMALLINT NOT NULL,
    store_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.language(
    language_id SMALLINT NOT NULL DEFAULT nextval('pagila.language_seq'),
    name CHAR(20) NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.payment(
    payment_id SMALLINT NOT NULL DEFAULT nextval('pagila.payment_seq'),
    customer_id SMALLINT NOT NULL,
    staff_id SMALLINT NOT NULL,
    rental_id INTEGER DEFAULT NULL,
    amount NUMERIC(5,2) NOT NULL,
    payment_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.rental(
    rental_id INTEGER NOT NULL DEFAULT nextval('pagila.rental_seq'),
    rental_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    inventory_id INTEGER NOT NULL,
    customer_id SMALLINT NOT NULL,
    return_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    staff_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.staff(
    staff_id SMALLINT NOT NULL DEFAULT nextval('pagila.staff_seq'),
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address_id SMALLINT NOT NULL,
    picture BYTEA DEFAULT NULL,
    email VARCHAR(50) DEFAULT NULL,
    store_id SMALLINT NOT NULL,
    active SMALLINT NOT NULL DEFAULT 1,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(40) DEFAULT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE pagila.store(
    store_id SMALLINT NOT NULL DEFAULT nextval('pagila.store_seq'),
    manager_staff_id SMALLINT NOT NULL,
    address_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT 'epoch'::TIMESTAMP
)
        WITH (
        OIDS=FALSE
        );



-- ------------ Write CREATE-VIEW-stage scripts -----------

CREATE OR REPLACE  VIEW pagila.actor_info (actor_id, first_name, last_name, film_info) AS
/* [8811 - Severity CRITICAL - PostgreSQL doesn't support the GROUP_CONCAT function. Create a user-defined function.]
select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`sakila`.`film` `f` join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`sakila`.`actor` `a` left join `sakila`.`film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `sakila`.`film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name` */
BEGIN
END;



CREATE OR REPLACE  VIEW pagila.customer_list (id, name, address, "zip code", phone, city, country, notes, sid) AS
SELECT
    cu.customer_id AS id, CONCAT(cu.first_name, ' ', cu.last_name) AS name, a.address AS address, a.postal_code AS "zip code", a.phone AS phone, pagila.city.city AS city, pagila.country.country AS country,
    CASE (cu.active)
        WHEN TRUE THEN 'active'
        ELSE ''
    END AS notes, cu.store_id AS sid
    FROM (((pagila.customer AS cu
    JOIN pagila.address AS a
        ON ((cu.address_id = a.address_id)))
    JOIN pagila.city
        ON ((a.city_id = pagila.city.city_id)))
    JOIN pagila.country
        ON ((pagila.city.country_id = pagila.country.country_id)));



CREATE OR REPLACE  VIEW pagila.film_list (fid, title, description, category, price, length, rating, actors) AS
/* [8851 - Severity CRITICAL - PostgreSQL doesn't support use of the aggregate functions with other fields without GROUP BY clause. Perform a manual conversion.]
select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(`sakila`.`actor`.`first_name`,' ',`sakila`.`actor`.`last_name`) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name` */
BEGIN
END;



CREATE OR REPLACE  VIEW pagila.nicer_but_slower_film_list (fid, title, description, category, price, length, rating, actors) AS
/* [8851 - Severity CRITICAL - PostgreSQL doesn't support use of the aggregate functions with other fields without GROUP BY clause. Perform a manual conversion.]
select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(concat(upper(substr(`sakila`.`actor`.`first_name`,1,1)),lower(substr(`sakila`.`actor`.`first_name`,2,length(`sakila`.`actor`.`first_name`))),' ',concat(upper(substr(`sakila`.`actor`.`last_name`,1,1)),lower(substr(`sakila`.`actor`.`last_name`,2,length(`sakila`.`actor`.`last_name`)))))) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name` */
BEGIN
END;



CREATE OR REPLACE  VIEW pagila.sales_by_film_category (category, total_sales) AS
SELECT
    c.name AS category, SUM(p.amount) AS total_sales
    FROM (((((pagila.payment AS p
    JOIN pagila.rental AS r
        ON ((p.rental_id = r.rental_id)))
    JOIN pagila.inventory AS i
        ON ((r.inventory_id = i.inventory_id)))
    JOIN pagila.film AS f
        ON ((i.film_id = f.film_id)))
    JOIN pagila.film_category AS fc
        ON ((f.film_id = fc.film_id)))
    JOIN pagila.category AS c
        ON ((fc.category_id = c.category_id)))
    GROUP BY c.name
    ORDER BY total_sales DESC NULLS FIRST;



CREATE OR REPLACE  VIEW pagila.sales_by_store (store, manager, total_sales) AS
SELECT
    CONCAT(c.city, ',', cy.country) AS store, CONCAT(m.first_name, ' ', m.last_name) AS manager, SUM(p.amount) AS total_sales
    FROM (((((((pagila.payment AS p
    JOIN pagila.rental AS r
        ON ((p.rental_id = r.rental_id)))
    JOIN pagila.inventory AS i
        ON ((r.inventory_id = i.inventory_id)))
    JOIN pagila.store AS s
        ON ((i.store_id = s.store_id)))
    JOIN pagila.address AS a
        ON ((s.address_id = a.address_id)))
    JOIN pagila.city AS c
        ON ((a.city_id = c.city_id)))
    JOIN pagila.country AS cy
        ON ((c.country_id = cy.country_id)))
    JOIN pagila.staff AS m
        ON ((s.manager_staff_id = m.staff_id)))
    GROUP BY s.store_id
    ORDER BY LOWER(cy.country) NULLS FIRST, LOWER(c.city) NULLS FIRST;



CREATE OR REPLACE  VIEW pagila.staff_list (id, name, address, "zip code", phone, city, country, sid) AS
SELECT
    s.staff_id AS id, CONCAT(s.first_name, ' ', s.last_name) AS name, a.address AS address, a.postal_code AS "zip code", a.phone AS phone, pagila.city.city AS city, pagila.country.country AS country, s.store_id AS sid
    FROM (((pagila.staff AS s
    JOIN pagila.address AS a
        ON ((s.address_id = a.address_id)))
    JOIN pagila.city
        ON ((a.city_id = pagila.city.city_id)))
    JOIN pagila.country
        ON ((pagila.city.country_id = pagila.country.country_id)));



-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX idx_actor_last_name_actor
ON pagila.actor
USING BTREE (last_name);



CREATE INDEX idx_fk_city_id_address
ON pagila.address
USING BTREE (city_id);



CREATE INDEX idx_location_address
ON pagila.address
USING SPATIAL (location);



CREATE INDEX idx_fk_country_id_city
ON pagila.city
USING BTREE (country_id);



CREATE INDEX idx_fk_address_id_customer
ON pagila.customer
USING BTREE (address_id);



CREATE INDEX idx_fk_store_id_customer
ON pagila.customer
USING BTREE (store_id);



CREATE INDEX idx_last_name_customer
ON pagila.customer
USING BTREE (last_name);



CREATE INDEX idx_fk_language_id_film
ON pagila.film
USING BTREE (language_id);



CREATE INDEX idx_fk_original_language_id_film
ON pagila.film
USING BTREE (original_language_id);



CREATE INDEX idx_title_film
ON pagila.film
USING BTREE (title);



CREATE INDEX idx_fk_film_id_film_actor
ON pagila.film_actor
USING BTREE (film_id);



CREATE INDEX idx_title_description_film_text
ON pagila.film_text
USING FULLTEXT (title, description);



CREATE INDEX idx_fk_film_id_inventory
ON pagila.inventory
USING BTREE (film_id);



CREATE INDEX idx_store_id_film_id_inventory
ON pagila.inventory
USING BTREE (store_id, film_id);



CREATE INDEX idx_fk_customer_id_payment
ON pagila.payment
USING BTREE (customer_id);



CREATE INDEX idx_fk_staff_id_payment
ON pagila.payment
USING BTREE (staff_id);



CREATE INDEX idx_fk_customer_id_rental
ON pagila.rental
USING BTREE (customer_id);



CREATE INDEX idx_fk_inventory_id_rental
ON pagila.rental
USING BTREE (inventory_id);



CREATE INDEX idx_fk_staff_id_rental
ON pagila.rental
USING BTREE (staff_id);



CREATE INDEX idx_fk_address_id_staff
ON pagila.staff
USING BTREE (address_id);



CREATE INDEX idx_fk_store_id_staff
ON pagila.staff
USING BTREE (store_id);



CREATE INDEX idx_fk_address_id_store
ON pagila.store
USING BTREE (address_id);



-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE pagila.actor
ADD CONSTRAINT pk_actor PRIMARY KEY (actor_id);



ALTER TABLE pagila.address
ADD CONSTRAINT pk_address PRIMARY KEY (address_id);



ALTER TABLE pagila.category
ADD CONSTRAINT pk_category PRIMARY KEY (category_id);



ALTER TABLE pagila.city
ADD CONSTRAINT pk_city PRIMARY KEY (city_id);



ALTER TABLE pagila.country
ADD CONSTRAINT pk_country PRIMARY KEY (country_id);



ALTER TABLE pagila.customer
ADD CONSTRAINT pk_customer PRIMARY KEY (customer_id);



ALTER TABLE pagila.film
ADD CONSTRAINT pk_film PRIMARY KEY (film_id);



ALTER TABLE pagila.film_actor
ADD CONSTRAINT pk_film_actor PRIMARY KEY (actor_id, film_id);



ALTER TABLE pagila.film_category
ADD CONSTRAINT pk_film_category PRIMARY KEY (film_id, category_id);



ALTER TABLE pagila.film_text
ADD CONSTRAINT pk_film_text PRIMARY KEY (film_id);



ALTER TABLE pagila.inventory
ADD CONSTRAINT pk_inventory PRIMARY KEY (inventory_id);



ALTER TABLE pagila.language
ADD CONSTRAINT pk_language PRIMARY KEY (language_id);



ALTER TABLE pagila.payment
ADD CONSTRAINT pk_payment PRIMARY KEY (payment_id);



ALTER TABLE pagila.rental
ADD CONSTRAINT pk_rental PRIMARY KEY (rental_id);



ALTER TABLE pagila.rental
ADD CONSTRAINT rental_date_rental UNIQUE (rental_date, inventory_id, customer_id);



ALTER TABLE pagila.staff
ADD CONSTRAINT pk_staff PRIMARY KEY (staff_id);



ALTER TABLE pagila.store
ADD CONSTRAINT idx_unique_manager_store UNIQUE (manager_staff_id);



ALTER TABLE pagila.store
ADD CONSTRAINT pk_store PRIMARY KEY (store_id);



-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE pagila.address
ADD CONSTRAINT fk_address_city FOREIGN KEY (city_id) 
REFERENCES "pagila.city".city (city_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.city
ADD CONSTRAINT fk_city_country FOREIGN KEY (country_id) 
REFERENCES "pagila.country".country (country_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.customer
ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id) 
REFERENCES pagila.address (address_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.customer
ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id) 
REFERENCES "pagila.store".store (store_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film
ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) 
REFERENCES "pagila.language".language (language_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film
ADD CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) 
REFERENCES pagila.language (language_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film_actor
ADD CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) 
REFERENCES "pagila.actor".actor (actor_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film_actor
ADD CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) 
REFERENCES "pagila.film".film (film_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film_category
ADD CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) 
REFERENCES pagila.category (category_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.film_category
ADD CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) 
REFERENCES pagila.film (film_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.inventory
ADD CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) 
REFERENCES pagila.film (film_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.inventory
ADD CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) 
REFERENCES pagila.store (store_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.payment
ADD CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) 
REFERENCES pagila.customer (customer_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.payment
ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) 
REFERENCES "pagila.rental".rental (rental_id)
ON UPDATE CASCADE
ON DELETE SET NULL;



ALTER TABLE pagila.payment
ADD CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) 
REFERENCES "pagila.staff".staff (staff_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.rental
ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) 
REFERENCES pagila.customer (customer_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.rental
ADD CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) 
REFERENCES pagila.inventory (inventory_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.rental
ADD CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) 
REFERENCES pagila.staff (staff_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.staff
ADD CONSTRAINT fk_staff_address FOREIGN KEY (address_id) 
REFERENCES pagila.address (address_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.staff
ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) 
REFERENCES pagila.store (store_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.store
ADD CONSTRAINT fk_store_address FOREIGN KEY (address_id) 
REFERENCES pagila.address (address_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



ALTER TABLE pagila.store
ADD CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) 
REFERENCES pagila.staff (staff_id)
ON UPDATE CASCADE
ON DELETE RESTRICT;



-- ------------ Write CREATE-FUNCTION-stage scripts -----------

CREATE OR REPLACE FUNCTION pagila.get_customer_balance( par_p_customer_id INTEGER,  par_p_effective_date TIMESTAMP WITHOUT TIME ZONE)
RETURNS NUMERIC
AS
$BODY$
DECLARE
    var_v_rentfees NUMERIC(5, 2);
    var_v_overfees INTEGER;
    var_v_payments NUMERIC(5, 2);
BEGIN
    /* OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE */
    /* THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS: */
    /* 1) RENTAL FEES FOR ALL PREVIOUS RENTALS */
    /* 2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE */
    /* 3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST */
    /* 4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED */
    /* FEES PAID TO RENT THE VIDEOS INITIALLY */
    /* LATE FEES FOR PRIOR RENTALS */
    /* SUM OF PAYMENTS MADE PREVIOUSLY */
    SELECT
        COALESCE(SUM(film.rental_rate), 0)
        INTO var_v_rentfees
        FROM pagila.film, pagila.inventory, pagila.rental
        WHERE film.film_id = inventory.film_id AND inventory.inventory_id = rental.inventory_id AND rental.rental_date <= par_p_effective_date AND rental.customer_id = par_p_customer_id;
    SELECT
        COALESCE(SUM(CASE (((rental.return_date::DATE - '0001-01-01'::DATE) + 366 - (pagila.rental.rental_date::DATE - '0001-01-01'::DATE) + 366) > film.rental_duration)
            WHEN TRUE THEN (((rental.return_date::DATE - '0001-01-01'::DATE) + 366 - (pagila.rental.rental_date::DATE - '0001-01-01'::DATE) + 366) - film.rental_duration::NUMERIC)
            ELSE 0
        END), 0)
        INTO var_v_overfees
        FROM pagila.rental, pagila.inventory, pagila.film
        WHERE film.film_id = inventory.film_id AND inventory.inventory_id = rental.inventory_id AND rental.rental_date <= par_p_effective_date AND rental.customer_id = par_p_customer_id;
    SELECT
        COALESCE(SUM(payment.amount), 0)
        INTO var_v_payments
        FROM pagila.payment
        WHERE payment.payment_date <= par_p_effective_date AND payment.customer_id = par_p_customer_id;
    RETURN var_v_rentfees::NUMERIC + var_v_overfees::NUMERIC - var_v_payments::NUMERIC;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.inventory_held_by_customer( par_p_inventory_id INTEGER)
RETURNS INTEGER
AS
$BODY$
DECLARE
    var_v_customer_id INTEGER;
BEGIN
    SELECT
        customer_id
        INTO var_v_customer_id
        FROM pagila.rental
        WHERE return_date IS NULL AND inventory_id = par_p_inventory_id;
    RETURN var_v_customer_id;
    EXCEPTION
        WHEN SQLSTATE '02000' THEN
            RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.inventory_in_stock( par_p_inventory_id INTEGER)
RETURNS SMALLINT
AS
$BODY$
DECLARE
    var_v_rentals INTEGER;
    var_v_out INTEGER;
BEGIN
    /* AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE */
    /* FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED */
    SELECT
        COUNT(*)
        INTO var_v_rentals
        FROM pagila.rental
        WHERE inventory_id = par_p_inventory_id;

    IF var_v_rentals = 0 THEN
        RETURN TRUE;
    END IF;
    SELECT
        count(rental_id)
        INTO var_v_out
        FROM pagila.inventory
        LEFT OUTER JOIN pagila.rental
        USING (inventory_id)
        WHERE inventory.inventory_id = par_p_inventory_id AND rental.return_date IS NULL;

    IF var_v_out > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.customer_create_date$customer()
RETURNS trigger
AS
$BODY$
NEW.create_date := clock_timestamp()::TIMESTAMP;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.del_film$film()
RETURNS trigger
AS
$BODY$
BEGIN
    DELETE FROM pagila.film_text
        WHERE film_id = OLD.film_id;
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.ins_film$film()
RETURNS trigger
AS
$BODY$
BEGIN
    INSERT INTO pagila.film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.payment_date$payment()
RETURNS trigger
AS
$BODY$
NEW.payment_date := clock_timestamp()::TIMESTAMP;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.rental_date$rental()
RETURNS trigger
AS
$BODY$
NEW.rental_date := clock_timestamp()::TIMESTAMP;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION pagila.upd_film$film()
RETURNS trigger
AS
$BODY$
BEGIN
    IF (LOWER(OLD.title) != LOWER(NEW.title)) OR (LOWER(OLD.description) != LOWER(NEW.description)) OR (OLD.film_id != NEW.film_id) THEN
        UPDATE pagila.film_text
        SET title = title, description = description, film_id = film_id
            WHERE film_id = OLD.film_id;
    END IF;
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



-- ------------ Write CREATE-PROCEDURE-stage scripts -----------

CREATE PROCEDURE pagila.film_in_stock( par_p_film_id INTEGER,  par_p_store_id INTEGER, INOUT par_p_film_count INTEGER, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    OPEN p_refcur FOR
    SELECT
        inventory_id
        FROM pagila.inventory
        WHERE film_id = par_p_film_id AND store_id = par_p_store_id AND pagila.inventory_in_stock(inventory_id);
    /* [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
    SELECT COUNT(*)
         FROM inventory
         WHERE film_id = p_film_id
         AND store_id = p_store_id
         AND inventory_in_stock(inventory_id)
         INTO p_film_count */
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE pagila.film_not_in_stock( par_p_film_id INTEGER,  par_p_store_id INTEGER, INOUT par_p_film_count INTEGER, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    OPEN p_refcur FOR
    SELECT
        inventory_id
        FROM pagila.inventory
        WHERE film_id = par_p_film_id AND store_id = par_p_store_id AND NOT pagila.inventory_in_stock(inventory_id);
    /* [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
    SELECT COUNT(*)
         FROM inventory
         WHERE film_id = p_film_id
         AND store_id = p_store_id
         AND NOT inventory_in_stock(inventory_id)
         INTO p_film_count */
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE pagila.rewards_report( par_min_monthly_purchases SMALLINT,  par_min_dollar_amount_purchased NUMERIC, INOUT par_count_rewardees INTEGER, INOUT p_refcur refcursor, INOUT p_refcur_2 refcursor, INOUT p_refcur_3 refcursor)
AS 
$BODY$
BEGIN
    <<proc>>
    DECLARE
        var_last_month_start DATE;
        var_last_month_end DATE;
    BEGIN
        /* Some sanity checks... */
        IF par_min_monthly_purchases = 0 THEN
            OPEN p_refcur FOR
            SELECT
                'Minimum monthly purchases parameter must be > 0';
            EXIT proc;
        END IF;

        IF par_min_dollar_amount_purchased = 0.00 THEN
            OPEN p_refcur_2 FOR
            SELECT
                'Minimum monthly dollar amount purchased parameter must be > $0.00';
            EXIT proc;
        END IF;
        /* Determine start and end time periods */
        var_last_month_start := aws_mysql_ext.eDATE_SUB(clock_timestamp()::DATE::TIMESTAMP, (1)::TEXT, 'MONTH'::TEXT);
        var_last_month_start := aws_mysql_ext.eSTR_TO_DATE(CONCAT(EXTRACT (YEAR FROM var_last_month_start::TIMESTAMP), '-', date_part('MONTH', var_last_month_start::DATE), '-01')::TEXT, '%Y-%m-%d');
        var_last_month_end := aws_mysql_ext.eLAST_DAY(var_last_month_start::TIMESTAMPTZ);
        /* Create a temporary storage area for
        Customer IDs. */
        CREATE TEMPORARY TABLE tmpcustomer
        (customer_id SMALLINT NOT NULL PRIMARY KEY);
        /* Find all customers meeting the
        monthly purchase requirements */
        INSERT INTO tmpcustomer (customer_id)
        SELECT
            p.customer_id
            FROM pagila.payment AS p
            WHERE DATE(p.payment_date) BETWEEN var_last_month_start AND var_last_month_end
            GROUP BY customer_id
            HAVING SUM(p.amount) > par_min_dollar_amount_purchased AND count(customer_id) > par_min_monthly_purchases;
        /* Populate OUT parameter with count of found customers */
        /* [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
        SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees */
        /* Output ALL customer information of matching rewardees.
        Customize output as needed. */
        OPEN p_refcur_3 FOR
        SELECT
            c.*
            FROM tmpcustomer AS t
            INNER JOIN pagila.customer AS c
                ON t.customer_id = c.customer_id;
        /* Clean up */
        DROP TABLE tmpcustomer;
    END;
END;
$BODY$
LANGUAGE plpgsql;



-- ------------ Write CREATE-TRIGGER-stage scripts -----------

CREATE TRIGGER customer_create_date
BEFORE INSERT
ON pagila.customer
FOR EACH ROW
EXECUTE PROCEDURE pagila.customer_create_date$customer();



CREATE TRIGGER del_film
AFTER DELETE
ON pagila.film
FOR EACH ROW
EXECUTE PROCEDURE pagila.del_film$film();



CREATE TRIGGER ins_film
AFTER INSERT
ON pagila.film
FOR EACH ROW
EXECUTE PROCEDURE pagila.ins_film$film();



CREATE TRIGGER upd_film
AFTER UPDATE
ON pagila.film
FOR EACH ROW
EXECUTE PROCEDURE pagila.upd_film$film();



CREATE TRIGGER payment_date
BEFORE INSERT
ON pagila.payment
FOR EACH ROW
EXECUTE PROCEDURE pagila.payment_date$payment();



CREATE TRIGGER rental_date
BEFORE INSERT
ON pagila.rental
FOR EACH ROW
EXECUTE PROCEDURE pagila.rental_date$rental();





