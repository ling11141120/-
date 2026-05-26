----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_series_qa
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_content_series_qa
-- task_version     : 4
-- update_time      : 2025-02-10 19:24:51
-- sql_path         : \starrocks\tbl_ads_content_series_qa\ads_content_series_qa
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_series_qa
SELECT
      a.SeriesId AS series_id,
      1 AS type_id,
      b.source_series_code AS series_code,
      b.series_name AS series_name,
      b.published_at AS putaway_date,
      a.QaUser,
      a.QaPassTime AS auditor_time
FROM ods.ods_tidb_short_video_admin_series_qa a
LEFT JOIN dim.dim_sv_series_hi b
ON a.SeriesId = b.series_id
WHERE a.QaUser is not null
AND QaPassTime IS NOT NULL
UNION ALL
SELECT
    a.SeriesId AS series_id,
    2 AS type_id,
    b.source_series_code AS series_code,
    b.series_name AS series_name,
    b.published_at AS putaway_date,
    a.QcUser,
    a.QcPassTime AS auditor_time
FROM ods.ods_tidb_short_video_admin_series_qa a
         LEFT JOIN dim.dim_sv_series_hi b
                   ON a.SeriesId = b.series_id
WHERE a.QcUser is not null
AND QcPassTime IS NOT NULL;
