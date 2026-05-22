----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_p_di
-- workflow_version : 46
-- create_user      : yanxh
-- task_name        : 前置删除节点
-- task_version     : 1
-- update_time      : 2026-04-28 17:52:37
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_p_di\前置删除节点
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_advertisement_user_position_amt_p_di where dt>= '${bf_1_dt}' and dt<='${dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_p_di_his
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : delete_data
-- task_version     : 3
-- update_time      : 2025-08-14 10:46:12
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_p_di_his\delete_data
----------------------------------------------------------------
-- 前置SQL语句
delete from  dwd.dwd_advertisement_user_position_amt_p_di where  dt>= '${bf_1_dt}' and  dt<='${dt}';

-- SQL语句
select 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_p_di_his
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : dwd_advertisement_user_position_amt_p_di_read
-- task_version     : 11
-- update_time      : 2025-08-14 10:46:12
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_p_di_his\dwd_advertisement_user_position_amt_p_di_read
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_advertisement_user_position_amt_p_di
with tmp_data AS (
    select
        productid  as  product_id
         , userid as user_id
         ,mod(appId DIV 1000,1000) as core
         ,mt
         ,appver
         ,CreateTime  as create_time
         ,replace(substring_index(replace(substr(s0,instr(s0,'"adUnitId":')),'"adUnitId":',''),',',1),'"','' ) as ad_unit
         ,substring_index(replace(substr(s0,instr(s0,'"positionId":')),'"positionId":',''),',',1)  as position_id
         ,replace(substring_index(replace(substr(s0,instr(s0,'"platform":')),'"platform":',''),',',1),'"','' )  as platform
         ,replace(substring_index(replace(substr(s0,instr(s0,'"precisionType":')),'"precisionType":',''),',',1),'"','' )  as precisionType
         ,replace(substring_index(replace(substr(s0,instr(s0,'"valueMicros":')),'"valueMicros":',''),',',1),'"','' )    as valueMicros
         ,replace(substring_index(replace(substr(s0,instr(s0,'"mediationAdapterClassName":')),'"mediationAdapterClassName":',''),',',1),'"','' )   as platform_source
         ,substring_index(replace(substr(s0,instr(s0,'"main_strategy_id":')),'"main_strategy_id":',''),',',1)   as main_strategy_id
         ,substring_index(replace(substr(s0,instr(s0,'"ad_strategy_id":')),'"ad_strategy_id":',''),',',1)   as event_strategy_id
         ,substring_index(replace(substr(s0,instr(s0,'"programme_id":')),'"programme_id":',''),',',1)  as programme_id
    from  ods_log.ods_readerlog_xx_log_commonactionlog
    where dt >= '${bf_1_dt}'
      and  dt<= '${dt}'
      and Action = 'AdMobPainEvent'
),
amt as (
    select
    DATE(a.create_time) dt
   ,a.create_time
   ,a.product_id
   ,a.user_id
   ,a.core
   ,a.mt
   ,a.appver
   ,a.ad_unit
   ,a.position_id
   ,if(a.platform is null,'Admob',a.platform )  as ads_name -- 广告平台 (adomob,topon,max)
   ,a.platform_source
   ,a.main_strategy_id
   ,a.event_strategy_id
   ,a.programme_id
-- ,SUM(case mt when 1 then a.valueMicros else a.valueMicros/1000000.0 end) amount
   ,SUM(case  when mt=4 and (platform='Admob' or platform is null or platform='') then a.valueMicros/1000000.0 else a.valueMicros end) amount
   ,CURRENT_TIMESTAMP() etl_tm
from(
    select
      product_id
        ,  user_id
        , core
        ,mt
        ,appver
        , create_time
        ,  ad_unit
        , position_id
        , platform
        ,case precisionType when 2 then valueMicros /1000.0 else valueMicros end  as valueMicros
        , platform_source
        , main_strategy_id
        , event_strategy_id
        , programme_id
    from  tmp_data
    ) a
where a.valueMicros >0
-- and  user_id =144609504 and create_time='2024-01-16 04:39:50' and ad_unit='ca-app-pub-1669209234634531/7738994183'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    )

select
    a.dt
     ,a.create_time
     ,a.product_id
     ,a.user_id
     ,a.core as corever
     ,a.mt
     ,a.appver
     ,a.ad_unit
     ,a.positions as position_id
     ,a.ads_name
     ,a.platform_source as ads_source
     ,a.ad_show_type
     ,main_strategy_id as main_strategy_id
     ,event_strategy_id as event_strategy_id
     ,programme_id
     ,a.amount as ad_position_amt
     ,now() as etl_tm
from
    (  -- ---------旧版本数据没有 position_id 关联取最小位置的广告数据-----------------------------
        select
            amt.dt,amt.product_id,amt.user_id,amt.core,amt.mt,amt.appver,amt.create_time,amt.ad_unit,d.ad_show_type,d.positions,amt.amount,amt.ads_name,amt.platform_source,
            amt.main_strategy_id,  amt.event_strategy_id,amt.programme_id
        from amt
                 left join
             (
                 select product_id, unit_adid,ad_show_type,min(ad_position) positions from dim.dim_app_adplatform_unit_id_info where status =1 group by 1,2 ,3
             ) d on amt.product_id=d.product_id and amt.ad_unit=d.unit_adid
        where  amt.position_id is null

        union all -- 新版本数据 客户端会上报position_id （配置表中会存在广告单元id与position_id 一样的重复多条的数据，需要去重后关联获取广告类型）-----------

        select
            amt.dt,amt.product_id,amt.user_id,amt.core,amt.mt,amt.appver,amt.create_time,amt.ad_unit,d.ad_show_type,amt.position_id as positions ,amt.amount,amt.ads_name,amt.platform_source ,
            amt.main_strategy_id,  amt.event_strategy_id,amt.programme_id
        from amt
                 left join
             (
                 select product_id, unit_adid,ad_show_type, ad_position as positions
                 from (
                          select   product_id, unit_adid,ad_show_type, ad_position ,count(1) from dim.dim_app_adplatform_unit_id_info where status =1   group by 1,2 ,3,4
                      ) a
             ) d on amt.product_id=d.product_id and amt.ad_unit=d.unit_adid and amt.position_id=d.positions
        where  amt.position_id is not  null
    ) a
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_advertisement_user_position_amt_p_di_his
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : dwd_advertisement_user_position_amt_p_di_short_video
-- task_version     : 3
-- update_time      : 2025-08-14 10:46:12
-- sql_path         : \starrocks\tbl_dwd_advertisement_user_position_amt_p_di_his\dwd_advertisement_user_position_amt_p_di_short_video
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_advertisement_user_position_amt_p_di
  with  us as (
	 select
	DATE(create_tm) as dt
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
		select
		 case PrecisionType when 2 then ValueMicros / 1000.0 else ValueMicros end as value_micros
		,AccountId as user_id, core AS core
		,createtime as create_tm,AdUnitId as ad_unit,Appver,POSITION ,MediationAdapterClassName, IFNULL(adsPlatform,1) adsPlatform ,mt    --  adsPlatform:null 和1  表示 admob ,将null值转换为 1
		,mainstrategyid,eventstrategyid
	from  ods.ods_tidb_short_video_admob_paid_event
		where
	createtime >= '${bf_1_dt}'  and  date(createtime)<='${dt}' and AdUnitId !='ca-app-pub-1669209234634531/6952416968' -- 这个是测试数据 直接剔除----
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
