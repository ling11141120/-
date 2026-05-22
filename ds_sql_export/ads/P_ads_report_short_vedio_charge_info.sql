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

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_cv_last
-- task_version     : 9
-- update_time      : 2024-11-29 14:03:07
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_cv_last
----------------------------------------------------------------
-- SQL语句
-- =======================上个季度，完整的充值收入==============================

       --     ================================小程序推广的==================================
     insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   35 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )   and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================星图的==================================

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
  select 34 as datetypes,sum(charge_money),sum(charge_money_rmb),sum(charge_order),sum(charge_num)
  from (
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select
                sum(a.base_amount*0.9) as charge_money,
                sum(a.base_amount*0.9)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'

           where QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )   and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
           and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 -- and a.product_id = 6883

union all
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select    sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )   and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
    and a.Create_Time>='2024-05-22'
    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
  ) v

  ;

-- SQL语句
--  ================================自营的==================================

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and  dt <='${dt}'
 and QUARTER(Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
 and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  19 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
           where   QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( case when a.dt<'2024-03-01' then a.base_amount*0.1
                when  a.dt>='2024-03-01' then a.base_amount*(1-ro.commission_rate) end ) as charge_money,
                sum( case when a.dt<'2024-03-01' then a.base_amount*0.1
                when  a.dt>='2024-03-01' then a.base_amount*(1-ro.commission_rate) end)*7 as charge_money_rmb,
	            0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where    QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
   -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select   sum( a.base_amount*0.1) as charge_money,
                sum(a.base_amount*0.1)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where
      QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month ))
     and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0   and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where    QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and year(a.Create_Time) = year(DATE_SUB(NOW(),  INTERVAL 3 month )) and
              a.dt >= '2024-05-22' and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

) v ;

-- SQL语句
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

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_cv_self
-- task_version     : 11
-- update_time      : 2024-11-29 14:03:07
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_cv_self
----------------------------------------------------------------
-- SQL语句
--     ================================自营的==================================
--   ---------截止当前时间的当天充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 -- select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 -- union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and dt >=  CURDATE() and dt <='${dt}' and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  7 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
 from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
           where   a.dt >= CURDATE()
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where    a.dt >= CURDATE()    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0   as charge_order,
                0   as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where    a.dt >=  CURDATE()  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
) v
 ;

-- SQL语句
--  ================================自营的==================================
--   ---------截止当前时间的昨天充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 -- select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 -- union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and  dt>= date_add(CURDATE(),interval -1 day) and  Create_Time<=date_add(now(),interval -1 day)  and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  8 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
           where   a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day)
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where  a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day)   and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0   as charge_order,
                0   as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where  a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day) and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
) v

 ;

-- SQL语句
--  ================================自营的==================================
--   ---------截止当前时间的当月充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY) and dt <='${dt}' and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  9 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
           where   a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)   and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
   -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select   sum( a.base_amount*0.1) as charge_money,
                sum(a.base_amount*0.1)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where
           a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
           and     a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0   and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where   a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
          and   a.dt >= '2024-05-22' and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

) v

 ;

-- SQL语句
--  ================================自营的==================================
--   ---------截止当前时间的上个月充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and  dt <='${dt}'
  and Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
   and  Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
 and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  10 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
           where   a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
   -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select   sum( a.base_amount*0.1) as charge_money,
                sum(a.base_amount*0.1)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where
           a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
          and   a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end and  a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0   and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<=  case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end and
             a.dt >= '2024-05-22' and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

) v

  ;

-- SQL语句
--  ================================自营的==================================
	--   ---------截止当前时间的当前季度的充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and
Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND Create_Time < now() and QUARTER(Create_Time) = QUARTER(now())
and
 dt <='${dt}' and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  11 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
     left join dim.dim_video_cn_accountinfo_view  c
      on  a.video_user_id = c.account
           where  a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now() and QUARTER(a.Create_Time) = QUARTER(now())
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now() and QUARTER(a.Create_Time) = QUARTER(now())  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
   -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select   sum( a.base_amount*0.1) as charge_money,
                sum(a.base_amount*0.1)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where
          a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now() and QUARTER(a.Create_Time) = QUARTER(now()) and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 -- and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now() and QUARTER(a.Create_Time) = QUARTER(now()) and
              a.dt >= '2024-05-22' and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

) v

  ;

