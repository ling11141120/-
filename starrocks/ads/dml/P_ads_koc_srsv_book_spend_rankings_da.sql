----------------------------------------------------------------
-- 程序功能：koc项目,海阅海剧投放花费书/剧排行
-- 程序名： P_ads_koc_srsv_book_spend_rankings_da
-- 目标表： ads.ads_koc_srsv_book_spend_rankings_da
-- 负责人： roger
-- 开发日期：2026/1/20
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.`ads_koc_srsv_book_spend_rankings_da`
with t1 as (select a.dt                          as dt
                 , if(a.product_id = 6833, 2, 1) as product_type
                 , a.product_id                  as product_id
                 , a.ad_id                       as ad_id
                 , b.book_id
                 , max(spend)                    as spend -- 媒体花费
                 , max(total_recharge_amount)    as total_recharge_amount
                 , max(pay_num)                  as pay_num
                 , max(dev_num)                  as dev_num
            from (select adid                 as ad_id
                       , date_start           as dt
                       , ProductId            as product_id
                       , sum(Spend)           as spend
                       , sum(recharge_amount) as total_recharge_amount -- 付费人数的总充值
                       , sum(pay_num)         as pay_num               -- 付费人数
                       , sum(dev_num)         as dev_num               -- 激活人数
                  from (select adid
                             , date_start
                             , ProductId
                             , Spend
                             , 0 as pay_num
                             , 0 as dev_Num
                             , 0 as recharge_amount
                        from dim.dim_FbAdDailyInsight_view
                        where date_start = '${bf_1_dt}'
                          and Spend >0
                        union all
                        select adid
                             , date_start
                             , ProductId
                             , Spend
                             , 0 as pay_num
                             , 0 as dev_Num
                             , 0 as recharge_amount
                        from dim.dim_LtvDailyInsight_view
                        where date_start = '${bf_1_dt}'
                         and Spend >0
                        union all
                        select AdId
                             , date(CreateTime)
                             , ProductId
                             , 0                 as Spend
                             , sum(PayNum)       as pay_num         -- 付费人数
                             , sum(DevNum)       as dev_num         -- 激活人数
                             , sum(Day150Amount) as recharge_amount -- 付费人数的总充值
                        from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer
                        where CreateTime >= timestamp('${bf_1_dt}')
                          and CreateTime < timestamp('${dt}')
                          and CostAmount > 0 -- 取花费大于0的
                        group by 1, 2, 3
                       ) t
                  group by 1, 2, 3
                 )                                              a
                     left join ads.ads_advertisement_adext_view b
                       on a.ad_id = b.ad_id
                      and b.product_id = a.product_id
            where b.book_id is not null
            group by 1, 2, 3, 4, 5
           )

select '${dt}' as dt
     , product_type
     , rn
     , product_id
     , book_id
     , total_spend
     , total_recharge_amount
     , conversion_rate
     , now()   as etl_tm
from (select product_type
           , product_id
           , book_id
           , total_spend
           , total_recharge_amount
           , conversion_rate
           , row_number() over (partition by product_type order by total_spend desc,book_id desc) as rn
      from (select product_type
                 , product_id
                 , book_id
                 , sum(spend)                  as total_spend
                 , sum(total_recharge_amount)  as total_recharge_amount
                 , sum(pay_num) / sum(dev_num) as conversion_rate
            from t1
            where product_id = 6833
            group by 1, 2, 3
           ) a
      union all
      select product_type
           , product_id
           , book_id
           , total_spend
           , total_recharge_amount
           , conversion_rate
           , row_number() over (partition by product_type order by total_spend desc,book_id desc) as rn
      from (select product_type
                 , product_id
                 , book_id
                 , sum(spend)                  as total_spend
                 , sum(total_recharge_amount)  as total_recharge_amount
                 , sum(pay_num) / sum(dev_num) as conversion_rate
            from t1
            where product_id <> 6833
            group by 1, 2, 3
           ) a
     ) ta
where ta.rn <= 300
;

