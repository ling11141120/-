----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : dws_video_short_video_user_fist_time_watch_mid_bak1
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : dws_video_short_video_user_fist_time_watch_mid_bak1
-- task_version     : 3
-- update_time      : 2024-12-06 16:55:14
-- sql_path         : \starrocks\dws_video_short_video_user_fist_time_watch_mid_bak1\dws_video_short_video_user_fist_time_watch_mid_bak1
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_video_short_video_user_fist_time_watch_mid_bak1 where dt >= '${bf_1_dt}';

-- SQL语句
insert into dws.dws_video_short_video_user_fist_time_watch_mid_bak1
         select  a.dt,a.user_id,a.series_id,a.epis_num,a.create_time,
        a.h12_time,a.h24_time,a.d7_time,a.d30_time,
        case when date(a.create_time) = date(b.create_tm) then 1
             when  bitmap_contains(c.watch_user_90,a.user_id) = 0 then 2
             else 3 end as user_tp,
        case when date(a.create_time) = date(b.create_tm) then 1
             when date(a.create_time) = date(d.Install_Date) then 2
             else 3 end as source_user_tp,
   if(a.create_time >= d.install_date and a.create_time <= d.next_attribute_time and a.series_id=d.book_id,d.source,null) as source,
        b.corever,b.mt,
        now() as etl_time
from dwm.dwm_video_short_video_user_fist_time_watch a
         left join
     (   select user_id,hours_add(create_tm,-13)  as  create_tm,mt,corever
         from dim.dim_short_video_account_device_info
     ) b
     on a.user_id = b.user_id
         left join
     (  select  dt,series_id,watch_user_90
        from dwm.dwm_video_short_video_watch_wz5_ed_mid
        where dt = '${bf_1_dt}'
     ) c
     on a.series_id = c.series_id
         left join
     (          select
         user_id,install_date,source,next_attribute_time,book_id
     from (
        select user_id,install_date,next_attribute_time,source,book_id,
               row_number() over (partition by product_id,user_id,date(install_date) order by (case when source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when source = 'officialsite' then 2 else 1 end) desc, install_date) as rn
          from dwd.dwd_user_install_info_ed_est_mid
        where product_id = 6833
     ) a
     where rn = 1
     ) d
     on a.user_id = d.user_id
-- 改为实时，等于改为大于等于
where a.dt >= '${bf_1_dt}';
