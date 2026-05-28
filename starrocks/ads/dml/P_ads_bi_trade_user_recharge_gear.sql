----------------------------------------------------------------
-- 程序功能： 用户域登录阅读充值消耗汇总活跃表
-- 程序名： P_ads_bi_trade_user_recharge_gear
-- 目标表： ads.ads_bi_trade_user_recharge_gear
-- 负责人： xjc
-- 开发日期： 2026-03-03
-- 版本号： v0.0.1
----------------------------------------------------------------

delete from ads.ads_bi_trade_user_recharge_gear where dt ='${bf_1_dt}';

insert into ads.ads_bi_trade_user_recharge_gear
with source_chl as (
    select product_id
          ,user_id
          ,source_chl
      from (select product_id
                  ,user_id
                  ,source                                                                            as source_chl
                  ,row_number() over (partition by product_id, user_id order by create_time desc)    as rn
              from dwd.dwd_user_install_info_ed_view
             where product_id not in (6833)
           )    as a1
     where rn = 1
)
, maintab as (
    select dt
          ,product_id
          ,user_id
          ,weekofyear(dt)           as which_weeks
          ,month(dt)                as which_months
          ,current_language2
          ,source_chl
          ,reg_country
          ,country_level
          ,mt
          ,corever
          ,source
          ,shop_item
          ,recharge_gear
          ,is_first_charge
          ,sum(charge_cnt)          as charge_cnt
          ,sum(before_charge)       as before_charge
          ,sum(after_charge)        as after_charge
          ,now()                    as etl_time
          ,is_valid
          ,is_first_subscription
          ,max(autorenew_times)     as autorenew_times
          ,max(subscribe_status)    as subscribe_status
          ,max(subpay_type)         as subpay_type
          ,item_type                as item_type
          ,subscribe_mode           as subscribe_mode
      from (select b1.dt
                  ,b1.product_id
                  ,b1.user_id
                  ,b1.current_language2
                  ,b1.source_chl
                  ,b1.reg_country
                  ,ifnull(b3.level, 2)                as country_level
                  ,b1.mt
                  ,b2.source
                  ,b1.corever
                  ,b1.shop_item
                  ,b1.recharge_gear
                  ,if(b4.userid is not null, 1, 0)    as is_first_charge
                  ,b1.charge_cnt
                  ,b1.before_charge
                  ,b1.after_charge
                  ,case when (b1.shop_item in (810, 830, 840, 850, 800) and b6.item_id is null) or b1.shop_item = 0 then 0
                        else 1
                    end                               as is_valid
                  ,case when b1.shop_item not in (810, 830, 840, 850, 800) then null
                        when b1.shop_item in (810, 830, 840, 850, 800) and b6.item_id is not null and b5.userid is null then 1
                        when b1.shop_item in (810, 830, 840, 850, 800) and b6.item_id is not null and b5.userid is not null then 0
                    end                               as is_first_subscription
                  ,b1.autorenew_times
                  ,b1.subscribe_status
                  ,b1.subpaytype                      as subpay_type
                  ,item_type
                  ,b1.subscribe_mode
              from (select c1.dt
                          ,c1.productid     as product_id
                          ,c1.userid        as user_id
                          ,c2.current_language2
                          ,c3.source_chl    as source_chl
                          ,c2.reg_country
                          ,c2.mt
                          ,c2.corever
                          ,c1.shopitem      as shop_item
                          ,itemcount        as recharge_gear
                          ,substring_index(
                                          substring_index(
                                                          substring_index(
                                                                          substring_index(
                                                                                          substring_index(
                                                                                                          substring_index(
                                                                                                                          substring_index(
                                                                                                                                          substring_index(
                                                                                                                                                          substring_index(
                                                                                                                                                                          substring_index(
                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                                                                                          substring_index(
                                                                                                                                                                                                                                                                                                                                                                                                           substring_index(
                                                                                                                                                                                                                                                                                                                                                                                                                            substring_index(extinfo, '|', -1)
                                                                                                                                                                                                                                                                                                                                                                                                                            , 'readerfr.'
                                                                                                                                                                                                                                                                                                                                                                                                                            , -1
                                                                                                                                                                                                                                                                                                                                                                                                                           )
                                                                                                                                                                                                                                                                                                                                                                                                           , 'minireaderfr.', -1
                                                                                                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                                                                                                           , 'cdycnovelfr.', -1
                                                                                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                                                                                           , 'tcreader.', -1
                                                                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                                                                           , 'minireaderft.', -1
                                                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                                                           , 'minireaderen.', -1
                                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                                           , 'ereader.', -1
                                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                                           , 'readerpt.', -1
                                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                                           , 'novelpt.', -1
                                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                                           , 'spainreader.', -1
                                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                                           , 'noveltw.', -1
                                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                                           , 'novelen.', -1
                                                                                                                                                                                                                                          )
                                                                                                                                                                                                                             , 'readerru.', -1
                                                                                                                                                                                                                             )
                                                                                                                                                                                                             , 'minireaderes.', -1
                                                                                                                                                                                                            )
                                                                                                                                                                                           , 'minireaderth.', -1
                                                                                                                                                                                          )
                                                                                                                                                                           , 'readerid.', -1
                                                                                                                                                                          )
                                                                                                                                                           , 'thai.', -1
                                                                                                                                                          )
                                                                                                                                          , 'noveles.', -1
                                                                                                                                          )
                                                                                                                         , 'novelru.', -1
                                                                                                                         )
                                                                                                          , 'reader4.', -1
                                                                                                          )
                                                                                          , 'novelth.', -1
                                                                                          )
                                                                         , 'novelid.', -1
                                                                         )
                                                       , 'readerjc1.', -1
                                                       )
                                      , 'noveljc1.', -1
                                      )                                                                                                 as item_id
                          ,subpaytype
                          ,count(c1.userid)                                                                                             as charge_cnt
                          ,sum(c1.itemcount)                                                                                            as before_charge
                          ,sum(case when c1.dt < '2021-02-01' and c1.systemtype in (336617, 336651) and c1.itemcount > 0 then c1.itemcount * 0.014
                                    when c1.dt < '2021-02-01' then c1.itemcount
                                    else c1.baseamount / 100
                                end
                              )                                                                                                         as after_charge
                          ,max(substring_index(substring_index(cooorderextinfo, '"AutoRenewTimes":', -1), ',"SubscribeStatus":', 1))    as autorenew_times
                          ,max(substring_index(substring_index(cooorderextinfo, '"SubscribeStatus":', -1), '}', 1))                     as subscribe_status
                          ,case when get_json_string(SensorsData,'$.subscription_period') = 1 then '周卡'
                                when get_json_string(SensorsData,'$.subscription_period') = 2 then '月卡'
                                when get_json_string(SensorsData,'$.subscription_period') = 3 then '季卡'
                                when get_json_string(SensorsData,'$.subscription_period') = 4 then '年卡'
                                when get_json_string(SensorsData,'$.subscription_period') = 5 then '天卡'
                                else null
                            end                                                                                                         as item_type
                          ,c1.subscribe_mode                                                                                            as subscribe_mode
                      from dwd.dwd_trade_user_payorder            as c1
                      left join dim.dim_user_account_info_view    as c2
                        on c1.productid = c2.product_id
                       and c1.userid = c2.id
                      left join source_chl                        as c3
                        on c1.productid = c3.product_id
                       and c1.userid = c3.user_id
                     where c1.dt = '${bf_1_dt}'
                     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 19
                   )         as b1
              left join (select product_id
                               ,user_id
                               ,source
                           from dws.dws_srsv_wide_user_type_info_di
                          where user_period = 1
                            and product_id not in (6883, 6833)
                        )    as b2
                on b1.product_id = b2.product_id
               and b1.user_id = b2.user_id
              left join (select product_id
                               ,short_name
                               ,level
                           from dim.dim_countrylevel
                        )    as b3
                on b1.product_id = b3.product_id
               and b1.reg_country = b3.short_name
              left join (
                         select firstchargeday
                               ,productid
                               ,userid
                           from dws.dws_trade_user_shopitem_charge_ed
                          where firstchargeday = '${bf_1_dt}'
                          group by 1, 2, 3
                        )    as b4
                on b1.dt = b4.firstchargeday
               and b1.product_id = b4.productid
               and b1.user_id = b4.userid
              left join (select productid
                               ,userid
                               ,shopitem
                               ,subpaytype
                               ,max(vipexpiretime)
                           from dwd.dwd_trade_user_payorder
                          where vipexpiretime >= '${bf_1_dt}'
                            and createtime < '${bf_1_dt}'
                            and shopitem in (810, 830, 840, 850)
                          group by 1, 2, 3, 4
                        )    as b5
                on b1.product_id = b5.productid
               and b1.user_id = b5.userid
               and b1.shop_item = b5.shopitem
               and b1.subpaytype = b5.subpaytype
              left join (select item_id
                               ,case when pay_type = 2 then 'GooglePlay'
                                     when pay_type = 1 then 'AppStore'
                                     when pay_type = 5 then 'AppGallery'
                                     when pay_type = 9 then 'PayPalV2'
                                 end    as subpaytype
                           from dim.dim_trade_pay_item_info_view
                          group by item_id, pay_type
                        )    as b6
                on b1.item_id = b6.item_id
               and b1.subpaytype = b6.subpaytype
           )    as a1
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20 ,21, 25, 26
)
select a1.dt                       as dt                       -- 统计周期
      ,a1.product_id               as product_id               -- 产品id
      ,a1.user_id                  as user_id                  -- 用户id
      ,'ctt'                       as period_type              -- 统计周期类型,ctt/rmt,rmt(拉活用户)
      ,a2.user_type                as user_type                -- 用户类型
      ,a1.which_weeks              as which_weeks              -- 对应日期的周数
      ,a1.which_months             as which_months             -- 对应日期的月份
      ,a1.current_language2        as current_language2        -- 投放语言（注册语言）
      ,a1.source_chl               as source_chl               -- 最新渠道
      ,a1.reg_country              as reg_country              -- 注册国家
      ,a1.country_level            as country_level            -- 国家等级
      ,a1.mt                       as mt                       -- 媒体类型
      ,a1.corever                  as corever                  -- core版本
      ,a1.source                   as source                   -- 来源
      ,a1.shop_item                as shop_item                -- 购买商品
      ,a1.recharge_gear            as recharge_gear            -- 充值档位
      ,a1.is_first_charge          as is_first_charge          -- 是否首充
      ,a1.charge_cnt               as charge_cnt               -- 充值次数
      ,a1.before_charge            as before_charge            -- 充值前金额
      ,a1.after_charge             as after_charge             -- 充值后金额
      ,a1.etl_time                 as etl_time                 -- etl时间
      ,a1.is_valid                 as is_valid                 -- 是否有效
      ,a1.is_first_subscription    as is_first_subscription    -- 是否首购
      ,a1.autorenew_times          as autorenew_times          -- 自动续费次数
      ,a1.subscribe_status         as subscribe_status         -- 订阅状态
      ,a1.subpay_type              as subpay_type              -- 订阅支付类型
      ,a3.user_ad_source           as user_ad_source           -- 用户广告来源
      ,a1.item_type                as item_type                -- 购买商品类型
      ,a1.subscribe_mode           as subscribe_mode           -- 订阅方式
  from maintab                              as a1
  left join (select dt
                   ,product_id
                   ,user_id
                   ,period_type
                   ,user_type
               from dws.dws_user_wide_active_period_ed
              where dt = '${bf_1_dt}'
                and period_type = 'ctt'
            )                               as a2
    on a1.dt = a2.dt
   and a1.product_id = a2.product_id
   and a1.user_id = a2.user_id
  left join dim.dim_user_other_info_view    as a3
    on a1.product_id = a3.product_id
   and a1.user_id = a3.id
 union all
