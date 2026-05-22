----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data48
-- task_version     : 1
-- update_time      : 2025-06-24 19:19:27
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data48
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data48;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data48
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
  and product_id in (6833)
group by 1;
