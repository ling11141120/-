insert into ads.`ads_qa_srsv_recharge_monitoring_info_hi`
select
	a.dt,
	a.hour,
	6833 as product_id,
	a.mt,
	a.core,
	a.exposure_pv,
	a.exposure_uv,
	b.order_num,
	b.amount,
	b.base_amount,
	b.recharge_uv,
	round(amount/exposure_uv,4) as exposure_arpu,
	round(recharge_uv/exposure_uv,4) as exposure_cvr ,
	now() as etl_time
from (
	select dt,hour(event_tm) as hour,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt,ifnull(core,-99) as core,count(1) as exposure_pv,count(distinct login_id) as exposure_uv
	from ads.ads_sensors_cd_video_rechargeexposure_view
	where product_id = '6833'
	and dt>='${bf_3_dt}'
	group by 1,2,3,4
) a
left join
(
	select date(CreateTime) as dt,hour(CreateTime) as hour,OsType as mt,ifnull(Core,-99) as core,count(1) as order_num,sum(Amount)/100 as amount,sum(BaseAmount)/100 as base_amount,count(distinct UserId) as recharge_uv
	from ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di
	where ProductId=6833
	and CreateTime>='${bf_3_dt}'
	and TestFlag=0
	and OrderStatus=1
	group by 1,2,3,4
) b on a.dt=b.dt and a.hour=b.hour and a.mt=b.mt and a.core=b.core

union all

select
	a.dt,
	a.hour,
	a.product_id,
	a.mt,
	a.core,
	a.exposure_pv,
	a.exposure_uv,
	b.order_num,
	b.amount,
	b.base_amount,
	b.recharge_uv,
	round(amount/exposure_uv,4) as exposure_arpu,
	round(recharge_uv/exposure_uv,4) as exposure_cvr ,
	now() as etl_time
from (
	select dt,hour(event_tm) as hour,app_product_id as product_id,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt,ifnull(app_core_ver,-99) as core,count(1) as exposure_pv,count(distinct login_id) as exposure_uv
	from ads.ads_sensors_production_rechargeexposure_view
	where  app_product_id<>6833 and app_product_id is not null
	and dt>='${bf_3_dt}'
	group by 1,2,3,4,5
) a
left join
(
	  select
		  date(CreateTime) as dt,hour(CreateTime) as hour,ProductId as product_id,OsType as mt,ifnull(Core,-99) as core,
		  count(1) as order_num,sum(Amount)/100 as amount,sum(BaseAmount)/100 as base_amount,count(distinct UserId) as recharge_uv
		from ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di
		where ProductId <> 6833
		and CreateTime>='${bf_3_dt}'
		and TestFlag=0
		and OrderStatus=1
		group by 1,2,3,4,5
) b on a.dt=b.dt and a.hour=b.hour and a.mt=b.mt and a.core=b.core and a.product_id=b.product_id