-- SQL语句
--  ================================自营的==================================
		--   ---------截止当前时间的上个季度的充值收入----
  insert into   ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
 with orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and  dt <='${dt}'
 and Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and  Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                  and QUARTER( Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
 and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )

 select  12 as datetypes, sum(charge_money) as charge_money, sum(charge_money_rmb) as charge_money_rmb,
               sum(charge_order) as charge_order ,sum(charge_num) as charge_num
               from (
 select         sum( a.base_amount) as charge_money,
                sum(a.base_amount)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id) as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no

           where   a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                  and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   union all
  -- -----筛选出 tps 2:分销
       select   sum( case when a.dt<'2024-03-01' then a.base_amount*0.1    --  2024-03-01之前 commission_rate的比例是 1：9写死的比例 -- 2024-03-01开始，按配置表比例来算
                           when a.dt>='2024-03-01'then a.base_amount*(1-ro.commission_rate) end) as charge_money,
                sum(case when a.dt<'2024-03-01' then a.base_amount*0.1
				         when a.dt>='2024-03-01'then a.base_amount*(1-ro.commission_rate) end)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
   select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2   ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where  a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                  and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )   and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
   -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select   sum( a.base_amount*0.1) as charge_money,
                sum(a.base_amount*0.1)*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where
     a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                  and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 -- and a.product_id = 6883

union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select sum( a.base_amount*(1-ro.commission_rate)) as charge_money,
                sum(a.base_amount*(1-ro.commission_rate))*7 as charge_money_rmb,
                0 as charge_order,
                0 as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2
                   union all   -- 筛选出属于小程序推广的数据 分成比例默认0.9---
                   select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3
                  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
           where  a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                  and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )  and
              a.dt >= '2024-05-22' and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

) v
   ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_cv_xiaochengxu
-- task_version     : 8
-- update_time      : 2024-11-29 14:03:07
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_cv_xiaochengxu
----------------------------------------------------------------
-- SQL语句
--     ================================小程序推广的==================================

--   ---------截止当前时间的当天充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   28 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where    a.dt >=  CURDATE()  and a.dt>='2024-05-22' and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================小程序推广的==================================
--   ---------截止当前时间的昨天充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   29 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day)
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883  ;

-- SQL语句
--     ================================小程序推广的==================================
--   ---------截止当前时间的当月充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   30 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================小程序推广的==================================
		--   ---------截止当前时间的上个月充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   31 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================小程序推广的==================================
		--   ---------截止当前时间的本季度充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   32 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now()
                  and QUARTER(a.Create_Time) = QUARTER(now())
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================小程序推广的==================================
		--   ---------截止当前时间的上个季度充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   33 as datetypes, sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)    as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,4 as tps from  dim.dim_ads_role_users_view where  type= 3  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where  a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                          and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
   and a.dt>='2024-05-22'  and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_cv_xingtu
-- task_version     : 8
-- update_time      : 2024-11-29 14:03:07
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_cv_xingtu
----------------------------------------------------------------
-- SQL语句
--     ================================星图的==================================

--   ---------截止当前时间的当天充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   22 as datetypes,
          	   sum( a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where    a.dt >=  CURDATE() and     a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================星图的==================================
--   ---------截止当前时间的昨天充值收入----
  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select   23 as datetypes,
	   sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where   a.Create_Time>=date_add(CURDATE(),interval -1 day) and a.Create_Time<=date_add(now(),interval -1 day)
   and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883    ;

-- SQL语句
--     ================================星图的==================================
--   ---------截止当前时间的当月的充值收入----

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
  select 24 as datetypes,sum(charge_money),sum(charge_money_rmb),sum(charge_order),sum(charge_num)
  from (
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select
                sum(a.base_amount*0.9) as charge_money,
                sum(a.base_amount*0.9)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no  and b.appid ='tt3f83493ea0be37f901'
           where  a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
           and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select    sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where  a.Create_Time>=DATE_SUB(CURDATE(),INTERVAL dayofmonth(now())-1 DAY)
    and a.Create_Time>='2024-05-22'
    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
  ) v
  ;

-- SQL语句
--     ================================星图的==================================
	--   ---------截止当前时间的上个月充值收入----

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
  select 25 as datetypes,sum(charge_money),sum(charge_money_rmb),sum(charge_order),sum(charge_num)
  from (
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select
                sum(a.base_amount*0.9) as charge_money,
                sum(a.base_amount*0.9)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where  a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
           and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0   and a.product_id = 6883

union all
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select    sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where  a.Create_Time>=date_sub(date_sub(curdate(),interval day(curdate()) - 1 day),interval 1 month)
                  and a.Create_Time<= case when day(now()) > day(date_sub(now(),interval 1 month))
 then DATE_FORMAT(date_sub(now(),interval 1 month),'%Y-%m-%d 23:59:59')
 else date_sub(now(),interval 1 month) end
    and a.Create_Time>='2024-05-22'
    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
  ) v
  ;

-- SQL语句
--     ================================星图的==================================
	--   ---------截止当前时间的本季度充值收入----

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
  select 26 as datetypes,sum(charge_money),sum(charge_money_rmb),sum(charge_order),sum(charge_num)
  from (
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select
                sum(a.base_amount*0.9) as charge_money,
                sum(a.base_amount*0.9)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now()
                  and QUARTER(a.Create_Time) = QUARTER(now())
           and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883

union all
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select    sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 3 month ) AND a.Create_Time < now()
         and QUARTER(a.Create_Time) = QUARTER(now())
    and a.Create_Time>='2024-05-22'
    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
  ) v
  ;

