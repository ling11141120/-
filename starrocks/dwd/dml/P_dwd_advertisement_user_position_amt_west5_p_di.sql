----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_west5_p_di_bf_1_dt
-- workflow_version : 5
-- create_user      : xixg
-- task_name        : delete_data_bf_1_dt
-- task_version     : 2
-- update_time      : 2025-07-17 16:16:26
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_west5_p_di_bf_1_dt\delete_data_bf_1_dt
----------------------------------------------------------------
-- 前置SQL语句
delete from  dwd.dwd_advertisement_user_position_amt_west5_p_di where  dt= '${bf_1_dt}';

-- SQL语句
select 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_west5_p_di_bf_1_dt
-- workflow_version : 5
-- create_user      : xixg
-- task_name        : dwd_advertisement_user_position_amt_p_di_short_video_bf_1_dt
-- task_version     : 5
-- update_time      : 2026-04-30 15:41:43
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_west5_p_di_bf_1_dt\dwd_advertisement_user_position_amt_p_di_short_video_bf_1_dt
----------------------------------------------------------------
-- SQL语句
-- 海剧的
insert into dwd.dwd_advertisement_user_position_amt_west5_p_di
with  us as (
    select
    '${bf_1_dt}' AS dt
   ,create_tm
   ,6833 as product_id
   ,user_id
   ,IFNULL(core,1) AS core
   ,mt
   ,Appver as app_ver
   ,ad_unit
   ,POSITION
   ,if(adsPlatform=2,'Max','Admob') as ads_name
   ,MediationAdapterClassName as ads_source
   ,mainstrategyid as main_strategy_id
   ,eventstrategyid as event_strategy_id
   ,sum(case when adsPlatform=2 then value_micros else value_micros/1000000.0 end) as amount
-- ,SUM(case  when mt=4 and adsPlatform=1  then value_micros/1000000.0 else value_micros end) amount  -- 安卓且是admob的收入除以1000000  adsPlatform:null 和1  表示 admob
from (
    select ValueMicros  as value_micros
        ,AccountId as user_id, core AS core
        ,createtime as create_tm,AdUnitId as ad_unit,Appver,POSITION ,MediationAdapterClassName, IFNULL(adsPlatform,1) adsPlatform ,mt    --  adsPlatform:null 和1  表示 admob ,将null值转换为 1
        ,mainstrategyid,eventstrategyid
    from  ods.ods_tidb_short_video_admob_paid_event
    where
    createtime >= '${bf_1_dt}'  and  date(createtime)<='${dt}' and AdUnitId !='ca-app-pub-1669209234634531/6952416968' -- 这个是测试数据 直接剔除----
    and DATE(date_add(createtime,INTERVAL -13 HOUR)) = '${bf_1_dt}'
    -- and adsPlatform=2
    -- and AdUnitId='ca-app-pub-1669209234634531/2070058392'
    ) res
where value_micros >0
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
    )

    --  select dt,sum(amount) from us where dt>='2024-08-01' group by 1 order by 1 desc  验证数据

        ,
    p as (
-- -------本身自带position的 关联配置表获取广告类型 ads_type ,优先取广告状态开启的---
select us.dt,us.product_id,us.user_id,us.core,us.mt,us.app_ver,us.ad_unit,us.create_tm,us.position,us.amount,b.ads_type,us.ads_name,us.ads_source,us.main_strategy_id,us.event_strategy_id
from us
    left join
    (
    -- - 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
    select unit_adid,position_id,ads_type from dim.dim_short_video_ads_unit_adid_view QUALIFY row_number() over(partition by unit_adid order by if(status in (0,2),2,status )) =1

    ) b on us.ad_unit=b.unit_adid
where us.POSITION >0
    )  ,

    n as  (
select us.dt,us.product_id,us.user_id,us.core,us.mt,us.app_ver,us.ad_unit,us.create_tm,b.position_id as position,us.amount,b.ads_type,us.ads_name,us.ads_source,us.main_strategy_id,us.event_strategy_id
from us
    left join
    -- ----------将广告单元id进行排序
    (-- - 按广告单元id进行开窗排序，优先取状态为开启的进行匹配（status in (0,2) 为关闭状态）
    select unit_adid,position_id,ads_type from dim.dim_short_video_ads_unit_adid_view QUALIFY row_number() over(partition by unit_adid order by if(status in (0,2),2,status )) =1
    ) b
on us.ad_unit=b.unit_adid
where (us.POSITION <0  or us.position is null )
    )

select
    dt,create_tm,product_id,user_id,core,mt,app_ver,ad_unit,position as positon_id,ads_name,ads_source,ads_type as ad_show_type,
    main_strategy_id,event_strategy_id,null as programme_id,amount as ad_position_amt,now() as etl_tm
from p
union all
select
    dt,create_tm,product_id,user_id,core,mt,app_ver,ad_unit,position as positon_id,ads_name,ads_source,ads_type as ad_show_type,
    main_strategy_id,event_strategy_id,null as programme_id,amount as ad_position_amt,now() as etl_tm
from n;
