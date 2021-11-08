\set sleep_seconds random(1, 10)

BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(:sleep_seconds);
    COMMIT;
END;

