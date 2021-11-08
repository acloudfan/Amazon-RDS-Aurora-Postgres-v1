BEGIN;
    LOCK TABLE film;
    SELECT pg_sleep(6);
    COMMIT;
END;

