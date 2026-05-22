----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data32
-- task_version     : 1
-- update_time      : 2025-06-23 18:03:51
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data32
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data32;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data32
select b.ProductTypeName, month2,  sum(充值) 充值,sum(分成后充值) 分成后充值,sum(推广费用) 推广费用 ,sum(投放比) 投放比,sum(扣除推广后充值) 扣除推广后充值,sum(总充值) 总充值, months, NOW()
from
    (
        SELECT Product_Id,DATE_FORMAT(concat(month,11),'%y-%m') as month2,sum(charge_itemcount) as 充值,round(sum(charge_money),0) as 分成后充值,sum(spend) as 推广费用 ,
               (sum(spend)/sum(charge_money)) as 投放比,(sum(charge_money)  - sum(spend)) as 扣除推广后充值,null as 总充值,DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months
        FROM ads.ads_trade_month_recharge_toufang  a
        where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
          and a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,6833,6883)
        GROUP BY 1,2
        union all
        SELECT Product_Id,DATE_FORMAT(concat(month,11),'%y-%m') as month2,sum(charge_item_amt) as 充值,round(sum(charge_amt),0) as 分成后充值,sum(cost_amt) as 推广费用 ,
               (sum(cost_amt)/sum(charge_amt)) as 投放比,(sum(charge_amt)  - sum(cost_amt)) as 扣除推广后充值,null as 总充值,DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months
        FROM ads.ads_cr_recharge_cost_moni a
        where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
          and product_id in (6773)
        GROUP BY 1,2
    )  a
        left join dim.DIM_ProductType  b on a.Product_Id = b.ProductId
        and b.ProductTypeName not in ('韩语阅读','菲律宾语')
group by 1,2,9;
