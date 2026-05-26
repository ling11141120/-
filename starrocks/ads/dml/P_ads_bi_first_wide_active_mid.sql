----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_first_wide_active
-- workflow_version : 5
-- create_user      : linq
-- task_name        : ads_bi_first_wide_active_mid
-- task_version     : 2
-- update_time      : 2023-12-16 19:05:03
-- sql_path         : \starrocks\tbl_ads_bi_first_wide_active\ads_bi_first_wide_active_mid
----------------------------------------------------------------
-- SQL语句
-- 聚合模型，不用删除数据
insert into ads.ads_bi_first_wide_active_mid
select product_id,user_id,dt,now() as etl_time
from dws.dws_user_wide_active_ed
where dt>='${bf_3_dt}' and dt<'${dt}';
