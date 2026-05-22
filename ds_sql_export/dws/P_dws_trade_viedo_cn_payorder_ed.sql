----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_viedo_cn_payorder_ed
-- workflow_version : 24
-- create_user      : zhengtt
-- task_name        : dws_trade_viedo_cn_payorder_ed
-- task_version     : 24
-- update_time      : 2024-10-22 19:51:45
-- sql_path         : \starrocks\tbl_dws_trade_viedo_cn_payorder_ed\dws_trade_viedo_cn_payorder_ed
----------------------------------------------------------------
-- SQL语句
insert into   dws.dws_trade_viedo_cn_payorder_ed  --   test.yxh_charge_di  --
   with first_charge_info as -- 计算用户首次充值的日期以及首充金额-----------------
         (   select  product_id ,user_id,First_charge_day,First_charge_money
             from (
                      select product_id ,video_user_id as user_id,dt as First_charge_day,
                             base_amount as First_charge_money,row_number()  over(partition by product_id,video_user_id order by create_time) as rn
                      from dwd.dwd_trade_video_cn_payorder_view where coo_order_status = 1 and test_flag = 0
                  ) a where a.rn=1
         ),

 orderid as
 (
       -- -------- 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
 union all  -- -----5月22号开始通过机构id来区分星图和小程序推广
 select out_trade_no from  dwd.dwd_trade_cn_a_recharge_view where  dt >= '2024-05-22' and dt >= '${bf_3_dt}' and  dt <='${dt}' and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
 )
   ,

 sat as (
 select a.dt ,cast(a.product_id as bigint) as product_id,a.video_user_id ,
              c.corever2 as core,c.current_language2 ,c.mt2 ,c.reg_country,
              1 as commission_rate, 1 as tps ,-- 表示筛选出自营的用户及收入
              date(c.create_time) as reg_date,c.chl2 as chl2,
                  datediff(a.dt,date(c.create_time)) as reg_days,
                sum( a.base_amount) as charge_money, -- 分成后的美元
                sum(a.base_amount_rmb) as charge_money_rmb, -- 分成后的人民币
                count(a.user_id) as charge_count,
                sum(a.amount)/100/7 as charge_itemcount -- 充值流水
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no
     left join dim.dim_video_cn_accountinfo_view  c
      on  a.video_user_id = c.account
           where   a.dt >= '${bf_3_dt}' and a.dt <='${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
      and b.middleman_id not in
     -- ------------排除掉分销的 --------------------
( select distinct  ref_id from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2 )
     -- ------------排除掉星图、小程序推广的 --------------------
    and a.coo_order_id not in (select out_trade_no from orderid  )

   group by 1,2,3,4,5,6,7,8,9,10,11,12

   union all
  -- -----筛选出 tps 2:分销
       select a.dt ,cast(a.product_id as bigint) as product_id,a.video_user_id ,
              c.corever2 as core,c.current_language2 ,c.mt2 ,c.reg_country,
               ro.commission_rate,   ro.tps ,-- 表示筛选出自营的用户及收入
              date(c.create_time) as reg_date,c.chl2 as chl2,
                  datediff(a.dt,date(c.create_time)) as reg_days,
                sum( a.base_amount) as charge_money,
                sum(a.base_amount_rmb) as charge_money_rmb,
                count(a.user_id) as charge_count,
                sum(a.amount)/100/7    as charge_itemcount
         from dwd.dwd_trade_video_cn_payorder_view a
     inner join dwd.dwd_trade_cn_a_recharge_view b
     on a.coo_order_id = b.out_trade_no
   inner join
     ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate,2  as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and operation_type= 2
  ) ro
     on b.middleman_id =ro.ref_id  -- --------通过机构id来关联--------------------
     left join dim.dim_video_cn_accountinfo_view  c
      on  a.video_user_id = c.account
           where    a.dt >= '${bf_3_dt}' and a.dt <='${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
   group by 1,2,3,4,5,6,7,8,9,10,11,12

      union all  -- 特殊的时间段---
  -- ----- 5月9号到5月21号期间比较特殊，通过 appid = 'tt3f83493ea0be37f901' 视趣小程序=星图，算星图的数据------   ------
       select a.dt ,cast(a.product_id as bigint) as product_id,a.video_user_id ,
              c.corever2 as core,c.current_language2 ,c.mt2 ,c.reg_country,
               0.9 as  commission_rate, 3 as tps ,
              date(c.create_time) as reg_date,c.chl2 as chl2,
               datediff(a.dt,date(c.create_time)) as reg_days,
                sum( a.base_amount) as charge_money,
                sum(a.base_amount_rmb) as charge_money_rmb,
                count(a.user_id) as charge_count,
                sum(a.amount)/100/7  as charge_itemcount
         from dwd.dwd_trade_video_cn_payorder_view a
     inner  join dwd.dwd_trade_cn_a_recharge_view b
     on  a.coo_order_id = b.out_trade_no     and b.appid ='tt3f83493ea0be37f901'
     left join dim.dim_video_cn_accountinfo_view  c
      on  a.video_user_id = c.account
           where    a.dt >= '2024-05-09' and a.dt <'2024-05-22'
           and a.coo_order_status = 1 and test_flag = 0 -- and a.product_id = 6883

   group by 1,2,3,4,5,6,7,8,9,10,11,12
