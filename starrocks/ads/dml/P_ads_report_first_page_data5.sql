----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data5
-- task_version     : 1
-- update_time      : 2025-06-24 18:54:34
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data5
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data5;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data5
select DATE_FORMAT(concat(month,11),'%y-%m') as month2 ,
       sum(charge_itemcount) as 充值,
       sum(charge_money) as 分成后充值,
       sum(spend) as 推广费用 ,
       (sum(spend)/sum(charge_money)) as 投放比,
       (sum(charge_money)  - sum(spend)) as 扣除推广后充值,
       DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months,
       NOW()
from ads.ads_trade_month_recharge_toufang
where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
  and product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399)
group by 1;
