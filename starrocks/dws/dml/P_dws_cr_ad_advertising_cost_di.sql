----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_cr_ad_advertising_cost_di
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : dws_cr_ad_advertising_cost_di
-- task_version     : 2
-- update_time      : 2024-06-05 16:18:04
-- sql_path         : \starrocks\tbl_dws_cr_ad_advertising_cost_di\dws_cr_ad_advertising_cost_di
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_cr_ad_advertising_cost_di
select  date(date_start) as dt,4 as type,product_id,ifnull(Core,-99) as corever ,ifnull(current_language2,-99) as current_language2,mt, sum(spend)/7 as cost_amt ,now() as etl_tm  -- 国内小程序阅读
from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view
where product_id =6773   and spend>0
group by 1, 2, 3, 4, 5, 6
 ;
