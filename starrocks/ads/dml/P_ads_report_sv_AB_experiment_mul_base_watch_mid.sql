----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_base_watch_mid
-- task_version     : 9
-- update_time      : 2025-04-27 19:42:00
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_base_watch_mid
----------------------------------------------------------------
-- SQL语句
-- 数据别删，上游表只保留了10天的数据
insert into ads.ads_report_sv_AB_experiment_mul_base_watch_mid
with watch_event as (
    select dt, product_id,login_id as user_id, shortplay_id as series_id,episode_id as epis, event_tm,watch_episode_sort,if_first_watch_shortplay
    from dwd.dwd_sensors_cd_video_startwatching_view
    where dt>=date_sub('${dt}',interval 10 day ) and dt<'${dt}'
),x1 as (
   select dt, product_id,user_id, series_id, min(unix_timestamp(event_tm)) tt2
   from watch_event
   where watch_episode_sort='1' and if_first_watch_shortplay='true'
   group by 1,2,3,4
)
select
    r.dt,
    r.source_types,
    r.push_type,
    if(b.user_id is not null and r.series_id=b.series_id,1,2) as is_toufang,
    r.product_id,
    r.user_id,
    r.series_id,
    now() as etl_time
from (
    select x1.dt, x2.source_types, x2.push_type, x1.product_id, x1.user_id, x1.series_id
    from x1
    join (
        select
            dt,
            case
                when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2] in (0,1) then 1 -- 普通弹窗
                when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=3 then 2 -- 充值返回推
                when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=4 then 3 -- 剧末推
                when split(activity_link, '_')[1]=202100 and split(activity_link, '_')[2]=9 then 4 -- 退出观看返回推
                when split(activity_link, '_')[1]=203200 then 5 -- 悬浮窗
                when split(activity_link, '_')[1]=204000 then 6 -- TAB栏
                when split(activity_link, '_')[1]=204100 then 7 -- banner
                when split(activity_link, '_')[1]=210010 then 8 -- push
                when split(activity_link, '_')[1]=210007 then 9 -- 串剧
                when split(activity_link, '_')[1]=203600 then 10 -- 开屏页
                when split(activity_link, '_')[1]=200200 then 11 -- 首页
                when split(activity_link, '_')[1]=200100 then 12 -- 追剧页
                when split(activity_link, '_')[1]=200400 then 13 -- 浏览历史页
                when split(activity_link, '_')[1]=201500 then 14 -- 剧集解锁记录
                when split(activity_link, '_')[1]=200700 then 15 -- 搜索页
                when split(activity_link, '_')[1]=203900 then 16 -- 搜索中间页
                when split(activity_link, '_')[1]=203100 then 17 -- 我的评论页
                when split(activity_link, '_')[1]=204600 then 18 -- edm
                when split(activity_link, '_')[1]=204700 then 19 -- for you
            end as source_types,
            if(split(activity_link, '_')[9] = 0, 0, 1) as push_type,
            product_id, login_id as user_id, split(activity_link, '_')[8] as series_id, unix_timestamp(event_tm) as tt1
        from ads.ads_sensors_cd_video_operationpositionexposure_view
        where dt >= date_sub('${dt}',interval 10 day) and dt < '${dt}'
        and cast(split(activity_link, '_')[8] as bigint) > 0 and cast(login_id as bigint) > 0
        group by 1,2,3,4,5,6,7
    )x2 on x1.dt=x2.dt and x1.product_id=x2.product_id and x1.user_id=x2.user_id and x1.series_id=x2.series_id and tt2-tt1<20 and tt2-tt1>=0
    where x2.source_types is not null
    group by 1,2,3,4,5,6
) r
left join (
    select Product_Id, User_Id, Book_Id as series_id
    from(
        select Product_Id,User_Id,Book_Id,install_date,
               row_number() over (partition by Product_Id,User_Id order by Install_Date desc ,Id desc ) rn
        from dwd.dwd_user_install_info_ed_view
        where dt>=date_sub('${dt}',interval 30 day) and dt<='${dt}' and Product_Id = 6833 and IsDelete != 1
          and User_Id>0 and Book_Id>0
    )t1
    where rn=1
) b
on r.product_id = b.Product_Id and r.user_id = b.user_id;