union all
     -- -----5月22号开始通过机构id 筛选出 3：星图 4：小程序推广
       select a.dt ,cast(a.product_id as bigint) as product_id,a.video_user_id ,
              c.corever2 as core,c.current_language2 ,c.mt2 ,c.reg_country,
               ro.commission_rate,   ro.tps ,-- 表示筛选出自营的用户及收入
              date(c.create_time) as reg_date,c.chl2 as chl2,
                  datediff(a.dt,date(c.create_time)) as reg_days,
                sum( a.base_amount) as charge_money,
                sum(a.base_amount_rmb) as charge_money_rmb,
                count(a.user_id) as charge_count,
                sum(a.amount)/100/7    as charge_itemcount
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
     left join dim.dim_video_cn_accountinfo_view  c
      on  a.video_user_id = c.account
           where    a.dt >= '2024-05-22' and a.dt >= '${bf_3_dt}'  and a.dt <= '${dt}'
           and a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883
   group by 1,2,3,4,5,6,7,8,9,10,11,12
)

-- 验证数据  分别计算了自营与分销的收入-----与总的进行了对比没有问题----------------
   --   select tps,sum(charge_money),sum(charge_itemcount),sum(charge_count) from sat group by 1 order by 1
    -- -------------总的数据查询对比验证--------------------
 --  select count(distinct coo_order_id) , sum( a.base_amount) as charge_money  ,sum(a.amount)  from  dwd.dwd_trade_video_cn_payorder_view a  where  a.coo_order_status = 1 and test_flag = 0 and a.product_id = 6883   and a.dt >= '2024-05-01' and a.dt<'2024-05-29'

      --  self_type=1 表示自营的（这里包括公司自己投放获得的充值，以及分销带来的充值按比例给公司）---------------
     --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
     --  2024-03-01 开始往后 将分销部分的充值按 commission_rate 比例分成算给自营------------------

    -- ==========算自营的==================

select  sat.dt,sat.product_id,sat.video_user_id,1 as self_type,core,current_language2,mt2,reg_country,
        reg_date,chl2,
        first_charge_info.First_charge_day,
        first_charge_info.First_charge_money,
        datediff(sat.dt,first_charge_info.First_charge_day)  as re_days,
        reg_days,
        sum( case when sat.tps = 1 then charge_money
                  when sat.tps != 1 and sat.dt<'2024-03-01' then charge_money*0.1 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
                  when sat.tps != 1 and sat.dt>='2024-03-01' then charge_money*(1-commission_rate) end ) as charge_money,  -- 2024-03-01开始，按配置表比例来算
        sum( case when sat.tps = 1 then charge_money_rmb
                  when sat.tps != 1 and sat.dt<'2024-03-01' then charge_money_rmb*0.1 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
                  when sat.tps != 1 and sat.dt>='2024-03-01' then charge_money_rmb*(1-commission_rate) end ) as charge_money_rmb,  -- 2024-03-01开始，按配置表比例来算
        sum(if(sat.tps = 1,charge_count,0)) as charge_count,
        sum( case when sat.tps = 1 then charge_itemcount
                  when sat.tps != 1 and sat.dt<'2024-03-01' then charge_itemcount*0.1 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
                  when sat.tps != 1 and sat.dt>='2024-03-01' then charge_itemcount*(1-commission_rate) end ) as charge_itemcount,  -- 2024-03-01开始，按配置表比例来算
        now() as etl_time
