----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_recharge_roll_a
-- workflow_version : 16
-- create_user      : linq
-- task_name        : dws_trade_user_recharge_roll_a
-- task_version     : 11
-- update_time      : 2024-11-06 20:25:53
-- sql_path         : \starrocks\tbl_dws_trade_user_recharge_roll_a\dws_trade_user_recharge_roll_a
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_user_recharge_roll_a  where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_trade_user_recharge_roll_a
with recharge_roll as (
    select dt,product_id,user_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,last_subscribe_type,
           last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,first_recharge_time,total_recharge,
           recharge_cnt,recharge_avg,recharge_max,recharge_min,month_recharge_max,last_recharge,last_recharge_time,total_subscribe_money
    from dws.dws_trade_user_recharge_roll_a
    where dt = '${bf_2_dt}'
),today_recharge as (
    select dt,product_id,user_id,first_recharge_time_day,first_recharge_money_day,last_recharge_time_day,last_recharge_money_day,
           first_subscribe_time_day,first_subscribe_money_day,first_subscribe_type_day,last_subscribe_time_day,last_subscribe_money_day,
           last_subscribe_type_day,subscribe_money,subscribe_cnt_day,shopitems_day,max_recharge_money_day,recharge_Cnt_day,recharge_money_day,min_recharge_money_day
    from dws.dws_trade_user_recharge_ed_temp
    where dt='${bf_1_dt}'
),allFirstSubscribe as (
     select user_id, product_id, first_subscribe, first_subscribe_type, first_subscribe_time
     from (
              select user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,
                     row_number() over (partition by user_id,product_id order by ifnull(first_subscribe_time,'9999-12-31')) rk
              from (
                       select user_id, product_id, first_subscribe, first_subscribe_type, first_subscribe_time
                       from recharge_roll
                       union all
                       select user_id, product_id, first_subscribe_money_day, first_subscribe_type_day, first_subscribe_time_day
                       from today_recharge
                   ) allFirstSubscribe_t1
          ) allFirstSubscribe_t2
     where rk = 1
),allLastSubscribe as (
     select user_id, product_id, last_subscribe, last_subscribe_type, last_subscribe_time
     from (
              select user_id,product_id,last_subscribe,last_subscribe_type,last_subscribe_time,
                     row_number() over (partition by user_id,product_id order by last_subscribe_time desc) rk
              from (
                       select user_id, product_id, last_subscribe, last_subscribe_type, last_subscribe_time
                       from recharge_roll
                       union all
                       select user_id, product_id, last_subscribe_money_day, last_subscribe_type_day, last_subscribe_time_day
                       from today_recharge
                   ) allLastSubscribe_t1
          ) allLastSubscribe_t2
     where rk = 1
),todayOtherSubscribe as (
     select user_id,product_id,subscribe_cnt_day,shopitems_day
     from today_recharge
),allOtherSubscribe as (
     select user_id,product_id,subscribe_cnt,shopitems,
            if(array_length(shopitems) >= 2, 1, 0) as mul_subscribe,
            if(array_length(shopitems) >= 0, 1, 0) as has_subscribe
     from (
              select user_id, product_id, subscribe_cnt, array_distinct(array_agg(shopitems)) as shopitems
              from (
                  select a.user_id,a.product_id,subscribe_cnt,shopitems
                  from (
                           select user_id, product_id, tmp.unnest as shopitems
                           from recharge_roll,unnest(shopitems) tmp
                           union all
                           select user_id, product_id, tmp.unnest as shopitems_day
                           from todayOtherSubscribe,unnest(shopitems_day) tmp
                       ) a
                  left join (
                      select user_id, product_id,sum(subscribe_cnt)-1 as subscribe_cnt
                      from (
                               select user_id, product_id, subscribe_cnt + 1 as subscribe_cnt
                               from recharge_roll
                               union all
                               select user_id, product_id, subscribe_cnt_day + 1 as subscribe_cnt
                               from todayOtherSubscribe
                           )b
                      group by 1,2
                      )c on a.product_id=c.product_id and a.user_id=c.user_id
                   ) allOtherSubscribe_t1
              group by 1,2,3
          )allOtherSubscribe_t2
),recharge_mode as (
    select ProductId as product_id, UserId as user_id, ItemCount as charge_mode, num as charge_mode_cnt, createtime as charge_mode_lst_time
    from (
             select ProductId, UserId, ItemCount, num, createtime,
                    row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rn
             from (
                      select ProductId, UserId, ItemCount, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt <= '${bf_1_dt}'
                      group by 1, 2, 3
                  ) a
         ) b
    where rn = 1
),allFirstRecharge as (
     select user_id, product_id, first_recharge, first_recharge_time
     from (
              select user_id,product_id,first_recharge,first_recharge_time,
                     row_number() over (partition by user_id,product_id order by first_recharge_time) rk
              from (
                       select user_id,product_id,first_recharge,first_recharge_time
                       from recharge_roll
                       union all
                       select user_id, product_id, first_recharge_money_day, first_recharge_time_day
                       from today_recharge
                   ) allFirstLastRecharge_t1
          ) allFirstLastRecharge_t2
     where rk = 1
),allLastRecharge as (
     select user_id, product_id, last_recharge, last_recharge_time
     from (
              select user_id,product_id,last_recharge,last_recharge_time,
                     row_number() over (partition by user_id,product_id order by last_recharge_time desc) rk
              from (
                       select user_id,product_id,last_recharge,last_recharge_time
                       from recharge_roll
                       union all
                       select user_id, product_id, last_recharge_money_day, last_recharge_time_day
                       from today_recharge
                   ) allLastRecharge_t1
          ) allLastRecharge_t2
     where rk = 1
),allOtherRecharge as (
     select user_id,
            product_id,
            sum(total_recharge)                     as total_recharge,
            sum(recharge_cnt)                       as recharge_cnt,
            sum(total_recharge) / sum(recharge_cnt) as recharge_avg,
            max(recharge_max)                       as recharge_max,
            min(recharge_min)                       as recharge_min,
			sum(total_subscribe_money)              as total_subscribe_money -- 新增的累计订阅金额
     from (
              select user_id, product_id, total_recharge, recharge_cnt, recharge_max,recharge_min,total_subscribe_money
              from recharge_roll
              union all
              select user_id, product_id,recharge_money_day, recharge_Cnt_day, max_recharge_money_day,min_recharge_money_day,subscribe_money
              from today_recharge
          ) allOtherRecharge_t1
     group by user_id, product_id
),allMonthRecharge as (
      select user_id, product_id, max(itemcount) as month_recharge_max
      from (
               select userid    as user_id,
                      productid as product_id,
                      itemcount,
                      createtime
               from dwd.dwd_trade_user_payorder
               where dt >= date_sub('${bf_1_dt}', interval 30 day )
                 and dt <= '${bf_1_dt}'
                 and TestFlag=0
           ) allMonthRecharge_t1
      group by user_id, product_id
),

