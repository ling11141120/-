----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_competitor_app_ret_product_ed
-- workflow_version : 2
-- create_user      : doupz
-- task_name        : dws_competitor_app_ret_product_ed
-- task_version     : 2
-- update_time      : 2024-02-06 14:54:31
-- sql_path         : \starrocks\tbl_dws_competitor_app_ret_product_ed\dws_competitor_app_ret_product_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_competitor_app_ret_product_ed
select ret.dt,
       ret.country_code,
       ret.device_code,
       ret.product_id,
       ret.retention_days,
       product.product_name,
       product.unified_product_name,
       ret.Id,
       ret.granularity,
       ret.end_date,
       cast(ret.est_retention_value as decimal(15, 6)) as est_retention_value,
       current_timestamp()                             as etl_time
from dwd.dwd_competitor_data_ai_app_ret_view as ret
         inner join dim.dim_product as product on ret.product_id = product.product_id
where ret.dt >= '${bf_3_dt}'
  and ret.dt <= '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_init_dws_competitor_app_ret_product_ed
-- workflow_version : 2
-- create_user      : doupz
-- task_name        : init_dws_competitor_app_ret_product_ed
-- task_version     : 2
-- update_time      : 2024-02-06 14:53:31
-- sql_path         : \starrocks\tbl_init_dws_competitor_app_ret_product_ed\init_dws_competitor_app_ret_product_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_competitor_app_ret_product_ed
select ret.dt,
       ret.country_code,
       ret.device_code,
       ret.product_id,
       ret.retention_days,
       product.product_name,
       product.unified_product_name,
       ret.Id,
       ret.granularity,
       ret.end_date,
       cast(ret.est_retention_value as decimal(15, 6)) as est_retention_value,
       current_timestamp()                             as etl_time
from dwd.dwd_competitor_data_ai_app_ret_view as ret
         inner join dim.dim_product as product on ret.product_id = product.product_id;
