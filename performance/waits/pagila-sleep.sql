BEGIN;
    LOCK TABLE film;
    pg_sleep(1);
    COMMIT;
END;

