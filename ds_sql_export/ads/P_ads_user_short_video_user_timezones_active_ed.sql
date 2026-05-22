----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_short_video_user_timezones_active_ed
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : ads_user_short_video_user_timezones_active_ed
-- task_version     : 6
-- update_time      : 2025-02-05 16:42:06
-- sql_path         : \starrocks\tbl_ads_user_short_video_user_timezones_active_ed\ads_user_short_video_user_timezones_active_ed
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_short_video_user_timezones_active_ed
with active_user_tmp as (
    select
        CONVERT_TZ(create_time, '+08:00', '+00:00') as create_time,
        product_id,
        user_id
    from (
        -- 海外短剧登录表
        select create_time,product_id, user_id  from dwd.dwd_user_short_video_user_login_view  where dt >= '${bf_3_dt}' and dt<='${dt}' and user_id>=0
        union all
        -- 海外短剧支付表
        select create_time,product_id ,user_id from dwd.dwd_trade_short_video_payorder
        where dt>='${bf_3_dt}' and dt<='${dt}' and product_id =6833 and status=0 and test_flag =0 and user_id>=0
        union all
        -- 海外短剧消耗表
        select create_time,6833 as product_id, account_id as user_id from dwd.dwd_sv_consume_user_consume_bill_pdi where dt >= '${bf_3_dt}' and dt<='${dt}' and account_id>=0
        union all
        -- 海外短剧观看记录表
        select create_time,6833 as product_id,account_id as user_id from dwd.dwd_video_short_video_epis_history where date(create_time) >= '${bf_3_dt}' and date(create_time)<'${dt}'and account_id>=0
    ) t
),
user_info_tmp AS (
    -- 海外短剧用户信息
    select
        sacc.product_id,
        sacc.user_id,
        sacc.corever2 as corever,
        sacc.mt2 as mt,
        sacc.current_language,
        sacc.current_language2,
        sacc.reg_country,
        ifnull(lev.level,2) as level,
        sacc.create_time,
        sacc.sex,
        sacc.third_party_id,
        sacc.pass_word,
        sacc.email,
        sacc.bind_email,
        b.Utcoffset/60/60 as utc_offset_hour
    from dim.dim_short_video_user_accountinfo sacc
    left join(
        select product_id,short_name,level from dim.dim_countrylevel where product_id=6833
    )lev
    on sacc.product_id=lev.product_id and sacc.reg_country=lev.short_name
    left join ods.ods_tidb_short_video_device_info b
    on sacc.unique_cdreader_id = b.UniqueCdReaderId
),
-- 用户第一次安装时的剧ID
sv_user_series_id AS (
    SELECT
        user_id,
        series_id
    FROM
        (
        SELECT user_id,
               book_id AS series_id,
               ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY install_date) as `rank`
        FROM ads.ads_user_install_info_view
        WHERE product_id = 6833
        ) a
    WHERE a.rank = 1
),
-- 关联剧编码
sv_user_video_code AS (
    SELECT
         a.user_id AS user_id,
         a.series_id AS series_id,
         b.source_series_code AS series_code
    FROM sv_user_series_id a
     LEFT JOIN dim.dim_sv_series_hi b
    ON a.series_id = b.series_id
)
select
    date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)) as dt,
    b.product_id,
    b.user_id,
    date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour) as create_time,
    ifnull(utc_offset_hour, -5) as utc_offset,
    acc.corever,
    acc.mt,
    acc.current_language as current_language,
    acc.currentlanguage2 as currentlanguage2,
    acc.reg_country,
    acc.level,
    acc.create_time,
    datediff(date(date_add(b.create_time, interval ifnull(utc_offset_hour, -5) hour)),acc.create_time) as reg_days,
    acc.sex,
    if(third_party_id in(1,2,3) or pass_word is not null,1,0) as is_acc_login,
    if(email is not null or bind_email is not null,1,0) as is_has_email,
    c.series_code,
    now() as etl_time
from active_user_tmp b
left join (
    select
        a.product_id,
        a.user_id,
        if(a.corever is null or a.CoreVer=0,1,a.CoreVer) as corever,
        a.mt,
        a.current_language ,
        case when (current_language2  is null or current_language2=0)and product_id=3311 then 6
             when (current_language2  is null or current_language2=0)and product_id=3322 then 5
             when (current_language2  is null or current_language2=0)and product_id=3333 then 2
             when (current_language2  is null or current_language2=0)and product_id=3366 then 3
             when (current_language2  is null or current_language2=0)and product_id=3371 then 7
             when (current_language2  is null or current_language2=0)and product_id=3388 then 4
             when (current_language2  is null or current_language2=0)and product_id=3501 then 11
             when (current_language2  is null or current_language2=0)and product_id=3511 then 12
             else current_language2
         end  as currentlanguage2,
        a.reg_country,
        a.level,
        date_add(CONVERT_TZ(a.create_time, '+08:00', '+00:00'), interval ifnull(a.utc_offset_hour, -5) hour) as create_time,
        a.sex,
        a.third_party_id,
        a.pass_word,
        a.email,
        a.bind_email,
        a.utc_offset_hour
    from user_info_tmp a
) acc on b.product_id=acc.product_id and b.user_id=acc.user_id
left join sv_user_video_code c on b.user_id = c.user_id;
