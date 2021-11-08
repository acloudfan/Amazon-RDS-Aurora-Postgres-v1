BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(1);
    COMMIT;
END;

