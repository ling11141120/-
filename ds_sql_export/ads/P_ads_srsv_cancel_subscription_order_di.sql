----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_cancel_subscription_order_di
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : ads_srsv_cancel_subscription_order_di
-- task_version     : 2
-- update_time      : 2024-12-09 14:18:27
-- sql_path         : \starrocks\tbl_ads_srsv_cancel_subscription_order_di\ads_srsv_cancel_subscription_order_di
----------------------------------------------------------------
-- SQL语句
--==================调度==================================
insert into ads.`ads_srsv_cancel_subscription_order_di`
select a.dt,a.order_id,b.core,b.mt,b.current_language2,b.country,a.user_id,a.sub_pay_type,a.amount,now() as etl_time
from (
	select  a.dt,b.product_id,b.Order_Serial_Id as order_id ,b.user_id ,b.coo_order_id ,b.core ,b.Os_Type as mt,b.sub_pay_type as sub_pay_type ,b.Amount as amount
	from ods_log.`ods_es_sr_cancel_subscription_order_di` a
	left join dwd.dwd_trade_sharpenginepaycenter_payorder_view b on a.order_id =b.coo_order_id
	where b.user_id  is not null
	and a.dt='${bf_1_dt}'
	group by 1,2,3,4,5,6,7,8,9
) a
left join (
	select product_id,id as user_id,corever as core ,mt,current_language2,reg_country as country
	from dim.dim_user_account_info_view
	union all
	select product_id, user_id,corever as core,mt,current_language2,reg_country as country
    from dim.dim_short_video_user_accountinfo
) b on a.product_id = b.product_id and a.user_id = b.user_id
;
