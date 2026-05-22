----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_toufang_30d
-- workflow_version : 2
-- create_user      : linq
-- task_name        : dws_advertisement_toufang_30d
-- task_version     : 2
-- update_time      : 2023-10-27 14:34:27
-- sql_path         : \starrocks\tbl_dws_advertisement_toufang_30d\dws_advertisement_toufang_30d
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_advertisement_toufang_30d
select month,
       type,
       product_id,
       corever,
       current_language2,
       mt,
       daysnum,
       sum(Spend) as spend ,now() as etl_time
from (
         select date_format(dt, '%Y%m')       as month,
                type,
                product_id,
                corever,
                current_language2,
                mt,
                IF(concat(year(dt), month(dt)) = CONCAT(year(NOW()), month(NOW())), DAY(curdate()),
                   dayofmonth(DATE_SUB(DATE_ADD(DATE_TRUNC('MONTH', dt), INTERVAL 1 MONTH), INTERVAL 1
                                       DAY))) as daysnum,
                spend
         from dws.dws_advertisement_toufang_ed
         where product_id not in (7777, 8888)
     ) t1
group by month, daysnum, type, product_id, corever, current_language2, mt;