select a1.dt                       as dt                       -- 统计周期
      ,a1.product_id               as product_id               -- 产品id
      ,a1.user_id                  as user_id                  -- 用户id
      ,'rmt'                       as period_type              -- 统计周期类型/rmt,rmt(拉活用户)
      ,a2.user_type                as user_type                -- 用户类型
      ,a1.which_weeks              as which_weeks              -- 对应日期的周数
      ,a1.which_months             as which_months             -- 对应日期的月份
      ,a1.current_language2        as current_language2        -- 投放语言（注册语言）
      ,a1.source_chl               as source_chl               -- 最新渠道
      ,a1.reg_country              as reg_country              -- 注册国家
      ,a1.country_level            as country_level            -- 国家等级
      ,a1.mt                       as mt                       -- 媒体类型
      ,a1.corever                  as corever                  -- core版本
      ,a1.source                   as source                   -- 来源
      ,a1.shop_item                as shop_item                -- 购买商品
      ,a1.recharge_gear            as recharge_gear            -- 充值档位
      ,a1.is_first_charge          as is_first_charge          -- 是否首充
      ,a1.charge_cnt               as charge_cnt               -- 充值次数
      ,a1.before_charge            as before_charge            -- 充值前金额
      ,a1.after_charge             as after_charge             -- 充值后金额
      ,a1.etl_time                 as etl_time                 -- etl时间
      ,a1.is_valid                 as is_valid                 -- 是否有效
      ,a1.is_first_subscription    as is_first_subscription    -- 是否首购
      ,a1.autorenew_times          as autorenew_times          -- 自动续费次数
      ,a1.subscribe_status         as subscribe_status         -- 订阅状态
      ,a1.subpay_type              as subpay_type              -- 订阅支付类型
      ,a3.user_ad_source           as user_ad_source           -- 用户广告来源
      ,a1.item_type                as item_type                -- 购买商品类型
      ,a1.subscribe_mode           as subscribe_mode           -- 订阅方式
  from maintab                              as a1
  left join (select dt
                   ,product_id
                   ,user_id
                   ,period_type
                   ,user_type
               from dws.dws_user_wide_active_period_ed
              where dt = '${bf_1_dt}'
                and period_type = 'rmt'
            )                               as a2
    on a1.dt = a2.dt
   and a1.product_id = a2.product_id
   and a1.user_id = a2.user_id
  left join dim.dim_user_other_info_view    as a3
    on a1.product_id = a3.product_id
   and a1.user_id = a3.id
;

