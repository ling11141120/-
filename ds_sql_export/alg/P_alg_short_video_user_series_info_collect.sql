----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_short_video_user_series_info_
-- workflow_version : 12
-- create_user      : admin
-- task_name        : alg_short_video_user_series_info_collect
-- task_version     : 11
-- update_time      : 2025-03-31 18:26:18
-- sql_path         : \starrocks\tbl_alg_short_video_user_series_info_\alg_short_video_user_series_info_collect
----------------------------------------------------------------
-- SQL语句
insert into alg.alg_short_video_user_series_info_collect
select
    '${bf_1_dt}' dt ,
    user_id ,
    series_id ,
    count(distinct case when is_unlock then epis_id end) unlock_cnt,
    count(distinct epis_id) epis_cnt ,
    count(distinct case when is_complete then epis_id end) complete_cnt ,
    count(distinct case when is_like then epis_id end) like_cnt ,
    sum(IFNULL(coin_amt, 0) + IFNULL(cert_amt, 0)) consume_amt ,
    CURRENT_TIME() etl_time
from alg.alg_short_video_user_series_info_detail
group by 1,2,3;
