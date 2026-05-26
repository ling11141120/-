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