----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_cv_3rd
-- task_version     : 9
-- update_time      : 2024-11-29 14:03:07
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_cv_3rd
----------------------------------------------------------------
-- SQL语句
--     ================================分销的=================================

		--   ---------截止当前时间的当天的充值收入----
      insert into    ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               13 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time >= CURDATE()
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
   ;

-- SQL语句
--   ---------截止当前时间的昨天的充值收入----
      insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               14 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day)
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
		;

-- SQL语句
--   ---------截止当前时间的当月的充值收入----
      insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               15 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--   ---------截止上个月同期的充值收入----
      insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               16 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--   ---------截止当前时间的当季度的充值收入----
      insert into    ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               17 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now()
                  and QUARTER(a.Create_Time) = QUARTER(now())
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--   ---------截止当前时间的上个季度的充值收入----
      insert into    ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               18 as datetypes,
       sum( case when a.dt<'2024-03-01' then a.base_amount*0.9
                          when  a.dt>='2024-03-01' then a.base_amount*ro.commission_rate end ) as charge_money,
            sum( case when a.dt<'2024-03-01' then a.base_amount*0.9
                          when  a.dt>='2024-03-01' then a.base_amount*ro.commission_rate end)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where  a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                          and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- -----------------------分销的----------------------------------------

      insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
   -- -----筛选出 tps 2:分销
       select
               20 as datetypes,
       sum( case when a.dt<'2024-03-01' then a.base_amount*0.9
                          when  a.dt>='2024-03-01' then a.base_amount*ro.commission_rate end ) as charge_money,
            sum( case when a.dt<'2024-03-01' then a.base_amount*0.9
                          when  a.dt>='2024-03-01' then a.base_amount*ro.commission_rate end)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where  QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
		   ;