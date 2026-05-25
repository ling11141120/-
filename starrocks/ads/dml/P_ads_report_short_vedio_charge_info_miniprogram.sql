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