-- SQL语句
--     ================================星图的==================================
	--   ---------截止当前时间的上个季度充值收入----

  insert into  ads.ads_report_short_vedio_charge_info  (datetypes,charge_money,charge_money_rmb,charge_order,charge_num)
  select 27 as datetypes,sum(charge_money),sum(charge_money_rmb),sum(charge_order),sum(charge_num)
  from (
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select
                sum(a.base_amount*0.9) as charge_money,
                sum(a.base_amount*0.9)*7 as charge_money_rmb,
                count(a.user_id) as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
           where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                          and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
           and   a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0  and a.product_id = 6883

union all
-- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select    sum(a.base_amount*ro.commission_rate) as charge_money,
                sum(a.base_amount*ro.commission_rate)*7 as charge_money_rmb,
                count(a.user_id)   as charge_order,
                count(distinct a.user_id)  as charge_num
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
   inner join
     (   -- 筛选出属于星图推广的数据 分成比例默认0.9---
           select  ref_id,0.9 as commission_rate ,3 as tps from  dim.dim_ads_role_users_view where  type= 2  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
   where a.Create_Time > DATE_SUB(NOW(),  INTERVAL 6 month ) and a.Create_Time <= DATE_SUB(NOW(),  INTERVAL 3 month )
                          and QUARTER(a.Create_Time) =QUARTER( DATE_SUB(NOW(),  INTERVAL 3 month ) )
    and a.Create_Time>='2024-05-22'
    and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
  ) v
  ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_short_vedio_charge_info
-- workflow_version : 28
-- create_user      : yanxh
-- task_name        : ads_report_short_vedio_charge_info_sv
-- task_version     : 5
-- update_time      : 2026-03-25 20:10:35
-- sql_path         : \starrocks\tbl_ads_report_short_vedio_charge_info\ads_report_short_vedio_charge_info_sv
----------------------------------------------------------------
-- SQL语句
----------------------------------------------------------------
-- 程序功能： 海剧用户充值表（部分）
-- 程序名： P_ads_report_short_vedio_charge_info
-- 目标表： ads.ads_report_short_vedio_charge_info
-- 负责人： qhr
-- 开发日期： 2026-03-24
----------------------------------------------------------------

set cbo_cte_reuse = true;

-- SQL语句
-- 开启CTE复用

insert into ads.ads_report_short_vedio_charge_info
with pay_data as (
select user_id
     , base_amount
     , create_time
  from dwd.dwd_trade_sharpenginepaycenter_payorder_view
 where create_time > date_trunc('month', date_sub(now(), interval 6 month))
   and test_flag = 0
   and product_id = 6833
   and Order_Status = 1
)
, pay_data_agg as (
    -- 今日
    select 1                as datetypes
         , sum(base_amount) as charge_money
         , sum(base_amount) * 6.5 as charge_money_rmb
         , count(1) as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= current_date
     union all
    -- 昨日
    select 2                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_add(current_date, interval -1 day)
       and create_time <= date_add(now(), interval -1 day)
      union all
    -- 本月
    select 3                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_trunc('month', now())
     union all
    -- 上月同期
    select 4                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_trunc('month', date_sub(current_date, interval 1 month))
       and create_time <= case when day(now()) > day(date_sub(now(), interval 1 month)) then date_format(date_sub(now(), interval 1 month), '%Y-%m-%d 23:59:59')
                               else date_sub(now(), interval 1 month)
                           end
     union all
    -- 本季度
    select 5                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time > date_sub(now(), interval 3 month)
       and create_time < now()
       and quarter(create_time) = quarter(now())
      union all
    -- 上季度同期
    select 6                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time > date_sub(now(), interval 6 month)
       and create_time <= date_sub(now(), interval 3 month)
       and quarter(Create_Time) = quarter(date_sub(now(), interval 3 month))
      union all
    -- 上季度完整
    select 21                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where quarter(create_time) = quarter(date_sub(now(), interval 3 month))
       and year(Create_Time) = year(date_sub(now(), interval 3 month))
)
, tt_payorder as (
    select tsp.create_time
         , cast(svgv.price_title as decimal(10,2))*if(accinf.mt=4,0.85,0.7) as base_amount
         , tsp.account_id                                                   as user_id
      from ods.ods_tidb_short_video_tt_vip_subscription_payorder            as tsp
      left join (select item_id
                      , max(price_title)                                    as price_title
                      , max(Price)                                          as price
                   from dim.dim_short_video_goods_view
                  where core = 16
                    and is_remove = 0
                  group by 1
                )                                                           as svgv
        on tsp.tier_id = svgv.item_id
      left join dim.dim_short_video_user_accountinfo                        as accinf
        on accinf.user_id = tsp.account_id
      left join ods.ods_tidb_short_video_tt_vip_subscribe                   as tvs
        on tsp.subscription_record_id = tvs.id
      left join (select get_json_string(content, '$.trade_order_id')        as trade_order_id
                   from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
                  where event_type in (9, 10)    -- 撤销、退款
                  group by 1
                )                                                           as reo
        on tsp.trade_order_id = reo.trade_order_id
     where tsp.trade_order_status = 2
       and ifnull(tvs.is_sandbox, 0) = 0
       and reo.trade_order_id is null
     union all
    select tpy.create_time                         as create_time
         , tpy.token_amount*(1-0.00966958)/100     as base_amount
         , tpy.account_id                          as user_id
      from ods.ods_tidb_short_video_tt_payorder    as tpy
     where tpy.trade_order_status = 2
)
, tt_payorder_agg as (
    -- 今日
    select 1                as datetypes
         , sum(base_amount) as charge_money
         , sum(base_amount) * 6.5 as charge_money_rmb
         , count(1) as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= current_date
     union all
    -- 昨日
    select 2                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_add(current_date, interval -1 day)
       and create_time <= date_add(now(), interval -1 day)
      union all
    -- 本月
    select 3                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_trunc('month', now())
     union all
    -- 上月同期
    select 4                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_trunc('month', date_sub(current_date, interval 1 month))
       and create_time <= case when day(now()) > day(date_sub(now(), interval 1 month)) then date_format(date_sub(now(), interval 1 month), '%Y-%m-%d 23:59:59')
                               else date_sub(now(), interval 1 month)
                           end
     union all
    -- 本季度
    select 5                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time > date_sub(now(), interval 3 month)
       and create_time < now()
       and quarter(create_time) = quarter(now())
      union all
    -- 上季度同期
    select 6                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time > date_sub(now(), interval 6 month)
       and create_time <= date_sub(now(), interval 3 month)
       and quarter(Create_Time) = quarter(date_sub(now(), interval 3 month))
      union all
    -- 上季度完整
    select 21                      as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where quarter(create_time) = quarter(date_sub(now(), interval 3 month))
       and year(Create_Time) = year(date_sub(now(), interval 3 month))
)
select datetypes
     , sum(charge_money)           as charge_money
     , sum(charge_money_rmb)       as charge_money_rmb
     , sum(charge_order)           as charge_order
     , sum(charge_num)             as charge_num
     , now()                       as etl_time
  from (select datetypes           as datetypes
             , charge_money        as charge_money
             , charge_money_rmb    as charge_money_rmb
             , charge_order        as charge_order
             , charge_num          as charge_num
          from pay_data_agg
         union all
        select datetypes           as datetypes
             , charge_money        as charge_money
             , charge_money_rmb    as charge_money_rmb
             , charge_order        as charge_order
             , charge_num          as charge_num
          from tt_payorder_agg
       )                           as t
 group by 1
;
