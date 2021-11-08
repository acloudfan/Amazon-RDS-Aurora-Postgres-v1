\set sleep_seconds random(5, 15)

BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(:sleep_seconds);
    COMMIT;
END;

