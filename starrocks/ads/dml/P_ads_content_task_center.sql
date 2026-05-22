----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_task_center
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_content_task_center_7
-- task_version     : 4
-- update_time      : 2025-04-22 14:04:29
-- sql_path         : \starrocks\tbl_ads_content_task_center\ads_content_task_center_7
----------------------------------------------------------------
-- SQL语句
-- 7:新签约的质检      2025-4-19统计为208条
INSERT INTO ads.ads_content_task_center
WITH tmp_data AS (
SELECT
    ProductId,
    DATE(CreateTime) dt,
    a.ToLanguage,
    12 AS role_type,
    7 AS check_model,
    REGEXP_REPLACE(replace(split(a.TaskTitle,'英语译员：')[2],'初译审核结果：通过',''),'[\\r\\n]+','') AS PenName
FROM ods.ods_shuangwen_tidb_xx_taskcenter a
WHERE a.TaskType = '译员初译审核结果'
and ToLanguage = 322
and TaskTitle like '%初译审核结果：通过%'
),

tmp_penname AS (
SELECT
        productid,
        ToLanguage,
        AccountId,
        split(PenName,'-')[1] AS PenName
FROM ods.ods_tidb_shuangwen_xx_objectauthor
),

tmp_result AS (
SELECT
     a.dt,
     a.ToLanguage AS site_id,
     CASE WHEN a.PenName = '任爱华' THEN 2602
         ELSE b.AccountId
        END AS author_id,
     a.role_type,
     a.check_model,
     a.PenName AS pen_name,
     NOW()
FROM tmp_data a
LEFT JOIN tmp_penname b
    ON  a.ProductId = b.productid
    AND split(a.PenName,'-')[1] = b.PenName
    AND a.ToLanguage = b.ToLanguage
)

SELECT
    md5(concat_ws('_',dt,site_id,author_id,role_type,check_model,pen_name)) as md5_key,
    dt,
    site_id,
    author_id,
    role_type,
    check_model,
    pen_name,
    NOW()
FROM tmp_result;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_task_center
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_content_task_center_8
-- task_version     : 3
-- update_time      : 2025-04-22 14:02:54
-- sql_path         : \starrocks\tbl_ads_content_task_center\ads_content_task_center_8
----------------------------------------------------------------
-- SQL语句
-- 8:新签约的一校    2025-04-19 统计为976条
-- Status 状态 0:未审核 1：通过、2：不通过、3：再修改 、4：加译
-- RoleType 角色类型 1：译员、2：一校、3：二校
INSERT INTO ads.ads_content_task_center
WITH tmp_result AS (
SELECT
    DATE (AuditTime) AS dt,
    a.ToLanguage AS site_id,
    a.AuthorId AS author_id,
    2 AS role_type,
    8 AS check_model,
    b.PenName AS pen_name,
    NOW()
FROM ods.ods_shuangwen_tidb_en_firsttranslatelog a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
ON a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
WHERE a.Status = 1
  AND a.IsDelete = 0
  AND a.RoleType = 2
)

SELECT
    md5(concat_ws('_',dt,site_id,author_id,role_type,check_model,pen_name)) as md5_key,
    dt,
    site_id,
    author_id,
    role_type,
    check_model,
    pen_name,
    NOW()
FROM tmp_result;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_task_center
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_content_task_center_9
-- task_version     : 3
-- update_time      : 2025-04-22 14:02:54
-- sql_path         : \starrocks\tbl_ads_content_task_center\ads_content_task_center_9
----------------------------------------------------------------
-- SQL语句
-- 9:新签约的二校    2025-04-19统计为331行
-- Status 状态 0:未审核 1：通过、2：不通过、3：再修改 、4：加译
-- RoleType 角色类型 1：译员、2：一校、3：二校
INSERT INTO ads.ads_content_task_center
WITH tmp_result AS (
SELECT
    DATE (AuditTime) AS dt,
   a.ToLanguage AS site_id,
   a.AuthorId AS author_id,
   3 AS role_type,
   9 AS check_model,
   b.PenName AS pen_name,
   NOW()
FROM ods.ods_shuangwen_tidb_en_firsttranslatelog a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
ON a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
WHERE a.Status = 1
  AND a.IsDelete = 0
  AND a.RoleType = 3
)

SELECT
    md5(concat_ws('_',dt,site_id,author_id,role_type,check_model,pen_name)) as md5_key,
    dt,
    site_id,
    author_id,
    role_type,
    check_model,
    pen_name,
    NOW()
FROM tmp_result;
