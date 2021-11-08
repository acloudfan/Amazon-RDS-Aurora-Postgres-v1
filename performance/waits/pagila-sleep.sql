BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(12);
    COMMIT;
END;

