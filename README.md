# tbde
**True B DE Requirement**

Scripts :
A) **process**.sh -- Orchestrates the ingestion pipeline which performs the following steps:
      1) **Extract Layer** : manipulation of raw files for inclusion of symbol in data
      2) **Load Layer** :  insertion of manipulated file to postgres Landing table --> public.derivatives_rw
      3) **Transform Layer** : Generation of timestamp and expiry_date columns in staging table --> public.derivatives_stg
B) **copyscript**.sql -- Script to ingest manipulated raw data to public.derivatives_rw
C) **transformscript**.sql -- populates the public.derivatives_stg to Generate timestamp and expiry_date columns

Execution Command :
sh /home/tbde/script/process.sh &

Logs:
Duration for  File Manipulation : 202 sec
/home/tbde/script
SET
SET
SET
SET
TRUNCATE TABLE
ALTER TABLE
COPY 87990079
Duration for  File Ingestion : 199 sec
/home/tbde/script
Overall  Duration : 401 sec
SET
SET
SET
SET
ALTER TABLE
TRUNCATE TABLE
DROP INDEX
CREATE INDEX
INSERT 0 87990079
ALTER TABLE
CREATE INDEX
Duration for  File Transformation : 1144 sec
Overall  Duration : 1545 sec


Tasks:
Performance Optimization to reduce ingestion <5 min.
-- Tried pg_futter usage but did not scale up
-- Tried installing pg_bulkload -- However inbuild gcc dependencies giving installation error
-- Usage of Copy command for multiple split files -- Insertion time 600 sec
-- Usage of Copy command for 3 merged files -- Facing data insertion error during parallel threaded merge 
-- Usage of Copy command for single merged file -- Reduced cycle time to 180 sec on inclusion of Unlogged table state
Yet to try since everything is licensed product
-- Timescale DB installation and upgrade of Postgres
-- Postgres Pro 
-- Swarm 64 DA https://swarm64.com/

-- Current disk io is not performance compliant. Usage of better instance.  
-- Also increase in number of vcpu nodes to have more parallel compute power will reduce overall ingestion time

-- Another possible approach is redesigning the architecture by forking based on filetypes and have parallel ingestion flows. --> Effort required


1)Calculate the relative change in ltp between NIFTY22JANFUT and BANKNIFTY22JANFUT symbols for an input duration. 

SELECT symbol, ltp , lead(ltp,1)  over(partition by symbol ORDER BY DATE(exectimes))  as prev_ltp, exectimes,
lead(exectimes,1)  over(partition by symbol,DATE(exectimes) ORDER BY DATE(exectimes)) as prev_exectimes,
100*(ltp - lead(ltp,1)  over(partition by symbol,DATE(exectimes) ORDER BY DATE(exectimes)))/lead(ltp,1)  over(partition by symbol ORDER BY DATE(exectimes)) as rel_dly_ltp_change from public.derivatives_stg where symbol IN ('NIFTY22JANFUT','BANKNIFTY22JANFUT') limit 5;

      symbol       |   ltp    | prev_ltp |      exectimes      |   prev_exectimes    |   rel_dly_ltp_change    
-------------------+----------+----------+---------------------+---------------------+-------------------------
 BANKNIFTY22JANFUT | 35784.50 | 35789.30 | 2022-01-03 09:17:18 | 2022-01-03 09:17:16 | -0.01341182979270340577
 BANKNIFTY22JANFUT | 35789.30 | 35783.45 | 2022-01-03 09:17:16 | 2022-01-03 09:17:13 |  0.01634833980513337870
 BANKNIFTY22JANFUT | 35783.45 | 35782.10 | 2022-01-03 09:17:13 | 2022-01-03 09:17:11 |  0.00377283613873976094
 BANKNIFTY22JANFUT | 35782.10 | 35785.00 | 2022-01-03 09:17:11 | 2022-01-03 09:17:09 | -0.00810395417074193098
 BANKNIFTY22JANFUT | 35785.00 | 35784.05 | 2022-01-03 09:17:09 | 2022-01-03 09:17:06 |  0.00265481408616408707
 

2) Writing a query to create day wise OHLC candles from tick by tick data

3) Create Visualisation in a stack of your choice which plots percentage change of ltp,ltq and oi 
-- Pending

4) Write a script to ensure data quality, the script should find any instrument that has missing data for more than 1 hour in a day


