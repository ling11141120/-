----------------------------------------------------------------
-- 程序功能： 每月充值投放指标表
-- 程序名： P_ads_trade_month_recharge_toufang
-- 目标表： ads.ads_trade_month_recharge_toufang
-- 负责人： qhr
-- 开发日期：2026-06-26
----------------------------------------------------------------

insert into ads.ads_trade_month_recharge_toufang
select t1.month                             -- 月份
     , t1.product_id    as product_id       -- 产品id
     , charge_money     as charge_money     -- 分成后充值金额
     , charge_itemcount as charge_itemcount -- 分成前充值金额
     , spends           as Spend            -- 投放金额(推广费用)
     , now()            as etl_time         -- etl清洗时间
  from (select month
             , product_id
             , sum(charge_money)     as charge_money
             , sum(charge_itemcount) as charge_itemcount
          from dws.dws_trade_user_recharge_30d
         where month >= date_format(date_sub(date_trunc('month', '${dt}'), interval 1 month), '%Y%m')
         group by month, product_id
       )      as t1
  left join (select month
                  , product_id
                  , sum(spend) as spends
               from dws.dws_advertisement_toufang_30d
              where month >= date_format(date_sub(date_trunc('month', '${dt}'), interval 1 month), '%Y%m')
                and (product_id != 6833 or (product_id = 6833 and corever = 1))
              group by month, product_id
            ) as t2
    on t1.month = t2.month
   and t1.product_id = t2.product_id
;