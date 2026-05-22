----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_cr_trade_user_recharge_di
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : dws_cr_trade_user_recharge_di
-- task_version     : 1
-- update_time      : 2024-06-05 16:22:27
-- sql_path         : \starrocks\tbl_dws_cr_trade_user_recharge_di\dws_cr_trade_user_recharge_di
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_cr_trade_user_recharge_di
with first_charge_info as -- 计算用户首次充值的日期以及首充金额-----------------
         (   select  product_id ,user_id,fst_charge_date,fst_charge_amt
             from (
                      select product_id ,video_user_id as user_id,create_time as fst_charge_date,
                             base_amount as fst_charge_amt,row_number()  over(partition by product_id,video_user_id order by create_time) as rn
                      from dwd.dwd_cr_trade_payorder_view
                      where coo_order_status = 1 and test_flag = 0
                  ) a where a.rn=1
         )
 -- 验证数据 select    sum(base_amount*7*100),sum(base_amount),sum(base_amount_rmb*100),sum(base_amount_rmb),sum(amount/100/7) from dwd.dwd_cn_read_trade_payorder_view  a where a.test_flag=0  and a.coo_order_status=1  -- 充值成功状态 1

 --  tps:充值表里存在的用户在账户表中不存在，经与开发了解，实际是测试的脏数据，因此用inner join  可过滤掉测试用户----

 select    date(a.create_time) as dt ,
           a.product_id,
           a.video_user_id as user_id,
           0 as self_type,
            a.shop_item,
           c.appid as app_id,c.plat_form,c.corever2,
           c.current_language2, c.mt2, c.reg_country,
		   c.create_time  as reg_tm,
           c.chl2,c.os,
           first_charge_info.fst_charge_date,
           first_charge_info.fst_charge_amt,
           DATEDIFF(date(a.create_time),date(first_charge_info.fst_charge_date)) as re_days,
		   DATEDIFF(date(a.create_time),date(c.create_time)) as reg_days,
		   sum(a.base_amount) as charge_amt ,
		   sum(a.base_amount_rmb) as charge_amt_rmb ,
	       count(a.video_user_id)  as charge_cnt,
	       sum(amount)/100/7 as charge_item_amt,
           now() as etl_tm
    from dwd.dwd_cr_trade_payorder_view  a
 inner join dim.dim_cr_accountinfo_view  c
     on  a.video_user_id = c.account
   left join first_charge_info
     on  a.video_user_id = first_charge_info.user_id
 where  a.create_time >= '${bf_3_dt}'
 and a.test_flag=0  -- 非测试
 and a.coo_order_status=1  -- 充值成功状态 1
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;
