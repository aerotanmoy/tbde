SET max_parallel_workers_per_gather = 4;
SET work_mem = 512 MB;
SET min_parallel_table_scan_size = 256 MB;
SET min_parallel_index_scan_size = 64 MB;

TRUNCATE TABLE

ALTER TABLE public.derivatives_stg SET UNLOGGED;
TRUNCATE TABLE public.derivatives_stg;

DROP INDEX IF EXISTS indx001;

insert into public.derivatives_stg (symbol,exectimes,ltp,ltq,oi,bid,bid_qty,ask,ask_qty,expiry_date)
select symbol, TO_TIMESTAMP(concat(date,' ',time),'YYYYMMDD HH24:MI:SS') as exectimes, ltp,ltq,oi,bid,bid_qty,ask,ask_qty, CASE WHEN symbol like '%FUT' then to_date(SUBSTRING(symbol, length(symbol) - 7, length(symbol) - 5),'YYMON') else to_date(SUBSTRING( symbol,'([0-9]{1,6})'),'YYMMDD') end as expiry_date from public.derivatives_rw;

ALTER TABLE public.derivatives_stg SET LOGGED;

create index indx001 on public.derivatives_stg ( symbol );
