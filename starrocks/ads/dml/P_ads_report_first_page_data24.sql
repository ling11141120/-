----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data24
-- task_version     : 1
-- update_time      : 2025-06-24 14:28:34
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data24
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data24;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data24
select DATE_FORMAT(concat(month,11),'%y-%m') as month2 ,
       sum(charge_item_amt) as 充值,
       sum(charge_amt) as 分成后充值,
       sum(cost_amt) as 推广费用 ,
       (sum(cost_amt)/sum(charge_amt)) as 投放比,
       (sum(charge_amt)  - sum(cost_amt)) as 扣除推广后充值,
       DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months,
       NOW()
from ads.ads_cr_recharge_cost_moni
where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
  and product_id in (6773)
group by 1;
