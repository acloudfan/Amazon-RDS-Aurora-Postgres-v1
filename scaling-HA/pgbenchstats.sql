-- Stored proced
CREATE OR REPLACE FUNCTION pgbenchstats_avg() 
RETURNS TABLE(time_epoch_com int, secs int, tps int, lat int)
LANGUAGE plpgsql

AS $$

  DECLARE min_time_epoch int;

BEGIN

  SELECT min(time_epoch) INTO min_time_epoch 
  FROM pgbenchstats;

  RETURN QUERY
  SELECT time_epoch AS time_epoch_com,(time_epoch - min_time_epoch) AS secs , count(time_epoch)::int AS tps, round(avg(time)/1000)::int AS lat
  FROM pgbenchstats 
  GROUP BY time_epoch
  ORDER BY secs;

END;

$$;