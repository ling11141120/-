----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_ad_if_date_country_adlpdailylnsight_tz
-- workflow_version : 18
-- create_user      : chenmo
-- task_name        : ads_ad_if_date_country_adlpdailylnsight_tz
-- task_version     : 4
-- update_time      : 2024-11-05 17:02:34
-- sql_path         : \starrocks\sch_ads_ad_if_date_country_adlpdailylnsight_tz\ads_ad_if_date_country_adlpdailylnsight_tz
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_ad_if_date_country_adlpdailylnsight_tz` where date_start = '${bf_1_dt}';

-- SQL语句
insert into ads.`ads_ad_if_date_country_adlpdailylnsight_tz`
with event as (
    select
        createtime,
        serial as adid,
        ip,
        position,
        user_id,
        isretry,
        extid,
        event
    from ods_log.ods_sensors_event_info
    where dt >= DATE_ADD('${bf_1_dt}', INTERVAL -1 DAY)
        AND dt < DATE_ADD('${dt}', INTERVAL 1 DAY)
        AND event IN ('cdclick', 'cdexposure')
        AND position IN (15140000, 15140001, 15140002)
        AND serial IS NOT NULL
        AND serial != ''
),
event_tz as (
    select
        a.createtime,
        DATE(DATE_SUB(a.createtime, INTERVAL coalesce(-b.account_tz, 13) HOUR)) as date_start,
        a.adid,
        a.ip,
        a.position,
        a.user_id,
        a.isretry,
        a.extid,
        a.event,
        b.account_tz
    from event a
    left join (
        select
            ad_group_id,
            a.account,
            b.account_tz
        from (
            select ad_group_id, account from dim.dim_adsadgroup_view
            union all
            select ad_id, fb_account from dim.dim_short_viedo_adid_info_view
            union all
            select AdId, FbAccount from ods.ods_tidb_sharpengine_ads_global_FbAd
        ) a
        left join dim.dim_ad_account b on a.account = b.account
    ) b on a.adid = b.ad_group_id
    where a.createtime >= DATE_ADD('${bf_1_dt}', INTERVAL coalesce(-b.account_tz, 13) HOUR)  -- 加上 13 小时
    AND a.createtime <= DATE_ADD('${dt}', INTERVAL coalesce(-b.account_tz, 13) HOUR)  -- 加上 13 小时
)
select
    a.date_start,
    a.adid,
    a.ip,
    null as country,
    coalesce(a.account_tz, -13) as account_tz,
    a.lpclicks,
    a.lpimpressions,
    CURRENT_TIMESTAMP() as updatetime,
    a.lpinitialization,
    a.lpclicks_1,
    a.lpimpressions_1,
    a.lpinitialization_1,
    c.lpclicks_2,
    b.lpimpressions_2,
    b.lpinitialization_2
from (
    -- 时区统一13小时条数验证通过
    select
        date_start,
        adid,
        ip,
        account_tz,
        COUNT(CASE WHEN event = 'cdclick' AND position = 15140001 THEN user_id END) AS lpclicks,
        COUNT(CASE WHEN event = 'cdexposure' AND position = 15140000 THEN user_id END) AS lpimpressions,
        COUNT(CASE WHEN event = 'cdexposure' AND position = 15140002 THEN user_id END) AS lpinitialization,
        COUNT(CASE WHEN event = 'cdclick' AND position = 15140001 AND isretry = 0 AND extid IS NOT NULL THEN user_id END) AS lpclicks_1,
        COUNT(CASE WHEN event = 'cdexposure' AND position = 15140000 AND isretry = 0 AND extid IS NOT NULL THEN user_id END) AS lpimpressions_1,
        COUNT(CASE WHEN event = 'cdexposure' AND position = 15140002 AND isretry = 0 AND extid IS NOT NULL THEN user_id END) AS lpinitialization_1
    from event_tz a
    GROUP BY date_start, adid, ip, account_tz
) a
left join (
    -- 时区统一13小时条数验证通过
    select date_start,
           adid,
           ip,
           account_tz,
           sum(lpimpressions_2)    as lpimpressions_2,
           sum(lpinitialization_2) as lpinitialization_2
    from (
        select
            date_start,
            adid,
            ip,
            account_tz,
            count(distinct case when position in (15140000) then extid end) as lpimpressions_2,
            count(distinct case when position in (15140002) then extid end) as lpinitialization_2
        from event_tz
        where event in('cdexposure')
            and position in(15140000, 15140002)
            and isretry in(1)
        group by date_start, adid, ip, account_tz
        union all
        select
            date_start,
            adid,
            ip,
            account_tz,
            count(case when position in (15140000) then extid end) as lpimpressions_2,
            count(case when position in (15140002) then extid end) as lpinitialization_2
        from event_tz
        where event in('cdexposure')
            and position in(15140000, 15140002)
            and isretry in(0)
        group by date_start, adid, ip, account_tz
    ) v
    group by date_start, adid, ip, account_tz
) b on a.date_start = b.date_start and a.adid = b.adid and a.ip = b.ip and a.account_tz = b.account_tz
left join (
    -- 时区统一13小时条数验证通过
    select
        date_start,
        adid,
        ip,
        account_tz,
        sum(lpclicks_2) as lpclicks_2
    from (
        select
            date_start,
            adid,
            ip,
            account_tz,
            count(distinct extid) as lpclicks_2
        from event_tz
        where event in('cdclick')
            and position = 15140001
            and isretry in(1)
        group by date_start, adid, ip, account_tz
        union all
        select
            date_start,
            adid,
            ip,
            account_tz,
            count(extid) as lpclicks_2
        from event_tz
        where event in('cdclick')
            and position = 15140001
            and isretry in(0)
        group by date_start, adid, ip, account_tz
    ) a
    group by date_start, adid, ip, account_tz
) c on a.date_start = c.date_start and a.adid = c.adid and a.ip = c.ip and a.account_tz = c.account_tz;
