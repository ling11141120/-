----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_user_amt
-- workflow_version : 24
-- create_user      : admin
-- task_name        : dws_advertisement_user_amt
-- task_version     : 3
-- update_time      : 2023-12-04 15:19:21
-- sql_path         : \starrocks\tbl_dws_advertisement_user_amt\dws_advertisement_user_amt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_advertisement_user_amt
select
 DATE_FORMAT(DATE_ADD(create_time,INTERVAL -13 Hour),'%Y-%m-%d') dt
,user_id
,product_id
,core
,mt
,SUM(case mt when 1 then valueMicros else valueMicros/1000000.0 end) amount
,CURRENT_TIMESTAMP() etl_tm
from(

	select
	 user_id
	,product_id
	,mod(appId DIV 1000,1000) as core
	,mt
	,create_time
	,case get_json_int(s0,"$.precisionType") when 2 then get_json_double(s0,"$.valueMicros") /1000.0 else get_json_double(s0,"$.valueMicros") end  as valueMicros
	from dwd.dwd_readerlog_commonactionlog_view
	where dt >= DATE_ADD('${bf_1_dt}',-3) and Action = 'AdMobPainEvent'
	and create_time >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL 13 Hour),INTERVAL -2 DAY)
) res
where valueMicros >0
group by 1,2,3,4,5
union all
select
 DATE_FORMAT(DATE_ADD(create_tm,INTERVAL -13 Hour),'%Y-%m-%d') as dt
,userid
,6833 as productid
,1 as core
,4 as mt
,sum(value_micros)/1000000.0 as amount
,CURRENT_TIMESTAMP() etl_tm
from (
	select
	 case precision_tp when 2 then value_micros / 1000.0 else value_micros end as value_micros
	,account_id as userid
	,create_tm
	from dwd.dwd_short_video_admob_paid_event_view
	where dt >= DATE_ADD('${bf_1_dt}',-3)
	and create_tm >= DATE_ADD(DATE_ADD('${bf_1_dt}',INTERVAL 13 Hour),INTERVAL -2 DAY)
) res
where value_micros >0
GROUP BY 1,2,3,4,5;
