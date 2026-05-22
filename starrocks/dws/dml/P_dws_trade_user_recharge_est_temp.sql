----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_shopitem_charge_est_ed
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : dws_trade_user_recharge_est_temp
-- task_version     : 2
-- update_time      : 2024-11-21 21:19:14
-- sql_path         : \starrocks\tbl_dws_trade_user_shopitem_charge_est_ed\dws_trade_user_recharge_est_temp
----------------------------------------------------------------
-- SQL语句
--------------日调度脚本---------------
insert into  dws.dws_trade_user_recharge_est_temp
select '${bf_1_dt}' as dt,product_id,user_id, Firstchargeday,Firstchargemoney,Autoid
from
(
	select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid , row_number()  over(partition by product_id,user_id order by Autoid) as rn
	from (
		select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid  from dws.dws_trade_user_recharge_est_temp where dt=date(date_add('${bf_1_dt}',interval -1 day ))
		union all
		select productid,userid,date(date_add(createtime,interval -13 hour)) as  Firstchargeday,itemcount as Firstchargemoney,Autoid  from dwd.dwd_trade_user_payorder where date(date_add(createtime,interval -13 hour))='${bf_1_dt}'
	) a
)  b where rn=1
;
