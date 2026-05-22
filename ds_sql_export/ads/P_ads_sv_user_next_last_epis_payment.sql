----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_next_last_epis_payment
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : ads_sv_user_next_last_epis_payment
-- task_version     : 1
-- update_time      : 2025-02-10 16:17:31
-- sql_path         : \starrocks\tbl_ads_sv_user_next_last_epis_payment\ads_sv_user_next_last_epis_payment
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_next_last_epis_payment
select
    a.account_id,
    a.series_id,
    a.epis_id,
    a.is_free,
    a.create_time
from (
    select
        a.account_id,
        a.series_id,
        b.epis_id,
        b.is_free,
        a.create_time
    from (
        select
            a.account_id,
            a.series_id,
            a.epis_num,
            a.create_time
        from (
            select
                account_id,
                series_id,
                epis_num+1 as epis_num,
                create_time
            from (
                select
                    account_id,
                    series_id,
                    epis_num,
                    create_time,
                    row_number() over (partition by account_id order by create_time desc) as rn
                from dwd.dwd_video_short_video_epis_history
                where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}' and (watch_stamp != 0 or watch_over != 0)
            ) a where rn = 1
        ) a
        left join dim.dim_short_video_series_view b
        on a.series_id = b.series_id
        left join (
            select
                user_id
            from dwd.dwd_trade_short_video_payorder_view
            where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}'
            group by user_id
        ) c on a.account_id = c.user_id
        where a.epis_num <= b.last_epis and a.epis_num >= pay_epis_from and c.user_id is null
    ) a
    left join dim.dim_short_video_epis_view b
    on a.series_id = b.series_id and a.epis_num = b.epis_num and b.is_delete = 0
) a
left join ads.ads_sv_user_next_last_epis_payment b
on a.account_id = b.user_id
where a.create_time != ifnull(b.create_time, -99);
