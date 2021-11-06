--Function for inserting a film
DROP FUNCTION IF EXISTS insert_film;

-- Function to insert a film in the film table
CREATE OR REPLACE FUNCTION insert_film(IN f_num_rows int)
RETURNS void
AS
$BODY$
DECLARE
    
    v_film_id           film.film_id%TYPE;
    v_title             film.title%TYPE;
    v_description       film.title%TYPE;
    v_release_year      film.release_year%TYPE;
    v_language_id       film.language_id%TYPE;
    v_original_language_id  film.original_language_id%TYPE;
    v_rental_duration   film.rental_duration%TYPE;
    v_rental_rate       film.rental_rate%TYPE;
    v_length            film.length%TYPE;
    v_replacement_cost  film.replacement_cost%TYPE;
    v_rating            film.rating%TYPE;
    v_last_update       film.last_update%TYPE;
    v_special_features  film.special_features%TYPE;
    v_fulltext          film.fulltext%TYPE;

BEGIN
    
    FOR i IN 1..f_num_rows LOOP
    
        -- Get the next seq val
        SELECT  nextval('film_film_id_seq') INTO v_film_id;
        
        -- Get the title
        -- SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)  INTO v_title FROM generate_series(1,65)), '');
        -- v_title := CONCAT_WS('-', (v_film_id)::TEXT, v_title);
        
        v_title := 'Fixed';
        
        -- Get the description
        SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)  INTO v_description FROM generate_series(1,230)), '');
        v_description := CONCAT_WS('-', (v_film_id)::TEXT, v_description);
        
        -- Get the release year
        SELECT floor(random()*100+1931) INTO v_release_year;
        
        -- Get a random language
        SELECT language_id INTO v_language_id FROM language  ORDER BY random() LIMIT 1;
        
        -- Get a random language for v_original_language_id
        SELECT language_id INTO v_original_language_id FROM language  ORDER BY random() LIMIT 1;
        
        -- Fix the rental duration, v_rental_rate
        v_rental_duration := 3;
        v_rental_rate := 5;
        
        -- Get the length
        SELECT floor(random()*50+random()*10+80) INTO v_length;
        
        -- Get v_replacement_cost
         SELECT floor(random()*10+11) INTO v_replacement_cost ;
        
        -- Get the v_rating
        v_rating := 'PG';
         
        -- Get the time
        SELECT now() INTO v_last_update;
        
        -- v_special_features
        v_special_features := '{"Deleted Scenes","Behind the Scenes"}';
        
        -- v_fulltext
        v_fulltext := '''academi'':1 ''battl'':15 ''canadian'':20 ''dinosaur'':2 ''drama'':5 ''epic'':4 ''feminist'':8 ''mad'':11 ''must'':14 ''rocki'':21 ''scientist'':12 ''teacher'':17';
    
        -- Now insert the data
        INSERT INTO film
        VALUES(v_film_id ,
                v_title ,
                v_description   ,
                v_release_year  ,
                v_language_id   ,
                v_original_language_id ,
                v_rental_duration   ,
                v_rental_rate       ,
                v_length            ,
                v_replacement_cost  ,
                v_rating            ,
                v_last_update       ,
                v_special_features  ,
                v_fulltext  
        );
        
    END LOOP;
END;
$BODY$
LANGUAGE  plpgsql;


-- Function to update Film description 
DROP FUNCTION IF EXISTS update_film_description;

CREATE OR REPLACE FUNCTION update_film_description(IN p_num_rows int)
RETURNS void
AS
$BODY$
DECLARE
    v_min_film_id   film.film_id%TYPE;
    v_max_film_id   film.film_id%TYPE;
    v_txn_film_id   film.film_id%TYPE;
    v_ctr           INT DEFAULT 1;
    v_new_description      film.title%TYPE;
BEGIN

    -- Get the min & max for the film
    SELECT  max(film_id),min(film_id) into v_min_film_id, v_max_film_id from film;
    
    
    WHILE v_ctr <= p_num_rows  LOOP
    
        v_txn_film_id := floor(random()*(v_max_film_id-v_min_film_id+1)) + v_min_film_id;
        
        SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)  INTO v_new_description FROM generate_series(1,230)), '');
        v_new_description := CONCAT_WS('-', (v_txn_film_id)::TEXT, v_new_description);
        
        UPDATE film SET description = v_new_description WHERE film_id=v_txn_film_id;
            
        v_ctr := v_ctr + 1;
    END LOOP;
    
END;
$BODY$
LANGUAGE  plpgsql;


-- Function to update common film_id - Film description 
DROP FUNCTION IF EXISTS update_common_id_film_description;

CREATE OR REPLACE FUNCTION update_common_id_film_description()
RETURNS void
AS
$BODY$
DECLARE
    v_min_film_id           film.film_id%TYPE;
    v_new_description       film.title%TYPE;
BEGIN

    -- Get the min_id  for the film and use it for identifying the common row
    SELECT  min(film_id) into v_min_film_id from film;
    
    -- Create a random string
    SELECT array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)  
                                    INTO v_new_description FROM generate_series(1,230)), '');
                                    
    v_new_description := CONCAT_WS('-', (v_min_film_id)::TEXT, v_new_description);
        
    -- Update the film on film_id
    UPDATE film SET description = v_new_description WHERE film_id=v_min_film_id;

    
END;
$BODY$
LANGUAGE  plpgsql;


-- Function to make the transaction sleep
DROP FUNCTION IF EXISTS select_after_sleep;

CREATE OR REPLACE FUNCTION select_after_sleep(p_sleep_factor double precision default 0.1, p_num_rows int default 5)
RETURNS void
AS
$BODY$
DECLARE
    v_random_time    double precision;
    v_title             film.title%TYPE;         
BEGIN

    -- random wait of up to 1 second
    SELECT random()*p_sleep_factor INTO v_random_time;
    
    PERFORM pg_sleep(v_random_time);
    
    SELECT title FROM film INTO v_title ORDER BY random() LIMIT p_num_rows;
    
END;
$BODY$
LANGUAGE  plpgsql;

