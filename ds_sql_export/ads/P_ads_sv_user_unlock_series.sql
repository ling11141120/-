----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_unlock_series
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : ads_sv_user_unlock_series
-- task_version     : 3
-- update_time      : 2026-02-16 12:25:38
-- sql_path         : \starrocks\tbl_ads_sv_user_unlock_series\ads_sv_user_unlock_series
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_unlock_series
select
    a.user_id,
    a.total_coin_series,
    a.total_vip_series,
    now() as etl_tm
from (
    select
        coalesce(a.account_id, b.login_id) as user_id,
        ifnull(total_coin_series, 0) as total_coin_series,
        ifnull(total_vip_series, 0) as total_vip_series
    from (
        select
            account_id,
            count(distinct series_id) as total_coin_series
        from dwd.dwd_sv_consume_user_consume_bill_pdi
        where series_id is not null and consume_type = 0 and bill_type in(1, 12, 13, 14, 15, 21) and gain_coin < 0
        group by account_id
    ) a
    full join (
        select
            login_id,
            count(distinct shortplay_id) as total_vip_series
        from dwd.dwd_sensors_cd_video_unlockEpisode_view
        where shortplay_id is not null and unlock_type = 3
        group by login_id
    ) b on a.account_id = b.login_id
) a
left join ads.ads_sv_user_unlock_series b on a.user_id = b.user_id
where b.user_id is null or a.total_coin_series != b.total_coin_series or a.total_vip_series != b.total_vip_series;
