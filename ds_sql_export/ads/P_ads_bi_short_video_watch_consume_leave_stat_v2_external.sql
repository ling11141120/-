----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_watch_consume_leave_stat_v2_external
-- workflow_version : 15
-- create_user      : yanxh
-- task_name        : ads_bi_short_video_watch_consume_leave_stat_v2_external
-- task_version     : 12
-- update_time      : 2025-02-05 11:53:45
-- sql_path         : \starrocks\tbl_ads_bi_short_video_watch_consume_leave_stat_v2_external\ads_bi_short_video_watch_consume_leave_stat_v2_external
----------------------------------------------------------------
-- SQL语句
INSERT into ads.`ads_bi_short_video_watch_consume_leave_stat_v2_external`
 select
 `dt`,
`md5_key`,
`series_id`,
`epis_num`,
`user_tp`,
`source_user_tp`,
`series_name`,
`series_language`,
`series_code`,
`corever`,
`mt`,
`source`,
`epis_length`,
`preceding_current_duration`,
`watch_user_bitmap`,
`consume_user_bitmap`,
`consume_coin_user_bitmap`,
`video_consume_amt`,
`watch_user_bitmap_12h`,
`consume_user_bitmap_12h`,
`consume_coin_user_bitmap_12h`,
`video_consume_amt_12h`,
`watch_user_bitmap_24h`,
`consume_user_bitmap_24h`,
`consume_coin_user_bitmap_24h`,
`video_consume_amt_24h`,
`watch_user_bitmap_7d`,
`consume_user_bitmap_7d`,
`consume_coin_user_bitmap_7d`,
`video_consume_amt_7d`,
`watch_user_bitmap_30d`,
`consume_user_bitmap_30d`,
`consume_coin_user_bitmap_30d`,
`video_consume_amt_30d`,
`etl_time`
 from  ads.`ads_bi_short_video_watch_consume_leave_stat_v2`  where dt>=date_sub('${bf_1_dt}',interval 30 day);
