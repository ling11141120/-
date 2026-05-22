----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_watch_consume_leave_stat
-- workflow_version : 21
-- create_user      : zhengtt
-- task_name        : ads_bi_short_video_watch_consume_leave_stat_1
-- task_version     : 2
-- update_time      : 2024-10-22 19:52:39
-- sql_path         : \starrocks\tbl_ads_bi_short_video_watch_consume_leave_stat\ads_bi_short_video_watch_consume_leave_stat_1
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_watch_consume_leave_stat where dt = '${bf_1_dt}' and user_tp = 1;

-- SQL语句
insert into ads.ads_bi_short_video_watch_consume_leave_stat
select  a.dt,md5(concat(a.user_tp,a.series_id,a.epis_num,
                        if(a.core is null,-99,a.core),
                        if(a.mt is null,-99,a.mt),
                        if(a.source is null,'-99',a.source),
                        if(a.series_language is null,-99,a.series_language),
                        if(a.series_name is null,'-99',a.series_name))) as md5_key,
        a.user_tp,a.series_id,a.epis_num,a.core,a.mt,a.source,a.series_language,a.series_name,
        a.video_watch_user_bitmap,a.video_consume_user_bitmap,a.video_coin_consume_user_bitmap,
        a.epis_length,b.preceding_current_duration,a.epis_amount,b.preceding_current_price,now() as etl_time
from
    (   select dt,core,a.mt as mt,source,series_language,
               1 as  user_tp,
               series_id,series_name,epis_num,epis_length,epis_amount,
               bitmap_union(to_bitmap(if(epis_watch_num_real is not null,user_id,null))) as video_watch_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0,user_id,null)))as video_consume_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0,user_id,null))) as video_coin_consume_user_bitmap
        from
            (   select dt,core,mt,source,series_language,series_id,series_name,epis_num,user_id,
                       epis_length,epis_amount,epis_watch_num_real,
                       if(epis_coin_consume_amount is null,0,epis_coin_consume_amount) as epis_coin_consume_amount,
                       if(epis_cert_consume_amount is null,0,epis_cert_consume_amount) as epis_cert_consume_amount
                from dwm.dwm_video_short_video_watch_consume_ed
                where  dt = '${bf_1_dt}' and coalesce(epis_watch_num_real,epis_coin_consume_amount,epis_cert_consume_amount) is not null
            ) a
        group by 1,2,3,4,5,6,7,8,9,10,11
    ) a
        left join dim.dim_short_video_epis_view b
                  on a.series_id = b.series_id and a.epis_num = b.epis_num
where b.is_delete = 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_watch_consume_leave_stat
-- workflow_version : 21
-- create_user      : zhengtt
-- task_name        : ads_bi_short_video_watch_consume_leave_stat_2
-- task_version     : 2
-- update_time      : 2024-10-22 19:52:39
-- sql_path         : \starrocks\tbl_ads_bi_short_video_watch_consume_leave_stat\ads_bi_short_video_watch_consume_leave_stat_2
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_watch_consume_leave_stat where dt = '${bf_1_dt}' and user_tp = 2;

-- SQL语句
insert into ads.ads_bi_short_video_watch_consume_leave_stat
select  a.dt,md5(concat(a.user_tp,a.series_id,a.epis_num,
                        if(a.core is null,-99,a.core),
                        if(a.mt is null,-99,a.mt),
                        if(a.source is null,'-99',a.source),
                        if(a.series_language is null,-99,a.series_language),
                        if(a.series_name is null,'-99',a.series_name))) as md5_key,
        a.user_tp,a.series_id,a.epis_num,a.core,a.mt,a.source,a.series_language,a.series_name,
        a.video_watch_user_bitmap,a.video_consume_user_bitmap,a.video_coin_consume_user_bitmap,
        a.epis_length,b.preceding_current_duration,a.epis_amount,b.preceding_current_price,now() as etl_time
from
    (   select dt,core,a.mt as mt,source,series_language,
               2 as  user_tp,
               series_id,series_name,epis_num,epis_length,epis_amount,
               bitmap_union(to_bitmap(if(epis_watch_num_real is not null,a.user_id,null))) as video_watch_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0,a.user_id,null)))as video_consume_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0,a.user_id,null))) as video_coin_consume_user_bitmap
        from
            (   select dt,core,mt,source,series_language,series_id,series_name,epis_num,epis_watch_num_real,user_id,
                       epis_length,epis_amount,
                       if(epis_coin_consume_amount is null,0,epis_coin_consume_amount) as epis_coin_consume_amount,
                       if(epis_cert_consume_amount is null,0,epis_cert_consume_amount) as epis_cert_consume_amount
                from dwm.dwm_video_short_video_watch_consume_ed
                where  dt = '${bf_1_dt}' and coalesce(epis_watch_num_real,epis_coin_consume_amount,epis_cert_consume_amount) is not null
            ) a
                left join dim.dim_short_video_account_device_info b
                          on a.user_id = b.user_id
        where  datediff(dt,create_tm) < 30
        group by 1,2,3,4,5,6,7,8,9,10,11
    ) a
        left join dim.dim_short_video_epis_view b
                  on a.series_id = b.series_id and a.epis_num = b.epis_num
