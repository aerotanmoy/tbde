SET max_parallel_workers_per_gather = 4;
SET work_mem = 512 MB;
SET min_parallel_table_scan_size = 256 MB;
SET min_parallel_index_scan_size = 64 MB;
\set path :v1
TRUNCATE TABLE public.derivatives_rw;
ALTER TABLE public.derivatives_rw SET UNLOGGED;
COPY public.derivatives_rw FROM :'path' CSV;