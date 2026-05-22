----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data23
-- task_version     : 2
-- update_time      : 2025-06-24 14:23:02
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data23
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_report_first_page_data23;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data23
SELECT ProductTypeName,
       DATE_FORMAT(concat(month,11),'%y-%m') as month2,
       sum(charge_item_amt) as 充值,
       round(sum(charge_amt),0) as 分成后充值,
       sum(cost_amt) as 推广费用 ,
       (sum(cost_amt)/sum(charge_amt)) as 投放比,
       (sum(charge_amt)  - sum(cost_amt)) as 扣除推广后充值,
       null as 总充值,
       DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months,
       NOW()
FROM ads.ads_cr_recharge_cost_moni a
left join dim.DIM_ProductType  b
    on a.Product_Id = b.ProductId
    and b.ProductTypeName not in ('韩语阅读','菲律宾语')
where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
  and product_id in (6773)
GROUP BY 1,2;
