----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_consume_money_lst_tm_p_di
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : dws_user_consume_money_lst_tm_p_di
-- task_version     : 1
-- update_time      : 2024-04-20 09:49:19
-- sql_path         : \starrocks\tbl_dws_user_consume_money_lst_tm_p_di\dws_user_consume_money_lst_tm_p_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_consume_money_lst_tm_p_di
select '${bf_1_dt}' as dt,product_id,user_id,
max(createtime) lst_csm_tm, -- 用户最近一次消费时间
now() as etl_tm
from (
-- 获取最新的用户最近一次消费时间数据----
select product_id,user_id,max(createtime) createtime
from dwm.`dwm_consume_user_money_consume_p_di`
where dt='${bf_1_dt}'
group by 1,2
union all
-- -----获取历史累计的用户最近一次消费数据-------------
select  product_id,user_id,lst_csm_tm from dws.dws_user_consume_money_lst_tm_p_di
where dt='${bf_2_dt}'
) a
group by 1,2,3;
