----------------------------------------------------------------
-- 程序功能： 海外短剧-用户充值表
-- 程序名： P_ads_bi_short_video_trade_user_subscribe_di
-- 目标表： ads.ads_bi_short_video_trade_user_subscribe_di
-- 负责人： qhr
-- 开发日期： 2026-03-03
----------------------------------------------------------------

delete from ads.ads_bi_short_video_trade_user_subscribe_di where dt = '${bf_1_dt}';
insert into ads.ads_bi_short_video_trade_user_subscribe_di
with t1 as (
    select dt
         , log_id                  as id
         , product_id
         , order_id
         , user_id
         , core                    as corever
         , mt
         , recharge_type_cd        as shop_item
         , item_id
         , recharge_amt            as item_count
         , recharge_channel        as subpay_type
         , card_expire_time        as vip_expire_time
         , base_amount / 100       as after_charge
         , row_number() over (partition by user_id, recharge_type_cd, item_id
                                  order by create_time desc
                             )     as shop_num
         , subscribe_status
         , create_time
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where dt = '${bf_1_dt}'
       and product_id = 6833
       and recharge_type_cd in ('840', '810', '860')
)
, tmp_user_shop_num_da as (
    select product_id
         , user_id
         , recharge_type_cd        as shop_item
         , item_id
         , first_subscribe_time    as first_time
         , subscribe_num           as shop_num
         , subscribe_status
      from dws.dws_trade_user_subscription_agg
     where dt = '${bf_1_dt}'
       and product_id = 6833
)
, t2 as (
    select t1.dt
         , t1.product_id
         , t1.id
         , t1.order_id
         , t3.core
         , t3.mt
         , t3.current_language2
         , t3.country
         , t1.user_id
         , if(t1.shop_item=860,810,t1.shop_item)    as shop_item
         , t1.item_id
         , t1.item_count
         , t2.vip_type_info                         as vip_type
         , t1.subpay_type
         , t2.goods_attribute                       as charge_type
         , t2.price
         , t2.first_price
         , t2.first_effective_time                  as first_validity
         , t5.first_time
         , t1.after_charge
         , if(  t1.vip_expire_time is not null
              , t1.vip_expire_time
              , case when t2.vip_type = 1 then date_add(t1.create_time, interval 1 month)            -- 1, 月卡
                     when t2.vip_type = 2 then date_add(t1.create_time, interval 3 month)            -- 2, 季卡
                     when t2.vip_type = 3 then date_add(t1.create_time, interval 1 year)             -- 3, 年卡
                     when t2.vip_type = 4 then date_add(t1.create_time, interval 7 day)              -- 4, 周卡
                     when t2.vip_type = 5 then date_add(t1.create_time, interval effective_time day) -- 5, 天卡
                 end
             )                                      as vip_expire_time
         , if(  t1.vip_expire_time is null
              , t1.create_time
              , case when shop_item_id = 810 and vip_type = 1 then months_add(vip_expire_time, -effective_time) -- SVIP月卡
                     when shop_item_id = 840 and vip_type = 1 then date_sub(vip_expire_time, effective_time)    -- 新福利包月卡
                     when shop_item_id = 860 and vip_type = 1 then date_sub(vip_expire_time, effective_time)    -- NSVIP月卡
                     when vip_type = 2 then months_add(vip_expire_time, -effective_time)                        -- 季卡
                     when vip_type = 3 then months_add(vip_expire_time, -effective_time)                        -- 年卡
                     when vip_type = 4 then date_sub(vip_expire_time, effective_time)                           -- 周卡
                     when vip_type = 5 then date_sub(vip_expire_time, effective_time)                           -- 天卡
                  end
             )                                     as vip_start_time
         , if(t4.shop_num - t1.shop_num = 0, 1, 2) as subscribe_status
         , t4.shop_num - t1.shop_num               as autoRenew_times
         , t5.shop_num
      from t1
      left join tmp_user_shop_num_da as t4
        on t1.product_id = t4.product_id
       and t1.user_id = t4.user_id
       and t1.shop_item = t4.shop_item
       and t1.item_id = t4.item_id
      left join (select product_id
                      , user_id
                      , min(first_time) as first_time
                      , sum(shop_num)   as shop_num
                   from tmp_user_shop_num_da
                  group by 1, 2
                ) t5
        on t1.product_id = t5.product_id
       and t1.user_id = t5.user_id
      left join (select item_id
                      , shop_item_id
                      , effective_time
                      , vip_type
                      , case when vip_type = 1 then '月卡'
                             when vip_type = 2 then '季卡'
                             when vip_type = 3 then '年卡'
                             when vip_type = 4 then '周卡'
                             when vip_type = 5 then concat(effective_time, '天卡')
                         end                       as vip_type_info
                      , goods_attribute
                      , first_price
                      , first_effective_time
                      , max(price)                 as price
                   from dim.dim_short_video_goods_view
                  where shop_item_id in (840, 810, 860)
                    and is_remove = 0
                  group by 1, 2, 3, 4, 5, 6, 7, 8
                ) t2
        on t1.item_id = t2.item_id
       and t1.shop_item = t2.shop_item_id
      left join (select product_id
                      , user_id
                      , corever     as core
                      , mt
                      , current_language2
                      , reg_country as country
                   from dim.dim_short_video_user_accountinfo
                ) t3
        on t1.product_id = t3.product_id
       and t1.user_id = t3.user_id
     where t2.item_id is not null
)
select dt
     , product_id
     , id
     , order_id
     , core
     , mt
     , current_language2
     , country
     , user_id
     , shop_item
     , item_id
     , item_count
     , vip_type
     , subpay_type
     , charge_type
     , price
     , first_price
     , first_validity
     , first_time
     , after_charge
     , vip_expire_time
     , vip_start_time
     , null                                                                                                 as cancel_time
     , subscribe_status
     , autoRenew_times
     , shop_num
       -- 计算第一个月的天数
     , greatest(datediff(least(vip_expire_date, last_day(time0)), time0) + 1, 0)                            as M0
       -- 计算第二个月的天数
     , greatest(datediff(least(vip_expire_date, last_day(time1)), date_format(time1, '%Y-%m-01')) + 1, 0)   as M1
       -- 计算第三个月的天数
     , greatest(datediff(least(vip_expire_date, last_day(time2)), date_format(time2, '%Y-%m-01')) + 1, 0)   as M2
       -- 计算第四个月的天数
     , greatest(datediff(least(vip_expire_date, last_day(time3)), date_format(time3, '%Y-%m-01')) + 1, 0)   as M3
     , greatest(datediff(least(vip_expire_date, last_day(time4)), date_format(time4, '%Y-%m-01')) + 1, 0)   as M4
     , greatest(datediff(least(vip_expire_date, last_day(time5)), date_format(time5, '%Y-%m-01')) + 1, 0)   as M5
     , greatest(datediff(least(vip_expire_date, last_day(time6)), date_format(time6, '%Y-%m-01')) + 1, 0)   as M6
     , greatest(datediff(least(vip_expire_date, last_day(time7)), date_format(time7, '%Y-%m-01')) + 1, 0)   as M7
     , greatest(datediff(least(vip_expire_date, last_day(time8)), date_format(time8, '%Y-%m-01')) + 1, 0)   as M8
     , greatest(datediff(least(vip_expire_date, last_day(time9)), date_format(time9, '%Y-%m-01')) + 1, 0)   as M9
     , greatest(datediff(least(vip_expire_date, last_day(time10)), date_format(time10, '%Y-%m-01')) + 1, 0) as M10
     , greatest(datediff(least(vip_expire_date, last_day(time11)), date_format(time11, '%Y-%m-01')) + 1, 0) as M11
     , greatest(datediff(least(vip_expire_date, last_day(time12)), date_format(time12, '%Y-%m-01')) + 1, 0) as M12
     , now()                                                                                                as etl_time
  from (select *
             , date(vip_start_time)                        as time0
             , date(vip_expire_time)                       as vip_expire_date
             , date_add(vip_start_time, interval 1 month)  as time1
             , date_add(vip_start_time, interval 2 month)  as time2
             , date_add(vip_start_time, interval 3 month)  as time3
             , date_add(vip_start_time, interval 4 month)  as time4
             , date_add(vip_start_time, interval 5 month)  as time5
             , date_add(vip_start_time, interval 6 month)  as time6
             , date_add(vip_start_time, interval 7 month)  as time7
             , date_add(vip_start_time, interval 8 month)  as time8
             , date_add(vip_start_time, interval 9 month)  as time9
             , date_add(vip_start_time, interval 10 month) as time10
             , date_add(vip_start_time, interval 11 month) as time11
             , date_add(vip_start_time, interval 12 month) as time12
          from t2
       ) t
  ;