from sat
         left join first_charge_info
                   on  sat.video_user_id = first_charge_info.user_id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    union all
      --  self_type=2  算分销的，计算口径 types=2
    --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
    --  2024-03-01 之后 是按分销金额乘以 commission_rate 比例来算------------------
select  dt,sat.product_id,sat.video_user_id,2 as self_type,core,current_language2,mt2,reg_country,
        reg_date,chl2,
        first_charge_info.First_charge_day,
        first_charge_info.First_charge_money,
        datediff(sat.dt,first_charge_info.First_charge_day)  as re_days,
        reg_days,
  sum( case when sat.dt<'2024-03-01' then charge_money*0.9 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
            when sat.dt>='2024-03-01'then charge_money*commission_rate end ) as charge_money,  -- 2024-03-01开始，按配置表比例来算
  sum( case when sat.dt<'2024-03-01' then charge_money_rmb*0.9 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
            when sat.dt>='2024-03-01'then charge_money_rmb*commission_rate end ) as charge_money_rmb,  -- 2024-03-01开始，按配置表比例来算
  sum(charge_count) as charge_count,
  sum( case when sat.dt<'2024-03-01' then charge_itemcount*0.9 --  2024-03-01之前 commission_rate的比例是 1：9写死的比例
            when sat.dt>='2024-03-01'then charge_itemcount*commission_rate end ) as charge_itemcount,  -- 2024-03-01开始，按配置表比例来算
        now() as etl_time
from sat
         left join first_charge_info
                   on  sat.video_user_id = first_charge_info.user_id
where tps = 2
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
union all
-- -----------------充值总收入----------------------
select  dt,sat.product_id,sat.video_user_id,0 as self_type,core,current_language2,mt2,reg_country,
        reg_date,chl2,
        first_charge_info.First_charge_day,
        first_charge_info.First_charge_money,
        datediff(sat.dt,first_charge_info.First_charge_day)  as re_days,
        reg_days,
        sum(charge_money) as charge_money,
        sum(charge_money_rmb) as charge_money_rmb,
        sum(charge_count) as charge_count,
        sum(charge_itemcount) as charge_itemcount,
        now() as etl_time
from sat
         left join first_charge_info
                   on  sat.video_user_id = first_charge_info.user_id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
union all
-- ----------------3 纯自营的收入-------------------------------
select  dt,sat.product_id,sat.video_user_id,3 as self_type,core,current_language2,mt2,reg_country,
        reg_date,chl2,
        first_charge_info.First_charge_day,
        first_charge_info.First_charge_money,
        datediff(sat.dt,first_charge_info.First_charge_day)  as re_days,
        reg_days,
        sum(charge_money) as charge_money,
        sum(charge_money_rmb) as charge_money_rmb,
        sum(charge_count) as charge_count,
        sum(charge_itemcount) as charge_itemcount,
        now() as etl_time
from sat
         left join first_charge_info
                   on  sat.video_user_id = first_charge_info.user_id
where tps = 1
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14

    union all
      --  self_type 4:星图的 5：小程序推广
select  sat.dt,sat.product_id,sat.video_user_id, if(tps=3 ,4,5) as self_type,core,current_language2,mt2,reg_country,
        reg_date,chl2,
        first_charge_info.First_charge_day,
        first_charge_info.First_charge_money,
        datediff(sat.dt,first_charge_info.First_charge_day)  as re_days,
        reg_days,
  sum(charge_money*commission_rate   ) as charge_money,
  sum( charge_money_rmb*commission_rate  ) as charge_money_rmb,
  sum(charge_count) as charge_count,
  sum( charge_itemcount*commission_rate  ) as charge_itemcount,
 now() as etl_time
from sat
         left join first_charge_info
                   on  sat.video_user_id = first_charge_info.user_id
where sat.tps in (3,4) -- 3:星图 4：小程序推广
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
