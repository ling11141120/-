----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data38
-- task_version     : 1
-- update_time      : 2025-06-24 19:19:27
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data38
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data38;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data38
select     datetypes ,
           sum(charge_money) charge_money,
           sum(charge_money_rmb)  charge_money_rmb,
           sum(charge_order) charge_order,
           sum(charge_num) charge_num,
           NOW()
from (    -- ---海阅的------------------------
         select datetypes ,
                charge_money ,
                charge_money_rmb ,
                charge_order ,
                charge_num
         from ads.ads_charge_order
         where datetypes in(3,4)
         union all
         -- ---------海剧和国剧的-------------------------
         select (case when datetypes in(3,9,15,24,30) then 3 else 4 end)datetypes,
                charge_money,
                charge_money_rmb,
                charge_order,
                charge_num
         from ads.ads_report_short_vedio_charge_info
         where datetypes in (3,4, 9,10, 15,16, 24,25, 30,31)
         union all
-- --------------国阅的---------------------------
         select  if(date_types='cur_month' ,3,4) as datetypes,
                 charge_amt,
                 charge_amt_rmb,
                 charge_cnt,
                 charge_unt
         from ads.ads_cr_trade_recharge
         where date_types in ('cur_month','last_month')
           and self_type=0
     )  a
group by 1;
