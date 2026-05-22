----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_shopitem_charge_ed
-- workflow_version : 29
-- create_user      : yanxh
-- task_name        : dws_trade_user_recharge_temp
-- task_version     : 15
-- update_time      : 2026-04-10 10:21:07
-- sql_path         : \starrocks\tbl_dws_trade_user_shopitem_charge_ed\dws_trade_user_recharge_temp
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_user_recharge_temp where dt = '${bf_1_dt}';

-- SQL语句
insert into  dws.dws_trade_user_recharge_temp
select '${bf_1_dt}' as dt,product_id,user_id, Firstchargeday,Firstchargemoney,Autoid
from
(
select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid , row_number()  over(partition by product_id,user_id order by Autoid) as rn
from (
select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid  from dws.dws_trade_user_recharge_temp where dt=date(date_add('${bf_1_dt}',interval -1 day ))
union all
select productid,userid,date(createtime) as  Firstchargeday,itemcount as Firstchargemoney,Autoid  from dwd.dwd_trade_user_payorder where dt='${bf_1_dt}'
) a
)  b where rn=1
;
