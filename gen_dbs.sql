-- turn off parallel queries
ALTER SYSTEM SET max_parallel_workers_per_gather = 0;
SELECT pg_reload_conf();

-- t1 table has 10e7 rows
CREATE TABLE IF NOT EXISTS t1 AS
SELECT a.id AS id,
       CAST(a.id - FLOOR(random() * a.id) AS INTEGER) AS parent_id,
       SUBSTR(md5(random()::text), 0, 30) AS name
FROM generate_series(1, 10000000) a(id);

-- t2 table has 5*10e6 rows
CREATE TABLE IF NOT EXISTS t2 AS
SELECT row_number() OVER() AS id,
       id AS t_id,
       TO_CHAR(date_trunc('day', now() - random() * INTERVAL '1 year'), 'yyyymmdd') AS day
FROM t1
ORDER BY random()
LIMIT 5000000;