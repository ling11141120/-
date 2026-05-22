----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cr_recharge_cost_moni
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : ads_cr_recharge_cost_moni
-- task_version     : 2
-- update_time      : 2024-06-05 17:00:15
-- sql_path         : \starrocks\tbl_ads_cr_recharge_cost_moni\ads_cr_recharge_cost_moni
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_cr_recharge_cost_moni
select t1.month,t1.product_id,t1.charge_amt,t1.charge_amt_rmb,t1.charge_item_amt ,t2.cost_amt,now() as etl_time
from (
          select month, product_id,sum(charge_amt) charge_amt,sum(charge_amt_rmb) charge_amt_rmb, sum(charge_item_amt) charge_item_amt
         from dws.dws_cr_trade_recharge_moni
         where month >= date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month), '%Y%m') and self_type=0
         group by 1,2
     ) t1
         left join (
    select month,product_id, sum(cost_amt) cost_amt
    from  dws.dws_cr_ad_advertising_cost_moni
    where month >= date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month), '%Y%m')
    group by month, product_id
) t2 on t1.month=t2.month and t1.product_id=t2.product_id;
