----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_app_ad_income_ed
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_app_ad_income_ed
-- task_version     : 3
-- update_time      : 2025-06-23 15:28:51
-- sql_path         : \starrocks\tbl_ads_app_ad_income_ed\ads_app_ad_income_ed
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_app_ad_income_ed WHERE dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
INSERT INTO ads.ads_app_ad_income_ed
SELECT
     `dt`,
     `product_id`,
     `core`,
     `mt`,
     `ad_show_type`,
     `appver`,
     SUM(amt),
     NOW()
FROM dws.dws_advertisement_user_position_amt_ed
WHERE dt>='${bf_1_dt}' and dt<='${dt}'
GROUP BY `dt`, `product_id`,`core`,`mt`,`ad_show_type`,`appver`;
