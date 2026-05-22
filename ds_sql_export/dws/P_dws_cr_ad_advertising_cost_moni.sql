----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_cr_ad_advertising_cost_di
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : dws_cr_ad_advertising_cost_moni
-- task_version     : 1
-- update_time      : 2024-06-05 16:18:04
-- sql_path         : \starrocks\tbl_dws_cr_ad_advertising_cost_di\dws_cr_ad_advertising_cost_moni
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_cr_ad_advertising_cost_moni
         select date_format(dt, '%Y%m')   as month,
                type,
                product_id,
                corever,
                current_language2,
                mt,
                IF(concat(year(dt), month(dt)) = CONCAT(year(NOW()), month(NOW())), DAY(curdate()),dayofmonth(DATE_SUB(DATE_ADD(DATE_TRUNC('MONTH', dt), INTERVAL 1 MONTH), INTERVAL 1  DAY))) as daysnum,
                sum(cost_amt) cost_amt, -- 投放花费
                now() as etl_tm
         from dws.dws_cr_ad_advertising_cost_di
group by 1, 2, 3, 4, 5, 6, 7;
