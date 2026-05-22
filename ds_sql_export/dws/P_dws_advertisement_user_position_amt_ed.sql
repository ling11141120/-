----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_user_position_amt_ed
-- workflow_version : 78
-- create_user      : yanxh
-- task_name        : 后置删除僵尸数据
-- task_version     : 3
-- update_time      : 2026-05-06 15:48:50
-- sql_path         : \starrocks\tbl_dws_advertisement_user_position_amt_ed\后置删除僵尸数据
----------------------------------------------------------------
-- SQL语句
delete from  dws.dws_advertisement_user_position_amt_ed
 where dt >= '${bf_1_dt}'
   and dt <= '${dt}'
   and etl_tm < '${cur_etl_tm}';
