----------------------------------------------------------------
-- 程序功能： 内容-孵化书籍花费与D0达标率
-- 程序名： P_ads_content_book_cost_reach_df
-- 目标表： ads.ads_content_book_cost_reach_df
-- 负责人： xjc
-- 开发日期：2026-06-01
----------------------------------------------------------------

-- 前置SQL语句
delete from ads.ads_content_book_cost_reach_df where dt between '${bf_1_dt}' and '${dt}';

-- SQL语句
insert into ads.ads_content_book_cost_reach_df
with book_info as (
    select a1.book_id
         , a1.site_id
      from (select b1.book_id * 1000 + cast(lpad(b1.site_id, 3, '0') as bigint) as book_id
                 , b1.site_id
                 , row_number() over (partition by b1.book_id, b1.site_id order by b1.update_time desc, b1.product_id desc) as rn
              from dim.dim_edit_book_view as b1
             where b1.is_washing_book = 1
               and b1.book_id is not null
               and b1.site_id is not null
           ) as a1
     where a1.rn = 1
)
, stage1_plan as (
    select distinct
           cast(a1.CodeId as bigint) as book_id
         , a1.SourceChl              as source_chl
         , date(a1.BeginDate)        as begin_date
         , date(a1.EndDate)          as end_date
      from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan as a1
     where a1.ProjectCode = 1
       and a1.IsDel = 0
       and a1.CodeStage = 1
       and a1.PlanRound = 1
       and a1.SourceChl = 'applovin_int'
)
, stage1_bounds as (
    select min(a1.begin_date) as min_begin_date
      from stage1_plan as a1
)
, book_std as (
    select a1.BookId     as book_id
         , a1.Mt         as mt
         , a1.SourceChl  as source_chl
         , a1.DateKey    as date_key
         , a1.AdTarget   as ad_target
         , max(a1.R0Std) as r0_std
      from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily as a1
     cross join stage1_bounds as b1
     where a1.DateKey between b1.min_begin_date and '${dt}'
     group by 1, 2, 3, 4, 5
)
, book_series_type as (
    select a1.DateKey           as date_key
         , a1.BookSeries        as book_series
         , max(a1.BookSeriesType) as book_series_type
      from ods.ods_ads_tidb_sharpengine_ads_global_BookSeriesTypeDaily as a1
     cross join stage1_bounds as b1
     where a1.DateKey between b1.min_begin_date and '${dt}'
     group by 1, 2
)
, put_std as (
    select a1.CurrentLanguage as current_language
         , a1.DateKey         as date_key
         , a1.BookChannel     as book_channel
         , a1.SourceChl       as source_chl
         , a1.Core            as core
         , a1.AdTarget        as ad_target
         , a1.BookType        as story_type
         , a1.ProductId       as product_id
         , a1.BookSeriesType  as book_series_type
         , a1.Mt              as mt
         , max(a1.R0Std)      as r0_std
      from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdConfigDaily as a1
     cross join stage1_bounds as b1
     where a1.ProjectCode = 1
       and a1.DateKey between b1.min_begin_date and '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
, iaa_scale as (
    select a1.ProductId
         , a1.Mt
         , a1.Core
         , a1.AmountDate
         , max(a1.AdMobRatio) as AdMobRatio
         , max(a1.MaxRatio)   as MaxRatio
      from ads.ads_ad_iaa_scale as a1
     cross join stage1_bounds as b1
     where a1.AmountDate between b1.min_begin_date and '${dt}'
     group by 1, 2, 3, 4
)
, roi_detail as (
    select date(a1.create_time) as roi_dt
         , a2.book_id
         , a3.site_id
         , sum(a1.cost_amount)  as cost_amount
         , sum(coalesce(a1.day0_amount, 0) + if(date(a1.create_time) >= '2026-01-01', ifnull(a1.day0_amount_admob * ifnull(a4.AdMobRatio, 1), 0) + ifnull(a1.day0_amount_max * ifnull(a4.MaxRatio, 1), 0) + ifnull(a1.day0_amount_h5, 0), ifnull(a1.day0_amount_byad * ifnull(a4.AdMobRatio, 1), 0))) as d0_amount
         , sum(coalesce(a7.r0_std, a8.r0_std, 0) * a1.cost_amount) as std_amount
      from dwd.dwd_advertisement_fbadroiinstallreferrer_view    as a1
      left join ads.ads_advertisement_adext_view                as a2
        on a1.product_id = a2.product_id
       and a1.ad_id = a2.ad_id
      join book_info                                            as a3
        on a2.book_id = a3.book_id
      join stage1_plan                                          as a9
        on a2.book_id = a9.book_id
       and a1.source_chl = a9.source_chl
       and date(a1.create_time) between a9.begin_date and a9.end_date
      left join iaa_scale                                       as a4
        on a1.product_id = a4.ProductId
       and a1.mt = a4.Mt
       and a1.core = a4.Core
       and date_format(date(a1.create_time), '%Y-%m-%d') = a4.AmountDate
      left join ods.ods_tidb_sharpengine_ads_global_FbAccount   as a5
        on a1.fb_account = a5.account
      left join book_series_type                                as a_bs
        on a_bs.date_key = date(a1.create_time)
       and a_bs.book_series = a2.book_series
      left join book_std                                        as a7
        on a7.book_id = a2.book_id
       and a7.mt = a2.mt
       and a7.source_chl = a1.source_chl
       and a7.date_key = date(a1.create_time)
       and ifnull(a7.ad_target, '') = ifnull(a2.ad_target, '')
      left join put_std                                         as a8
        on a8.current_language = a2.current_language2
       and a8.date_key = date(a1.create_time)
       and a8.book_channel = case when a2.book_channel not in (0, 1) then 1 else a2.book_channel end
       and a8.source_chl = a1.source_chl
       and a8.core = a1.core
       and a8.mt = a2.mt
       and ifnull(a8.ad_target, '') = ifnull(a2.ad_target, '')
       and a8.story_type = a2.story_type
       and a8.product_id = a1.product_id
       and a8.book_series_type = IFNULL(a_bs.book_series_type, 1)
     cross join stage1_bounds as b1
     where a1.dt between b1.min_begin_date and '${dt}'
       and (a5.fbaccounttype = 0 or a5.fbaccounttype is null)
       and a1.source_chl = 'applovin_int'
       and a1.product_id in (
           select b1.ProductId
             from ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da as b1
            where b1.ProjectCode = 1
       )
     group by 1, 2, 3
)
, output_dt as (
    select '${bf_1_dt}' as dt
     union all
    select '${dt}'      as dt
)
, valid_output_dt as (
    select distinct
           a1.dt
         , a2.book_id
      from output_dt as a1
      join stage1_plan as a2
        on a1.dt between a2.begin_date and a2.end_date
)
, result as (
    select a2.dt
         , a1.book_id
         , a1.site_id
         , sum(a1.cost_amount) as total_cost_amount
         , sum(case when a1.roi_dt between date_sub(a2.dt, interval 2 day) and a2.dt then a1.cost_amount else 0 end) / 3 as avg_3d_cost_amount
         , sum(a1.d0_amount) as today_amount
         , sum(a1.std_amount) as today_std_amount
      from roi_detail as a1
      join valid_output_dt as a2
        on a1.roi_dt <= a2.dt
       and a1.book_id = a2.book_id
     group by 1, 2, 3
)
select a1.dt
     , substr(a1.book_id, 1, length(a1.book_id) - 3) as book_id
     , a1.site_id
     , cast(a1.total_cost_amount                     as decimal(16, 2)) as total_cost_amount
     , cast(a1.avg_3d_cost_amount                    as decimal(16, 2)) as avg_3d_cost_amount
     , cast(a1.today_amount                          as decimal(16, 2)) as today_amount
     , cast(a1.today_std_amount                      as decimal(16, 2)) as today_std_amount
     , cast(case when a1.today_std_amount > 0 then a1.today_amount / a1.today_std_amount
             end as decimal(16, 4)
           )                                         as d0_reach_rate
     , now()                                         as etl_tm
  from result as a1
;