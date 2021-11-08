BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(random(1,10));
    COMMIT;
END;

