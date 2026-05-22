----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_payment_link_detail_ed
-- workflow_version : 3
-- create_user      : doupz
-- task_name        : dws_trade_payment_link_detail_ed
-- task_version     : 2
-- update_time      : 2024-01-24 14:24:03
-- sql_path         : \starrocks\tbl_dws_trade_payment_link_detail_ed\dws_trade_payment_link_detail_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_trade_payment_link_detail_ed
select
 step1.dt
,step1.rid rid_s1
,step1.uuid
,step1.product_id
,step1.user_id
,step1.core
,step1.mt
,step1.app_version
,step1.page_id
,step1.page_name
,step1.item_id
,step1.recharge_amount
,step1.present_gift
,step1.real_recharge
,step1.parent_group_id
,step1.group_id
,step1.pay_id
,step1.pay_type
,step2.order_id
,step2.jump_url
,step1.event_time event_time_s1
,step2.rid rid_s2
,step2.is_success is_success_s2
,step2.error_parameter error_parameter_s2
,step2.event_time event_time_s2
,step3.rid rid_s3
,step3.is_success is_success_s3
,step3.error_parameter error_parameter_s3
,step3.event_time event_time_s3
,step4.rid rid_s4
,step4.is_success is_success_s4
,step4.error_parameter error_parameter_s4
,step4.event_time event_time_s4
,step5.rid rid_s5
,step5.is_success is_success_s5
,step5.error_parameter error_parameter_s5
,step5.event_time event_time_s5
,step6.rid rid_s6
,step6.is_success is_success_s6
,step6.error_parameter error_parameter_s6
,step6.event_time event_time_s6
,step7.rid rid_s7
,step7.is_success is_success_s7
,step7.error_parameter error_parameter_s7
,step7.event_time event_time_s7
,step8.rid rid_s8
,step8.Ext2 ext2
,step8.event_time event_time_s8
,step9.rid rid_s9
,step9.event_time event_time_s9
,step10.rid rid_s10
,step10.is_success is_success_s10
,step10.error_parameter error_parameter_s10
,step10.event_time event_time_s10
,CURRENT_TIMESTAMP() etl_time
from
(
    select
     rid
    ,product_id
    ,user_id
    ,core
    ,mt
    ,app_version
    ,uuid
    ,page_id
    ,page_name
    ,item_id
    ,recharge_amount
    ,present_gift
    ,real_recharge
    ,parent_group_id
    ,group_id
    ,pay_id
    ,pay_type
    ,event_time
    ,dt
    ,order_id
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT('${bf_1_dt}','%Y-%m-%d')
    and step = '111110010'
) step1 left join
(
    select
     rid
    ,uuid
    ,order_id
    ,jump_url
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110020'
) step2 on step1.uuid=step2.uuid
left join
(
    select
     rid
    ,uuid
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110030'
) step3 on step1.uuid=step3.uuid
left join
(
    select
     rid
    ,uuid
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110040'
) step4 on step1.uuid=step4.uuid
left join
(
    select
     rid
    ,uuid
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110050'
) step5 on step1.uuid=step5.uuid
left join
(
    select
     rid
    ,uuid
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110060'
) step6 on step1.uuid=step6.uuid
left join
(
    select
     rid
    ,uuid
    ,is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111110070'
) step7 on step1.uuid=step7.uuid
left join
(
    select
     id as rid
    ,uuid
    ,order_id
    ,order_serial_id
    ,coo_order_id
    ,coo_notify_time as event_time
    ,Ext2
    from dwd.dwd_trade_sharpenginepaycenter_payorder_view
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and order_status = 1
) step8 on step2.order_id=step8.order_id
left join
(
    select
     id as rid
    ,order_id
    ,add_time as event_time
    from dwd.dwd_trade_sharpenginepaycenter_gporderchecklist
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and is_losed=1
    and instr(order_type,'dingyue') =0
) step9 on step8.coo_order_id=step9.order_id
left join
(
    select
     rid
    ,uuid
    ,true is_success
    ,error_parameter
    ,event_time
    from dwd.dwd_trade_sensors_log_payment_link
    where dt between DATE_FORMAT('${bf_3_dt}','%Y-%m-%d') and DATE_FORMAT(DATE_ADD('${bf_1_dt}',1),'%Y-%m-%d')
    and step = '111111010'
) step10 on step1.uuid=step10.uuid;
