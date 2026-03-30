----------------------------------------------------------------
-- 程序功能： OpenMetadata血缘测试-ADS表数据完整性检查
-- 程序名： P_ads_openmetadata_lineage_test_di
-- 目标表： ads.ads_openmetadata_lineage_test_di
-- 负责人： roger
-- 开发日期：2026-03-30
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_openmetadata_lineage_test_di
WITH date_range AS (
    SELECT DATE_ADD('2025-12-25', INTERVAL seq DAY) AS dt
    FROM (
             SELECT a.n + b.n * 10 + c.n * 100 AS seq
             FROM
                 (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
                  UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
                 (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
                  UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
                 (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2) c
         ) nums
    WHERE DATE_ADD('2025-12-25', INTERVAL seq DAY) <= '${dt}'
),

table1_stats AS (
    SELECT
        'ads_sr_beidou_books_chapter_stat_di' AS table_name,
        dt,
        COUNT(1) AS row_count,
        min(etl_time) as min_etl_time,
        max(etl_time) as max_etl_time
    FROM ads.ads_sr_beidou_books_chapter_stat_di
    WHERE dt BETWEEN '2025-12-25' AND '${dt}'
    GROUP BY dt
),

table2_stats AS (
    SELECT
        'ads_sr_beidou_books_daily_stat_di' AS table_name,
        dt,
        COUNT(1) AS row_count,
        min(etl_time) as min_etl_time,
        max(etl_time) as max_etl_time
    FROM ads.ads_sr_beidou_books_daily_stat_di
    WHERE dt BETWEEN '2025-12-25' AND '${dt}'
    GROUP BY dt
),

table3_stats AS (
    SELECT
        'ads_sr_beidou_books_retention_stat_di' AS table_name,
        dt,
        COUNT(1) AS row_count,
        min(etl_time) as min_etl_time,
        max(etl_time) as max_etl_time
    FROM ads.ads_sr_beidou_books_retention_stat_di
    WHERE dt BETWEEN '2025-12-25' AND '${dt}'
    GROUP BY dt
),

table4_stats AS (
    SELECT
        'ads_sr_beidou_books_source_stat_di' AS table_name,
        dt,
        COUNT(1) AS row_count,
        min(etl_time) as min_etl_time,
        max(etl_time) as max_etl_time
    FROM ads.ads_sr_beidou_books_source_stat_di
    WHERE dt BETWEEN '2025-12-25' AND '${dt}'
    GROUP BY dt
),

table5_stats AS (
    SELECT
        'ads_sr_beidou_books_user_type_di' AS table_name,
        dt,
        COUNT(1) AS row_count,
        min(etl_time) as min_etl_time,
        max(etl_time) as max_etl_time
    FROM ads.ads_sr_beidou_books_user_type_di
    WHERE dt BETWEEN '2025-12-25' AND '${dt}'
    GROUP BY dt
),

all_tables_stats AS (
    SELECT table_name, dt, row_count, min_etl_time, max_etl_time FROM table1_stats
    UNION ALL
    SELECT table_name, dt, row_count, min_etl_time, max_etl_time FROM table2_stats
    UNION ALL
    SELECT table_name, dt, row_count, min_etl_time, max_etl_time FROM table3_stats
    UNION ALL
    SELECT table_name, dt, row_count, min_etl_time, max_etl_time FROM table4_stats
    UNION ALL
    SELECT table_name, dt, row_count, min_etl_time, max_etl_time FROM table5_stats
),

expected_data AS (
    SELECT
        t.table_name,
        d.dt
    FROM (
             SELECT DISTINCT table_name FROM all_tables_stats
         ) t
             CROSS JOIN date_range d
)

SELECT
    e.dt,
    e.table_name,
    COALESCE(a.row_count, 0)  AS row_count,
    a.min_etl_time,
    a.max_etl_time,
    CASE
        WHEN a.row_count IS NULL THEN '缺失'
        WHEN a.row_count = 0    THEN '空数据'
        ELSE '正常'
    END                        AS status,
    now()                      AS etl_time
FROM expected_data e
         LEFT JOIN all_tables_stats a
                   ON e.table_name = a.table_name
                       AND e.dt = a.dt
ORDER BY e.table_name, e.dt
;
