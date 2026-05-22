----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_base_mid
-- task_version     : 8
-- update_time      : 2025-04-27 19:42:00
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_base_mid
----------------------------------------------------------------
-- SQL语句
-- 数据别删，上游表只保留了10天的数据
insert into ads.ads_report_sv_AB_experiment_mul_base_mid
select
    a.dt,
    a.source_types,
    a.push_type,
    if(b.user_id is not null and a.series_id = b.series_id,1,2) as is_toufang,
    ifnull(a.product_id,-99) as product_id,
    ifnull(a.lang_id,-99) as lang_id,
    ifnull(a.user_id,-99) as user_id,
    ifnull(a.series_id,-99) as series_id,
   array_filter(array_distinct(array_agg(a.element_id)),x->x is not null) as element_id,
   array_filter(array_distinct(array_agg(a.element_type)),x->x is not null) as element_type,
   now() as etl_time
from(
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
        product_id, app_lang_id as lang_id, login_id as user_id, split(activity_link, '_')[8] as series_id, element_id, element_type
    from ads.ads_sensors_cd_video_operationpositionexposure_view
    where dt>=date_sub('${dt}',interval 10 day ) and dt<'${dt}'
    and cast(split(activity_link, '_')[8] as bigint) > 0 and cast(login_id as bigint) > 0
    group by 1,2,3,4,5,6,7,8,9
) a
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
on a.product_id = b.Product_Id and a.user_id = b.user_id
where a.source_types is not null
group by 1,2,3,4,5,6,7,8;
