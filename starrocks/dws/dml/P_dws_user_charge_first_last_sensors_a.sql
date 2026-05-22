----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_charge_first_last_sensors_a
-- task_version     : 6
-- update_time      : 2023-12-21 10:25:47
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_charge_first_last_sensors_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_charge_first_last_sensors_a
select COALESCE (a.userid,b.userid)userid, itemcount,charge_cnt,
last_charge_time,first_charge_time,frist_itemcount,first_read_time,NOW()
from (select userid ,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,NOW()
from (select
userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,
ROW_NUMBER () over(partition by userid order  by charge_cnt desc  ) n
from (select
userid,
itemcount,
SUM(charge_cnt) charge_cnt,
max(createtime) last_charge_time,
min(first_charge_time) first_charge_time,
max(frist_itemcount)frist_itemcount
from
(select  userid,itemcount,  1 charge_cnt, createtime,
FIRST_VALUE(itemcount)over(partition by userid order by createtime asc rows between unbounded preceding and unbounded following) frist_itemcount,
FIRST_VALUE(createtime)over(partition by userid order by createtime asc rows between unbounded preceding and unbounded following) first_charge_time,
ROW_NUMBER () over(partition by userid,itemcount order  by createtime asc) n
from  dwd.dwd_trade_user_payorder)a group by 1,2)a)a  where n=1)a
full join
(select userid,createtime first_read_time,timecount  from dws.dws_user_first_read_time_sensors_a  where dt =date_sub(current_date(),interval 1 day ) ) b
ON a.userid = b.userid;
