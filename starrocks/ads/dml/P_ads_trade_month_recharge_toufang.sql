----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_trade_month_recharge_toufang
-- workflow_version : 5
-- create_user      : admin
-- task_name        : ads_trade_month_recharge_toufang
-- task_version     : 4
-- update_time      : 2024-11-18 19:29:53
-- sql_path         : \starrocks\tbl_ads_trade_month_recharge_toufang\ads_trade_month_recharge_toufang
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_trade_month_recharge_toufang
select t1.month,t1.product_id,charge_money,charge_itemcount,spends ,now() as etl_time
from (
          select month, product_id,sum(charge_money) charge_money, sum(charge_itemcount) charge_itemcount
         from dws.dws_trade_user_recharge_30d
         where month >= date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month), '%Y%m')
         group by month, product_id
     ) t1
         left join (
    select month,product_id, sum(spend) spends
    from dws.dws_advertisement_toufang_30d
    where month >= date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month), '%Y%m')
    -- 新增 20241118
    and (product_id != 6833 or (product_id = 6833 AND corever = 1))
    group by month, product_id
) t2 on t1.month=t2.month and t1.product_id=t2.product_id;
