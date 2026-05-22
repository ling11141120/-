----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_short_viedo_payorder_est_ed
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : tbl_dws_trade_short_viedo_payorder_est_ed
-- task_version     : 4
-- update_time      : 2024-12-12 15:03:09
-- sql_path         : \starrocks\tbl_dws_trade_short_viedo_payorder_est_ed\tbl_dws_trade_short_viedo_payorder_est_ed
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_trade_short_viedo_payorder_est_ed
 with first_charge_info as (
	 select  product_id ,user_id,First_charge_day,First_charge_money
	 from (
		 select product_id ,user_id,dt as First_charge_day,amount as First_charge_money,row_number()  over(partition by product_id,user_id order by id) as rn
		 from
		 dwd.dwd_trade_sharpenginepaycenter_payorder_est_view
		 where dt>='2023-07-05' and   Order_Status=1  and test_flag =0 and product_id =6833
	  ) a where a.rn=1
)
select a.dt,a.product_id,a.user_id,md5(concat_ws('_',a.dt,a.product_id,a.user_id,a.sub_pay_type)) as md5_key,
       b.corever,b.Current_Language,b.Current_Language2,b.mt,b.reg_country,
       b.create_time as reg_time,a.Sub_pay_Type,
	   first_charge_info.First_charge_day,
	   first_charge_info.First_charge_money,
	   datediff(a.dt,first_charge_info.First_charge_day)  as re_days,
	    datediff(a.dt,date(date_add(b.create_time,interval -13 hour))) as reg_days,  --date(date_add(b.create_time,interval -13 hour))
	     sum( a.base_amount  ) as charge_money,
	  count(a.user_id) as charge_count   ,
	 sum(a.amount) charge_itemcount,
     now() as etl_time
from
 dwd.dwd_trade_sharpenginepaycenter_payorder_est_view  a
left join
dim.dim_short_video_user_accountinfo   b
 on a.product_id=b.product_id and a.user_id=b.user_id
 left join
 first_charge_info
 on a.product_id=first_charge_info.product_id and a.user_id=first_charge_info.user_id
 where a.dt >=date_sub('${bf_1_dt}',interval 3 day)
 and  a.product_id =6833
 and a.Order_Status=1
 and a.test_flag =0
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13,14;

-- 后置SQL语句
delete from dws.dws_trade_short_viedo_payorder_est_ed where dt>=date_sub('${bf_1_dt}',interval 3 day) and etl_time<date_sub(current_timestamp(),interval 2 hour );
