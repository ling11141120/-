----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sr_subscribe_order_value_di
-- workflow_version : 4
-- create_user      : hufengju
-- task_name        : ads_bi_sr_subscribe_order_value_di
-- task_version     : 4
-- update_time      : 2025-01-23 10:28:49
-- sql_path         : \starrocks\tbl_ads_bi_sr_subscribe_order_value_di\ads_bi_sr_subscribe_order_value_di
----------------------------------------------------------------
-- SQL语句
--=============250117调度===================
insert into ads.`ads_bi_sr_subscribe_order_value_di`
select b.datestr as dt,user_id,order_id,ifnull(item_count/datediff(date(vip_expire_time),dt),0) as order_value,now() as etl_time
from ads.ads_bi_trade_user_subscribe_di a
left join dim.dim_date b on a.dt<=b.datestr and date(a.vip_expire_time) >= b.datestr
where a.dt = '${bf_1_dt}'
and datediff(date(vip_expire_time),date_sub(dt,interval 1 day))>0
;
