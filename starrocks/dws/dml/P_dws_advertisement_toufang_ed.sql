----------------------------------------------------------------
-- 程序功能： 广告域投放1日汇总表
-- 程序名： P_dws_advertisement_toufang_ed
-- 目标表： dws.dws_advertisement_toufang_ed
-- 负责人： qhr
-- 开发日期：2026-06-26
----------------------------------------------------------------

insert into dws.dws_advertisement_toufang_ed
select dt                              as dt                -- 日期
     , type                            as type              -- 投放渠道类型
     , ProductId                       as product_id        -- 产品id
     , ifnull(Core, -99)               as corever           -- corever
     , ifnull(CurrentLanguage2, -99)   as current_language2 -- 投放语言
     , ifnull(Mt, -99)                 as mt                -- 终端
     , sum(Spend)                      as spend             -- 投放金额
     , now()                           as etl_time          -- etl清洗时间
  from (select fbv.date_start          as dt
             , 1                       as type
             , fbv.ProductId           as ProductId
             , fbacc.Core              as Core
             , fbacc.CurrentLanguage2  as CurrentLanguage2
             , fbacc.Mt                as Mt
             , fbv.Spend               as Spend
          from dim.dim_FbAdDailyInsight_view as fbv
          left join dim.dim_FbAccount_view   as fbacc
            on fbv.FbAccountId = fbacc.Account
         where fbv.date_start >= '${bf_1_dt}'
           and fbv.date_start < '${af_1_dt}'
           and fbv.ProductId not in (7777,8888)
         union all
        select date_start              as dt
             , 2                       as type
             , ProductId               as ProductId
             , Core                    as Core
             , CurrentLanguage2        as CurrentLanguage2
             , Mt                      as Mt
             , Spend                   as Spend
          from dim.dim_LtvDailyInsight_view
         where date_start >= '${bf_1_dt}'
           and date_start < '${af_1_dt}'
           and ProductId not in (7777, 8888, 6833)
         union all
        select ltv.date_start          as dt
             , 2                       as type
             , ltv.productid           as ProductId
             , adext.core              as Core
             , adext.current_language2 as CurrentLanguage2
             , adext.mt                as Mt
             , ltv.spend               as Spend
          from dim.dim_LtvDailyInsight_view          as ltv
          left join dwd.dwd_advertisement_adext_view as adext
            on ltv.adid = adext.ad_id
         where ltv.date_start >= '${bf_1_dt}'
           and ltv.date_start < '${af_1_dt}'
           and ltv.productid = 6833
           and adext.core = 1
         union all
        select ttmltv.Dt               as dt
             , 2                       as type
             , ttmltv.ProductId        as ProductId
             , ttmext.Core             as Core
             , ttmext.CurrentLanguage2 as CurrentLanguage2
             , ttmext.Mt               as Mt
             , ttmltv.Spend            as Spend
          from ods.ods_tidb_sharpengine_ads_global_tiktokminisadltv as ttmltv
          join ods.ods_tidb_sharpengine_ads_global_tiktokminisadext as ttmext
            on ttmltv.AdId = ttmext.AdId
         where ttmltv.Dt >= '${bf_1_dt}'
           and ttmltv.Dt < '${af_1_dt}'
           and coalesce(ttmext.Core, 1) <> 16
         union all
        select date(date_start)        as dt
             , 3                       as type
             , product_id              as ProductId
             , core                    as Core
             , current_language2       as CurrentLanguage2
             , mt                      as Mt
             , spend / 7               as spend
          from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view
         where date_start >= '${bf_1_dt}'
           and date_start < '${af_1_dt}'
           and product_id = 6883
       ) as t1
 group by 1, 2, 3, 4, 5, 6
;
