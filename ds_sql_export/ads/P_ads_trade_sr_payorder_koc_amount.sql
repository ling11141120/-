----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_trade_sr_payorder_koc_amount
-- workflow_version : 10
-- create_user      : hufengju
-- task_name        : ads_trade_sr_payorder_koc_amount
-- task_version     : 6
-- update_time      : 2025-02-11 11:47:30
-- sql_path         : \starrocks\sch_ads_trade_sr_payorder_koc_amount\ads_trade_sr_payorder_koc_amount
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_trade_sr_payorder_koc_amount where dt>='${bf_30_dt}';

-- SQL语句
--====================调度===========================================
insert into ads.ads_trade_sr_payorder_koc_amount
select a.dt,a.product_id,a.book_id,sum(a.amount * d.SplitRatio/100) as koc_amount,now() as etl_time
from
(
	-- 海阅的阅币消耗---
	select dt,product_id,user_id,amount/100 as amount,book_id,createtime as create_time
	from  dwd.dwd_consume_user_consume
	where dt>='${bf_30_dt}' and dt<'${dt}'
	and types =1
	and pay_type !=1103
) a
inner join  ------订单关联归因表，确认归属koc的消耗
dwd.dwd_srsv_advertisement_koc_attribution_record_view b
	on b.product_id=a.product_id and b.user_id= a.user_id and b.resource_id=a.book_id
     and a.create_time>=b.begin_time
     and a.create_time<b.end_time
left join
	ods.ods_tidb_koc_codeinfo c on c.KocCode = b.koc_text
left join
	ods.ods_tidb_koc_institutioncfg_da d on c.InstitutionId = d.InstitutionId and d.ProjectType=1
group by 1,2,3
;