-- ------------- 充值优惠众数-------------------------
   coupon_mode as (
         -- -------------获取用户优惠众数 ，充值获得礼券数/阅币数--------------------
                select ProductId as product_id, UserId as user_id, coupon_mode  -- num , createtime
                      --  ,row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rn
             from (
                      select ProductId, UserId,  round(if(GiftMoney=-99,0,GiftMoney) /RealMoney,2) as coupon_mode, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt<= '${bf_1_dt}'
                      group by 1, 2, 3
                  ) a   qualify  row_number()  over (partition by ProductId,UserId order by num desc,createtime desc ) =1
   )

select '${bf_1_dt}'                                               as dt,
       allFirstRecharge.user_id,
       allFirstRecharge.product_id,
       first_subscribe,
       first_subscribe_type,
       first_subscribe_time,
       last_subscribe ,
       last_subscribe_type,
       last_subscribe_time ,
	   total_subscribe_money, -- 新增的累计订阅金额
       subscribe_cnt,
       shopitems,
       mul_subscribe,
       has_subscribe ,
       first_recharge,
       first_recharge_time,
       total_recharge,
       recharge_cnt,
       recharge_avg,
       recharge_max ,
       recharge_min ,
       month_recharge_max,
       last_recharge,
       last_recharge_time ,
       charge_mode,
       charge_mode_cnt,
       charge_mode_lst_time,
	   coupon_mode.coupon_mode,  -- 充值优惠众数 数据从8月6号才开始有
       current_timestamp() as etl_time
from allFirstRecharge
         left join allLastRecharge  on allFirstRecharge.product_id = allLastRecharge.product_id and allFirstRecharge.user_id = allLastRecharge.user_id
         left join allOtherRecharge
                   on allFirstRecharge.product_id = allOtherRecharge.product_id and allFirstRecharge.user_id = allOtherRecharge.user_id
         left join allMonthRecharge  on allFirstRecharge.product_id = allMonthRecharge.product_id and allFirstRecharge.user_id = allMonthRecharge.user_id
         left join allFirstSubscribe  on allFirstRecharge.product_id = allFirstSubscribe.product_id and allFirstRecharge.user_id = allFirstSubscribe.user_id
         left join allLastSubscribe  on allFirstRecharge.product_id = allLastSubscribe.product_id and allFirstRecharge.user_id = allLastSubscribe.user_id
         left join allOtherSubscribe  on allFirstRecharge.product_id = allOtherSubscribe.product_id and allFirstRecharge.user_id = allOtherSubscribe.user_id
         left join recharge_mode  on allFirstRecharge.product_id = recharge_mode.product_id and allFirstRecharge.user_id = recharge_mode.user_id
		 left join coupon_mode  on allFirstRecharge.product_id = coupon_mode.product_id and allFirstRecharge.user_id = coupon_mode.user_id
    ;
