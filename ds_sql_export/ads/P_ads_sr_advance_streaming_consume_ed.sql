----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_advance_streaming_consume_ed
-- workflow_version : 14
-- create_user      : chenmo
-- task_name        : ads_sr_advance_streaming_consume_ed
-- task_version     : 7
-- update_time      : 2025-02-18 16:15:52
-- sql_path         : \starrocks\tbl_ads_srsv_advance_streaming_consume_ed\ads_sr_advance_streaming_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sr_advance_streaming_consume_ed where dt >= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_sr_advance_streaming_consume_ed
select
    dt,
    code_id,
    spend,
    etl_time
from ads.ads_srsv_advance_streaming_consume_ed
where product_id != 6833 and dt >= '${bf_1_dt}';
