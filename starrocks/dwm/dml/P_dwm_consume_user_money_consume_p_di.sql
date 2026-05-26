----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_consume_user_money_consume_p_di
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dwm_consume_user_money_consume_p_di
-- task_version     : 1
-- update_time      : 2024-04-20 09:36:35
-- sql_path         : \starrocks\tbl_dwm_consume_user_money_consume_p_di\dwm_consume_user_money_consume_p_di
----------------------------------------------------------------
-- SQL语句
insert into  dwm.`dwm_consume_user_money_consume_p_di`
select  auto_id , dt, product_id, user_id,book_id,chapter_ids,chapter_num,amount,remain_amount,pay_type, createtime,now() as etl_tm from (
select a.auto_id ,a.dt,a.product_id,a.user_id,a.book_id,a.chapter_ids,a.createtime,a.amount,a.remain_amount,a.chapter_num,a.pay_type,b.auto_id as id
from (
-- 筛选出阅币以及赠送币的数据 实际都是作为阅币消耗
select auto_id ,dt,product_id,user_id,book_id,chapter_ids,createtime,amount,remain_amount,chapter_num,pay_type from  dwd.dwd_consume_user_consume  where dt>='${bf_1_dt}' and dt<'${dt}' and types in (1,3) and pay_type !=1103
) a
left join
(
-- 筛选出礼券消费的数据
select auto_id,dt,product_id,user_id,book_id,chapter_ids from  dwd.dwd_consume_user_consume  where dt>='${bf_1_dt}' and dt<'${dt}' and types in (2) and pay_type !=1103 -- 筛选出阅币以及赠送币的数据 实际都是作为阅币消耗
) b
on a.dt=b.dt and a.product_id=b.product_id and a.user_id=b.user_id and a.book_id=b.book_id and a.chapter_ids=b.chapter_ids
) v
where  id is  null -- 筛选出没有阅币加礼券同时消耗的数据;
