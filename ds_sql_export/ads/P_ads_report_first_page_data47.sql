----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data47
-- task_version     : 1
-- update_time      : 2025-06-24 19:19:27
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data47
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data47;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data47
SELECT ProductTypeName,
       DATE_FORMAT(concat(month,11),'%y-%m') as month2,
       sum(charge_itemcount) as 充值,
       round(sum(charge_money),0) as 分成后充值,
       sum(spend) as 推广费用 ,
       (sum(spend)/sum(charge_money)) as 投放比,
       (sum(charge_money)  - sum(spend)) as 扣除推广后充值,
       null as 总充值,
       DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months,
       NOW()
FROM ads.ads_trade_month_recharge_toufang  a
left join dim.DIM_ProductType  b
    on a.Product_Id = b.ProductId
    and b.ProductTypeName not in ('韩语阅读','菲律宾语')
where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
  and product_id in (6833)
GROUP BY 1,2;
