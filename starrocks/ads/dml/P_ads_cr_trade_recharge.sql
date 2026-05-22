----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cr_trade_recharge
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : ads_cr_trade_recharge
-- task_version     : 5
-- update_time      : 2024-06-05 10:20:16
-- sql_path         : \starrocks\tbl_ads_cr_trade_recharge\ads_cr_trade_recharge
----------------------------------------------------------------
-- SQL语句
--  今日充值收入
insert into  ads.ads_cr_trade_recharge
select 6773 as product_id, 'today' as date_types, 0 as self_type,ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt ,now() as etl_time
from dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
where a.Create_Time>=CURDATE() and a.test_flag=0  and a.coo_order_status = 1
;

-- SQL语句
--  昨日同期收入
insert into  ads.ads_cr_trade_recharge
select 6773 as product_id,'last_day' as date_types,0 as self_type,ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt  ,now() as etl_time
from dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
where a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day) and a.test_flag=0   and a.coo_order_status = 1
 ;

-- SQL语句
-- 本月收入
insert into ads.ads_cr_trade_recharge
select 6773 as product_id, 'cur_month' as date_types, 0 as self_type,ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb  ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt ,now() as etl_time
from dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
	 where a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY) and   a.test_flag=0   and a.coo_order_status = 1

;

-- SQL语句
-- 上月同期收入
insert into ads.ads_cr_trade_recharge
select 6773 as product_id,'last_month' as date_types,0 as self_type, ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb  ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt ,now() as etl_time
from dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
where a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
and a.Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
and a.test_flag=0   and a.coo_order_status = 1
 ;

-- SQL语句
-- 本季度收入
insert into ads.ads_cr_trade_recharge
select 6773 as product_id,'cur_quarter' as date_types,0 as self_type, ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb  ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt ,now() as etl_time
from  dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now() and QUARTER(a.Create_Time) = QUARTER(now())  and a.test_flag=0   and a.coo_order_status = 1

;

-- SQL语句
-- 上季度同期收入
insert into ads.ads_cr_trade_recharge
select 6773 as product_id,'last_quarter' as date_types,0 as self_type, ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb  ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt ,now() as etl_time
from  dwd.dwd_cr_trade_payorder_view a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and a.test_flag=0   and a.coo_order_status = 1
;

-- SQL语句
-- -------------------上个季度完整的充值收入--------------------
insert into ads.ads_cr_trade_recharge
  select 6773 as product_id,'last_whole_quarter' as date_types,0 as self_type,ifnull(sum(a.base_amount),0) as charge_amt,ifnull(sum(a.base_amount_rmb),0) as charge_amt_rmb  ,COUNT(a.video_user_id) as charge_cnt,count(distinct(a.video_user_id)) as charge_unt  ,now() as etl_time
      from  dwd.dwd_cr_trade_payorder_view a
	   inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
      where QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))  and test_flag=0  and coo_order_status = 1

;
