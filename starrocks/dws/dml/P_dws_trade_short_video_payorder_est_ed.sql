----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_short_video_payorder_est_ed
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dws_trade_short_video_payorder_est_ed
-- task_version     : 3
-- update_time      : 2024-11-21 16:47:46
-- sql_path         : \starrocks\tbl_dws_trade_short_video_payorder_est_ed\dws_trade_short_video_payorder_est_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_trade_short_video_payorder_est_ed
select  date(date_add(create_time,interval -13 hour)) as dt,
		product_id,user_id,
        sum(if(status = 0 and item_count > 0,item_count,0)) as pay_amt,
        sum(if(status = 0 and base_amount > 0,base_amount,0))/100 as received_amt,
        sum(if(status = 1 and item_count > 0,item_count,0)) as refund_amt,
        sum(if(status = 1 and base_amount > 0,base_amount,0))/100 as refund_received_amt,
        sum(if(status = 0 and item_count > 0,1,0)) as pay_cnt,
        sum(if(status = 1 and item_count > 0,1,0)) as refund_cnt,
        max(if(status = 0 and item_count > 0,item_count,0)) as max_pay_amt,
        min(if(status = 0 and item_count > 0,item_count,0)) as min_pay_amt,
        now() as etl_time
from dwd.dwd_trade_short_video_payorder
where date(date_add(create_time,interval -13 hour)) = '${bf_1_dt}' and product_id = 6833 and test_flag = 0
group by 1,2,3;
