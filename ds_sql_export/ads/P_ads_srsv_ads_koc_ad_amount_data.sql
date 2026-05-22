----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_ads_koc_ad_amount_data
-- workflow_version : 16
-- create_user      : hufengju
-- task_name        : ads_srsv_ads_koc_ad_amount_data
-- task_version     : 15
-- update_time      : 2025-02-08 11:26:07
-- sql_path         : \starrocks\tbl_ads_srsv_ads_koc_ad_amount_data\ads_srsv_ads_koc_ad_amount_data
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_srsv_ads_koc_ad_amount_data where dt>='${bf_3_dt}';

-- SQL语句
insert into ads.`ads_srsv_ads_koc_ad_amount_data`
with active as (
	select *
	from
	(
		select
			a.product_id,
			a.user_id,
			a.resource_id,
			a.begin_time,
			a.end_time,
			a.ad_id,
			cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Mt=', -1),'|',1) as int ) as mt,
			cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Chl2=', -1),'|',1) as string ) as chl,
			ifnull(c.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language,
			cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Core=', -1),'|',1) as int ) as core,
			a.koc_text,
			date(a.create_time) as user_dt
		from  dwd.dwd_srsv_advertisement_koc_attribution_record_view  a
		left join (
			select 6833 as product_id,series_id as book_id, language as languageid
			from dim.dim_short_video_series_view
		union all
			select product_id,book_id,languageid
			from  dim.dim_shuangwen_book_read_consume_info
			) c on a.product_id = c.product_id and a.resource_id = c.book_id
	) a where a.begin_time>'${bf_30_dt}'
)
select b.dt ,
		  a.product_id,
		  a.ad_id,
		  if(max(a.product_id)=6833,2,1) as project_tp, -- 1:海阅 2：海剧
		  max(a.resource_id) as book_id,
		  max(a.mt) as mt,
		  max(a.core) as core,
		  'koc' as source_chl,
		  max(a.chl) as chl,
		  max(a.current_language) as current_language ,
		  max(a.koc_text) as koc_code,
		  sum(b.amount) as ad_amount,
		  now() as etl_tm
from active a
left join (
	select
	 DATE_FORMAT(DATE_ADD(create_time,INTERVAL -13 Hour),'%Y-%m-%d') dt
	,user_id
	,product_id
	,core
	,mt
	,(case mt when 1 then valueMicros else valueMicros/1000000.0 end) amount
	,DATE_ADD(create_time,INTERVAL -13 Hour) create_time
	from(
		select
		 user_id
		,product_id
		,mod(appId DIV 1000,1000) as core
		,mt
		,create_time
		,case get_json_int(s0,"$.precisionType") when 2 then get_json_double(s0,"$.valueMicros") /1000.0 else get_json_double(s0,"$.valueMicros") end  as valueMicros
		from dwd.dwd_readerlog_commonactionlog_view
		where dt >= DATE_ADD('${bf_1_dt}',-3) and dt<='${dt}' and Action = 'AdMobPainEvent'
		and create_time >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL 13 Hour),INTERVAL -2 DAY)
	) res
	where valueMicros >0
) b on a.product_id<>6833 and  a.user_id= b.user_id and b.create_time>=a.begin_time    and b.create_time<a.end_time
where b.user_id is not null
group by 1,2,3

union all

select b.dt ,
		  a.product_id,
		  a.ad_id,
		  if(max(a.product_id)=6833,2,1) as project_tp, -- 1:海阅 2：海剧
		  max(a.resource_id) as book_id,
		  max(a.mt) as mt,
		  max(a.core) as core,
		  'koc' as source_chl,
		  max(a.chl) as chl,
		  max(a.current_language) as current_language ,
		  max(a.koc_text) as koc_code,
		  sum(b.amount) as ad_amount,
		  now() as etl_tm
from active a
left join (
	select
	 DATE_FORMAT(DATE_ADD(create_tm,INTERVAL -13 Hour),'%Y-%m-%d') as dt
	,userid as user_id
	,6833 as productid
	,1 as core
	,4 as mt
	,(value_micros)/1000000.0 as amount
	,DATE_ADD(create_tm,INTERVAL -13 Hour) create_time
	from (
		select
		 case precision_tp when 2 then value_micros / 1000.0 else value_micros end as value_micros
		,account_id as userid
		,create_tm
		from dwd.dwd_short_video_admob_paid_event_view
		where dt >= DATE_ADD('${bf_1_dt}',-3) and dt<='${dt}'
		and create_tm >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL 13 Hour),INTERVAL -2 DAY)
	) res
	where value_micros >0
) b on a.product_id=6833 and  a.user_id= b.user_id and b.create_time>=a.begin_time    and b.create_time<a.end_time
where b.user_id is not null
group by 1,2,3;
