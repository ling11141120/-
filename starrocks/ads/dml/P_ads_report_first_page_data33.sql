----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_report_first_page
-- workflow_version : 21
-- create_user      : xixg
-- task_name        : ads_report_first_page_data33
-- task_version     : 1
-- update_time      : 2025-06-24 19:19:27
-- sql_path         : \starrocks\sch_ads_report_first_page\ads_report_first_page_data33
----------------------------------------------------------------
-- 前置SQL语句
TRUNCATE TABLE ads.ads_report_first_page_data33;

-- SQL语句
INSERT INTO ads.ads_report_first_page_data33
select   month2,
         sum(充值) 充值,
         sum(分成后充值) 分成后充值,
         sum(推广费用) 推广费用 ,
         sum(推广费用)/sum(分成后充值) as 投放比,
         (sum(分成后充值)  - sum(推广费用)) as 扣除推广后充值,
         DATE_FORMAT(date_sub(curdate(),interval 1 year),'%y-%m') as months,
         NOW()
from
    (
        select   DATE_FORMAT(concat(month,11),'%y-%m') as month2 ,
                 sum(charge_itemcount) as 充值,
                 sum(charge_money) as 分成后充值,
                 sum(spend) as 推广费用
        from ads.ads_trade_month_recharge_toufang
        where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
          and product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,6833,6883)
        group by 1
        union all
        -- -------国阅的 脚本中条件是self_type=0 的-------------------
        select DATE_FORMAT(concat(month,11),'%y-%m') as month2 ,
            sum(charge_item_amt) as 充值,
            sum(charge_amt) as 分成后充值,
            sum(cost_amt) as 推广费用
        from ads.ads_cr_recharge_cost_moni
        where month>= DATE_FORMAT(date_sub(curdate(),interval 1 year),'%Y%m')
          and product_id in (6773)
        group by 1
    ) a
group by 1 ,7;
