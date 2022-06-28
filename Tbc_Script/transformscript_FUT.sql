BEGIN;
SET work_mem = '512MB';
SET max_parallel_workers = 6;
SET max_parallel_workers_per_gather = 8;
SET parallel_leader_participation = off;
SET parallel_tuple_cost = 0;
SET parallel_setup_cost = 0;
SET min_parallel_table_scan_size = 0;
Insert into public.derivatives_stg (symbol,exectimes,ltp,ltq,oi,bid,bid_qty,ask,ask_qty,expiry_date)
select symbol, TO_TIMESTAMP(concat(date,' ',time),'YYYYMMDD HH24:MI:SS') as exectimes, ltp,ltq,oi,bid,bid_qty,ask,ask_qty, 
CASE WHEN symbol like '%FUT' then to_date(SUBSTRING(symbol, length(symbol) - 7, length(symbol) - 5),'YYMON') else to_date(SUBSTRING( symbol,'([0-9]{1,6})'),'YYMMDD') end as expiry_date 
from public.derivatives_rw
WHERE symbol like '%FUT';

