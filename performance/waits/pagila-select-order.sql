BEGIN;
    SELECT title, description FROM film ORDER BY description;
END;