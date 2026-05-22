----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_hot_list
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sv_hot_list
-- task_version     : 3
-- update_time      : 2025-08-06 17:26:33
-- sql_path         : \starrocks\tbl_ads_sv_hot_list\ads_sv_hot_list
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_hot_list where dt = date(date_sub(current_timestamp(), interval 1 hour));

-- SQL语句
insert into ads.ads_sv_hot_list
select
    date(date_sub(current_timestamp(), interval 1 hour)) as dt,
    a.series_id,
    b.language,
    c.corever,
    sum(amt_weight) as amt_weight,
    sum(consume_coin) as consume_coin,
    sum(consume_bonus) as consume_bonus,
    sum(watch_cnt) as watch_cnt,
    sum(like_cnt) as like_cnt,
    sum(follow_cnt) as follow_cnt,
    now() as etl_time
from (
    -- 观看付费集权重值
    select
        shortplay_id as series_id,
        login_id as user_id,
        (count(distinct if(unlock_type = 3, episode_id, null)) * 80) +
        (count(distinct if(unlock_type = 8, episode_id, null)) * 50) AS amt_weight,
        0 as consume_coin,
        0 as consume_bonus,
        0 as watch_cnt,
        0 as like_cnt,
        0 as follow_cnt
    from dwd.dwd_sensors_cd_video_unlockEpisode_view
    where unlock_type in(3, 8) and event_tm >= date_sub(current_timestamp(), interval 1 hour)
    group by shortplay_id, login_id
    union all
    -- 消费观看币数+消费观看券数
    select
        series_id,
        account_id,
        0,
        sum(distinct if(consume_type = 0, consume_value, 0)),
        sum(distinct if(consume_type = 1, consume_value, 0)),
        0,
        0,
        0
    from dwd.dwd_sv_consume_user_consume_bill_pdi
    where create_time >= date_sub(current_timestamp(), interval 1 hour)
    group by series_id, account_id
    union all
    -- 消费观看币数+消费观看券数
    select
        series_id,
        account_id,
        0,
        0,
        0,
        count(1),
        0,
        0
    from dwd.dwd_video_short_video_epis_history
    where watch_stamp != 0 and create_time >= date_sub(current_timestamp(), interval 1 hour)
    group by series_id, account_id
    union all
    -- 点赞次数
    select
        series_id,
        user_id,
        0,
        0,
        0,
        0,
        count(1),
        0
    from dwd.dwd_video_short_video_account_like_view
    where is_delete = 0 and create_time >= date_sub(current_timestamp(), interval 1 hour)
    group by series_id, user_id
    union all
    -- 添加追剧
    select
        SeriesId,
        AccountId,
        0,
        0,
        0,
        0,
        0,
        count(1)
    from ods.ods_tidb_short_video_follow_series
    where CreateTime >= date_sub(current_timestamp(), interval 1 hour)
    group by SeriesId, AccountId
) a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
left join dim.dim_short_video_user_accountinfo c
on a.user_id = c.user_id
where a.series_id is not null and b.language is not null and c.corever is not null
group by a.series_id, b.language, c.corever;
