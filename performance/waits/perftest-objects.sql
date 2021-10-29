--This is would create the test tables
--Schema with the name perftest must be created
--prior to running this script

\set TOTAL_SIZE 100000

DROP SCHEMA  IF EXISTS  perftest CASCADE;

CREATE SCHEMA perftest;

set search_path to 'perftest';

--Table for update test
CREATE TABLE perftest.updtable (id  int, sometext  varchar, somenumber int);


INSERT INTO updtable(id, sometext,somenumber)
SELECT generate_series(1, :TOTAL_SIZE) AS id, md5(random()::text) AS sometext, floor(random()*10::int) AS somenumber;


--Table for contention test
CREATE TABLE perftest.voting (id int, candidate varchar(100), vote_count  int);
INSERT INTO perftest.voting VALUES(0,'Harry Potter & Chamber of Secrets', 0);
INSERT INTO perftest.voting VALUES(1,'Harry Potter and the Half-Blood Prince', 0);
INSERT INTO perftest.voting VALUES(2,'Harry Potter and the Sorcerers Stone', 0);
INSERT INTO perftest.voting VALUES(3,'Harry Potter and the Prisoner of Azkaban', 0);

--Function to update the rows in a predefined batch
CREATE FUNCTION update_updtable(totalrows int, batchstart int, batchend int) RETURNS integer
    language  plpgsql
AS 
$$
DECLARE 
    row_id   integer;
BEGIN
        
    IF batchend - batchstart < 0 THEN
        RAISE EXCEPTION  'Batchend < Batchstart  %  !!!', (batchend - batchstart);
    END IF;
    
    row_id := batchstart;
    
    WHILE row_id <= batchend LOOP
        UPDATE perftest.updtable SET somenumber=(somenumber +1) WHERE id=row_id;
        row_id = row_id + 1;
    END LOOP;
    
    
    RETURN (batchend - batchstart + 1);

END
$$;


--Function to update ALL the rows 
CREATE FUNCTION update_updtable_allrows(totalrows int, batchsize int) RETURNS integer
    language  plpgsql
AS 
$$
DECLARE 
    total_batches   integer;
    batchstart integer;
    batchend   integer;
    dummy      integer;
BEGIN
        
    IF batchsize < 1 THEN
        RAISE EXCEPTION  'Batchsize < 1  %  !!!', batchsize;
    END IF;
    
    total_batches = floor( totalrows / batchsize) + 1;
    
    
    FOR ctr IN 1..total_batches LOOP

        batchstart := (ctr-1)*batchsize + 1;
        batchend := batchstart + batchsize  - 1;
        
            begin
            SELECT  perftest.update_updtable(totalrows, batchstart, batchend) INTO dummy;
        

    END LOOP;
    
    RETURN (batchend - batchstart + 1);

END
$$;


-- add new data

CREATE OR REPLACE FUNCTION pertest.add_new_data(IN p_num_rows int)
RETURNS void
AS
$BODY$
DECLARE

BEGIN

END;
$BODY$
LANGUAGE  plpgsql;