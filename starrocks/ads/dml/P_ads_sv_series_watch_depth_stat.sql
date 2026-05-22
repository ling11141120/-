----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_watch_depth_stat
-- workflow_version : 8
-- create_user      : chenmo
-- task_name        : ads_sv_series_watch_depth_stat
-- task_version     : 6
-- update_time      : 2026-02-03 18:02:09
-- sql_path         : \starrocks\tbl_ads_sv_series_watch_depth_stat\ads_sv_series_watch_depth_stat
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_series_watch_depth_stat where dt = '${dt}';

-- SQL语句
insert into ads.ads_sv_series_watch_depth_stat
select
    '${dt}' as dt,                                                              -- 日期分区（DolphinScheduler参数）
    a.series_id,                                                                -- 剧集ID
    b.language as language_id,                                                  -- 语言ID（从维度表获取）
    count(distinct a.account_id) as start_watch_user_cnt,                       -- 开始观看人数（去重用户数）
    round(sum(a.user_watch_cnt) / count(distinct a.account_id), 2) as avg_watch_episode_cnt,  -- 人均观看集数
    now() as etl_time                                                           -- ETL时间戳
from (
    -- 子查询：计算每个用户在每个剧集中观看的集数
    select
        series_id,
        account_id,
        count(distinct epis_id) as user_watch_cnt                               -- 用户观看的集数（去重）
    from dwd.dwd_video_short_video_epis_history
    where create_time >= date_sub(now(), interval 7 day)  -- 24小时前整点
      and create_time < now()                -- 当前整点
      and watch_stamp >= 5                                                      -- 剔除无效观看（观看时长为0）
    group by series_id, account_id
) a
left join dim.dim_short_video_series_view b                                     -- 关联剧集维度表
on a.series_id = b.series_id
left join dim.dim_short_video_user_accountinfo c
on a.account_id = c.user_id
where b.language is not null and c.corever2 = 4                                     -- 过滤语言信息缺失的剧集
group by a.series_id, b.language;

-- SQL语句
-- 按剧集+语言聚合;
