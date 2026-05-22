----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_cr_trade_user_recharge_di
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : dws_cr_trade_recharge_moni
-- task_version     : 4
-- update_time      : 2024-06-05 17:31:11
-- sql_path         : \starrocks\tbl_dws_cr_trade_user_recharge_di\dws_cr_trade_recharge_moni
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_cr_trade_recharge_moni where month >=  date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month),'%Y%m');

-- SQL语句
insert into  dws.dws_cr_trade_recharge_moni
select date_format(dt, '%Y%m')                                                         as month,
       product_id,
	   self_type,
	   shop_item,
	   app_id,
	   plat_form,
	   corever2,current_language2,
	   mt2,reg_country,os,
       IF(concat(year(dt), month(dt)) = CONCAT(year(NOW()), month(NOW())), DAY(curdate()),
          dayofmonth(DATE_SUB(DATE_ADD(DATE_TRUNC('MONTH', dt), INTERVAL 1 MONTH), INTERVAL 1
                              DAY)))                                                   as daysnum,

       sum(charge_amt)  as charge_amt ,
       sum(charge_amt_rmb) as  charge_amt_rmb  ,
       sum(charge_item_amt)  as charge_item_amt  ,
       sum(	 charge_cnt)  as charge_cnt  ,
       sum(if(date_format(reg_tm, '%Y%m') = date_format(dt, '%Y%m'), charge_cnt, 0)) as new_charge_cnt,
       sum(if(date_format(reg_tm, '%Y%m') = date_format(dt, '%Y%m'), charge_amt, 0)) as new_charge_amt,
       sum(if(date_format(reg_tm, '%Y%m') = date_format(dt, '%Y%m'), charge_item_amt, 0))    as new_charge_item_amt,
       now() as etl_tm
from
     dws.dws_cr_trade_user_recharge_di
  where dt >= date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month) and  self_type = 0

group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;
