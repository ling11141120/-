----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_rmt_balance_info
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_user_rmt_consume_mid
-- task_version     : 1
-- update_time      : 2024-03-22 11:51:57
-- sql_path         : \starrocks\tbl_ads_bi_user_rmt_balance_info\ads_user_rmt_consume_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_rmt_consume_mid
   select dt,product_id,createtime  as create_tm,user_id,types ,auto_id as id ,remain_amount ,now() as etl_tm from dwd.dwd_consume_user_consume where  dt<='${bf_1_dt}'
  and types in (1,2 ) and product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
  and user_id in (
   select   user_id from dws.dws_wide_user_read_user_label_info_ed  where  dt='${bf_1_dt}' and user_tps=2  group by 1 );
