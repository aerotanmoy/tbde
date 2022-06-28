ALTER TABLE public.derivatives_stg SET UNLOGGED;
TRUNCATE TABLE public.derivatives_stg;

DROP INDEX IF EXISTS indx001;