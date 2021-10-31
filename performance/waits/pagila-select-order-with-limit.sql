BEGIN;
    SELECT title, description FROM film ORDER BY description LIMIT 1;
END;