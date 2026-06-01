-- #start# pg_stat_activity_query
SELECT pid,
    datname     AS database_name,
    usename     AS username,
    state,
    application_name,
    client_addr AS client_address,
    backend_type,
    query_id,
    query
FROM pg_stat_activity
WHERE state IS NOT NULL
        AND pid <> PG_BACKEND_PID()
ORDER BY query_start;
-- #end# pg_stat_activity_query


-- #start# pg_stat_activity_summary_query
SELECT COUNT(*) FILTER (WHERE state = 'active')                            AS active_connections,
    COUNT(*) FILTER (WHERE state = 'idle')                              AS idle,
    COUNT(*) FILTER (WHERE state = 'idle in transaction')               AS idle_in_transaction,
    COUNT(*) FILTER (WHERE state = 'idle in transaction (aborted)')     AS idle_in_transaction_aborted,
    COUNT(*) FILTER (WHERE wait_event_type = 'Lock')                    AS waiting_on_lock,
    COUNT(*) FILTER (WHERE backend_type = 'client backend')             AS client_connections,
    COUNT(*) FILTER (WHERE backend_type = 'autovacuum worker')          AS autovacuum_workers,
    COUNT(*) FILTER (WHERE backend_type = 'logical replication worker') AS logical_replication_workers,
    COUNT(*) FILTER (WHERE backend_type = 'parallel worker')            AS parallel_workers
FROM pg_stat_activity
WHERE pid <> PG_BACKEND_PID();
-- #end# pg_stat_activity_summary_query

-- #start# pg_stat_user_tables_query
SELECT schemaname    AS schema_name,
    relname       AS table_name,
    n_dead_tup    AS estimated_dead_rows,
    n_live_tup    AS estimated_live_rows,
    seq_scan      AS seq_scan_occured,
    seq_tup_read  AS rows_read_by_seq_scan,
    idx_scan      AS index_scan_occured,
    idx_tup_fetch AS rows_returned_from_index,
    last_seq_scan,
    last_idx_scan,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE (:p_schema_name IS NULL OR schemaname = :p_schema_name)
        AND (:p_table_name IS NULL OR relname = :p_table_name)
ORDER BY schema_name, table_name;
-- #end# pg_stat_user_tables_query

-- #start# db_stats_query
SELECT db.datname                                                          AS database_name,
    stat.numbackends                                                    AS active_connections,
    PG_SIZE_PRETTY(PG_DATABASE_SIZE(db.datname))                        AS database_size,
    PG_GET_USERBYID(db.datdba)                                          AS owner,
    db.datcollate                                                       AS collation_name,
       stat.deadlocks                                                      AS total_deadlocks,
       stat.sessions                                                       AS total_sessions,
       stat.xact_commit                                                    AS total_commits,
       stat.xact_rollback                                                  AS total_rollbacks,
       stat.tup_fetched                                                    AS row_read,
       stat.tup_inserted                                                   AS row_inserted,
       stat.tup_updated                                                    AS row_updated,
       stat.tup_deleted                                                    AS row_deleted,
       PG_SIZE_PRETTY(temp_bytes)                                          AS temp_size,
       ROUND(blks_hit::numeric / NULLIF(blks_hit + blks_read, 0) * 100, 2) AS cache_hit_pct,
       stat.stats_reset                                                    AS stats_reset_at
FROM pg_database AS db
    INNER JOIN pg_stat_database stat ON db.oid = stat.datid
WHERE NOT db.datistemplate
ORDER BY stat.numbackends DESC, db.datname;
-- #end# db_stats_query

-- #start# db_roles_query
SELECT rolname        AS role_name,
    rolcanlogin    AS can_login,
    rolsuper       AS is_super_user,
    rolreplication AS is_replication_enabled,
    rolcreatedb    AS can_create_db,
    rolcreaterole  AS can_create_roles,
    rolbypassrls   AS bypass_rls,
    rolvaliduntil  AS password_expiry
FROM pg_roles
ORDER BY rolcanlogin DESC, rolname;
-- #end# db_roles_query