----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data37
-- task_version     : 2
-- update_time      : 2025-06-25 14:19:56
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data37
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data37;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data37
select     datetypes ,
           sum(charge_money) charge_money,
           sum(charge_money_rmb)  charge_money_rmb,
           sum(charge_order) charge_order,
           sum(charge_num) charge_num,
           NOW()
from (
         select datetypes ,
                charge_money ,
                charge_money_rmb ,
                charge_order ,
                charge_num
         from ads.ads_charge_order
         where datetypes in(5,6,7)
         union all
         select (case when datetypes in(5,11,17,26,32) then 5
                      when datetypes in(6,12,18,27,33) then 6 else 7
             end)datetypes,
                charge_money,
                charge_money_rmb,
                charge_order,
                charge_num
         from ads.ads_report_short_vedio_charge_info
         where datetypes in (5,6,21 ,11,12,19 ,17,18,20 ,26,27,34 ,32,33,35 )
         union all
-- --------------国阅的---------------------------
         select   case when date_types='cur_quarter'  then 5 when date_types='last_quarter' then 6 else 7 end  as datetypes,
                  charge_amt,
                  charge_amt_rmb,
                  charge_cnt,
                  charge_unt
         from ads.ads_cr_trade_recharge
         where date_types in ('cur_quarter','last_quarter','last_whole_quarter')
           and self_type=0
     )  a
group by 1;
