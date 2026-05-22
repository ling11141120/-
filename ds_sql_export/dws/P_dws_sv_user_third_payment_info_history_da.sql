----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_sv_user_third_payment_info_history_da
-- workflow_version : 1
-- create_user      : hufengju
-- task_name        : dws_sv_user_third_payment_info_history_da
-- task_version     : 1
-- update_time      : 2024-12-23 15:27:08
-- sql_path         : \starrocks\tbl_dws_sv_user_third_payment_info_history_da\dws_sv_user_third_payment_info_history_da
----------------------------------------------------------------
-- SQL语句
-- ============调度：海剧用户订单支付方式历史数据统计==============================
insert into dws.`dws_sv_user_third_payment_info_history_da`
select '${bf_1_dt}' as dt,product_id,user_id,right(system_type,2) as payment_code,subpay_type as history_payment ,count(1),now() as etl_tm
from dwd.dwd_trade_short_video_payorder
where status=0 and test_flag=0
and dt<'${dt}'
group by 1,2,3,4,5
;
