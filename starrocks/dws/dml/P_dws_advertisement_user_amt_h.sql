----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_user_amt_h
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : dws_advertisement_user_amt_h
-- task_version     : 6
-- update_time      : 2024-11-13 17:48:29
-- sql_path         : \starrocks\tbl_dws_advertisement_user_amt_h\dws_advertisement_user_amt_h
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_advertisement_user_amt_h
select
     DATE_FORMAT(DATE_ADD(create_tm,INTERVAL -13 Hour),'%Y-%m-%d %H') dt
     ,user_id
     ,product_id
     ,corever
     ,mt
     ,SUM(ad_position_amt) amount
     ,CURRENT_TIMESTAMP() etl_tm
from dwd.dwd_advertisement_user_position_amt_p_di a
where a.dt >= DATE_ADD('${dt}',-2)
  and create_tm >= DATE_ADD(DATE_ADD('${dt}',INTERVAL 13 Hour),INTERVAL -1 DAY)
group by 1,2,3,4,5;
