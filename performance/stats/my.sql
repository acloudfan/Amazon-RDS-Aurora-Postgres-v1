DROP SEQUENCE pagila.film_seq
DROP TABLE pagila.film;

CREATE SEQUENCE IF NOT EXISTS pagila.film_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;


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

--- Information on actors

DROP TABLE pagila.actor;
DROP SEQUENCE pagila.actor_seq

CREATE SEQUENCE IF NOT EXISTS pagila.actor_seq
INCREMENT BY 1
START WITH 1
NO CYCLE;

CREATE TABLE pagila.actor(
    actor_id SMALLINT NOT NULL DEFAULT nextval('pagila.actor_seq'),
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
)
        WITH (
        OIDS=FALSE
        );