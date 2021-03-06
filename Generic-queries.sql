---Get version of postgres
select version();
---To get all the details about postgresql (here to get total number of rows in all tables)
SELECT schemaname, relname, n_live_tup FROM pg_stat_user_tables where schemaname = 'code' ORDER BY n_live_tup DESC;

-- Show database size_
SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database;
SELECT pg_size_pretty(pg_database_size('indsolv'));

---Show size of table size_
SELECT pg_size_pretty(pg_relation_size('indsolv.address'));

---Reload configuration
select pg_reload_conf();

-- To get last commit/transaction Date of table
select pg_xact_commit_timestamp(xmin), * from indsolv.address

-- To get last commit/transaction Date of column
SELECT pg_xact_commit_timestamp(xmin), * FROM YOUR_TABLE_NAME where COLUMN_NAME=VALUE;

-- Show default date style
SHOW datestyle;

--- Get current date
SELECT current_date;

--- Change date style (postgres, ISO, SQL)
SET datestyle TO postgres, dmy;
SET datestyle TO postgres, mdy;
SET datestyle TO ISO, dmy;
---Get all scehma name
select schema_name from information_schema.schemata
select nspname from pg_catalog.pg_namespace;
---list of schema with sizes
SELECT schema_name, pg_size_pretty(sum(table_size)::bigint) as "disk space", (sum(table_size) / pg_database_size(current_database())) * 100 as "percent" FROM (SELECT pg_catalog.pg_namespace.nspname as schema_name, pg_relation_size(pg_catalog.pg_class.oid) as table_size FROM   pg_catalog.pg_class JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid) t GROUP BY schema_name ORDER BY schema_name
---DELETE All the tables from schema
SELECT 'TRUNCATE ' || input_table_name || ' CASCADE;' AS truncate_query FROM(SELECT table_schema || '.' || table_name AS input_table_name FROM information_schema.tables WHERE table_schema NOT IN ('pg_catalog', 'information_schema') AND table_schema NOT LIKE 'pg_toast%') AS information;
cd ...
--- List all the installed postgres languages
SELECT lanname FROM pg_language
---Install python language
CREATE EXTENSION plpython2u;
CREATE EXTENSION plpython3u;
--Generate HTML report
./psql -d indsolv -H -c "SELECT category, count(*) As num_per_cat FROM pg_settings WHERE category LIKE '%Query%' GROUP BY category ORDER BY category;" -o test.html
--To get a glimpse inside the tables controlling all of your agents and jobs, connect to the postgres database and execute the query
SELECT c.relname As table_name, d.description
FROM pg_class As c
INNER JOIN pg_namespace n ON n.oid = c.relnamespace
INNER JOIN pg_description As d ON d.objoid = c.oid AND d.objsubid = 0
WHERE n.nspname = 'pgagent'
ORDER BY c.relname;
----List log step results from today
SELECT j.jobname, s.jstname, l.jslstart,l.jslduration, l.jsloutput
FROM pgagent.pga_jobsteplog As l
INNER JOIN pgagent.pga_jobstep As s ON s.jstid = l.jsljstid
INNER JOIN pgagent.pga_job As j ON j.jobid = s.jstjobid
WHERE jslstart > CURRENT_DATE
ORDER BY j.jobname, s.jstname, l.jslstart DESC;
---ILIKE for Case Insensitive Search
SELECT tract_name FROM census.lu_tracts WHERE tract_name ILIKE '%duke%';
---Kill Session
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE
    -- don't kill my own connection!
   pid <> pg_backend_pid()
    -- don't kill the connections to other databases
   AND
	datname = 'indsolv';

--Database hit ratio
select datname, (1.0*blks_hit)/(blks_read+blks_hit) AS ratio from pg_stat_database where blks_read>0;

--Check temporary file size
select datname, temp_files, pg_size_pretty(temp_bytes) from pg_stat_database;

--Look for conflicts/deadlocks
select * from pg_stat_database_conflicts;
--Stats activity
select * from pg_stat_activity;
--Are my indexes beign used?
select * from pg_stat_user_indexes;
select * from pg_stat_user_tables;
select * from pg_stat_all_indexes;
--Not used indexes
select * from pg_stat_user_indexes where idx_scan =0