where b.is_delete = 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_watch_consume_leave_stat
-- workflow_version : 21
-- create_user      : zhengtt
-- task_name        : ads_bi_short_video_watch_consume_leave_stat_3
-- task_version     : 15
-- update_time      : 2024-11-11 20:24:36
-- sql_path         : \starrocks\tbl_ads_bi_short_video_watch_consume_leave_stat\ads_bi_short_video_watch_consume_leave_stat_3
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_watch_consume_leave_stat where dt = '${bf_1_dt}' and user_tp = 3;

-- SQL语句
insert into ads.ads_bi_short_video_watch_consume_leave_stat
with a_tmp_1 AS (
    select  a.dt as dt ,core,mt,source,series_language,a.series_id as series_id,series_name,
            a.epis_num as epis_num,epis_length,epis_amount,
            CASE WHEN bitmap_contains(b.watch_user_90,a.user_id) = 1 THEN null ELSE user_id END  as user_id,
            CASE WHEN epis_coin_consume_amount is null THEN 0 ELSE epis_coin_consume_amount END  as epis_coin_consume_amount,
            CASE WHEN epis_cert_consume_amount is null THEN 0 ELSE epis_cert_consume_amount END as epis_cert_consume_amount
    from
        (   select dt,core,mt,source,series_language,series_id,series_name,epis_num,epis_length,epis_amount,
                   epis_watch_num_real,user_id,epis_coin_consume_amount,epis_cert_consume_amount
            from dwm.dwm_video_short_video_watch_consume_ed
            where dt = '${bf_1_dt}' and epis_watch_num_real is not null and mt = 1
        ) a
            left join (select series_id, epis_num, watch_user_90 from dwm.dwm_video_short_video_watch_ed_mid where dt = '${bf_1_dt}') b
                      on a.series_id = b.series_id and a.epis_num = b.epis_num

),
a_tmp_2 AS (
    select  a.dt as dt ,core,mt,source,series_language,a.series_id as series_id,series_name,
            a.epis_num as epis_num,epis_length,epis_amount,
            CASE WHEN bitmap_contains(b.watch_user_90,a.user_id) = 1 THEN null ELSE user_id END  as user_id,
            CASE WHEN epis_coin_consume_amount is null THEN 0 ELSE epis_coin_consume_amount END  as epis_coin_consume_amount,
            CASE WHEN epis_cert_consume_amount is null THEN 0 ELSE epis_cert_consume_amount END as epis_cert_consume_amount
    from
        (   select dt,core,mt,source,series_language,series_id,series_name,epis_num,epis_length,epis_amount,
                   epis_watch_num_real,user_id,epis_coin_consume_amount,epis_cert_consume_amount
            from dwm.dwm_video_short_video_watch_consume_ed
            where dt = '${bf_1_dt}' and epis_watch_num_real is not null and mt != 1
        ) a
            left join (select series_id, epis_num, watch_user_90 from dwm.dwm_video_short_video_watch_ed_mid where dt = '${bf_1_dt}') b
                      on a.series_id = b.series_id and a.epis_num = b.epis_num

)
select  a.dt,md5(concat(a.user_tp,a.series_id,a.epis_num,
                        if(a.core is null,-99,a.core),
                        if(a.mt is null,-99,a.mt),
                        if(a.source is null,'-99',a.source),
                        if(a.series_language is null,-99,a.series_language),
                        if(a.series_name is null,'-99',a.series_name))) as md5_key,
        a.user_tp,a.series_id,a.epis_num,a.core,a.mt,a.source,a.series_language,a.series_name,
        a.video_watch_user_bitmap,a.video_consume_user_bitmap,a.video_coin_consume_user_bitmap,
        a.epis_length,b.preceding_current_duration,a.epis_amount,b.preceding_current_price,now() as etl_time
from
    (   select dt,core,a.mt as mt,source,series_language,
               3 as  user_tp,
               series_id,series_name,epis_num,epis_length,epis_amount,
               bitmap_union(to_bitmap(a.user_id)) as video_watch_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0,a.user_id,null)))as video_consume_user_bitmap,
               bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0,a.user_id,null))) as video_coin_consume_user_bitmap
        from (select * from a_tmp_1 union all select * from a_tmp_2)  a
        where user_id is not null
        group by 1,2,3,4,5,6,7,8,9,10,11
    ) a
        left join (select preceding_current_duration,preceding_current_price,series_id,epis_num from dim.dim_short_video_epis_view where is_delete = 0) b
                  on a.series_id = b.series_id and a.epis_num = b.epis_num;
