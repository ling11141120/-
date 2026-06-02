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
, book_std as (
    select a1.BookId     as book_id
         , a1.Mt         as mt
         , a1.SourceChl  as source_chl
         , a1.DateKey    as date_key
         , a1.AdTarget   as ad_target
         , max(a1.R0Std) as r0_std
      from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily as a1
     where a1.DateKey between '${bf_1_dt}'
       and '${dt}'
     group by 1, 2, 3, 4, 5
)
, put_flow_tag as (
    select a1.Dt           as dt
         , a1.AdSetId      as ad_set_id
         , max(a1.StdCode) as std_code
      from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgFlowTag as a1
     where a1.ProjectCode = 1
       and a1.Dt between '${bf_1_dt}'
       and '${dt}'
     group by 1, 2
)
, put_std as (
    select a1.CurrentLanguage as current_language
         , a1.DateKey         as date_key
         , a1.BookChannel     as book_channel
         , a1.SourceChl       as source_chl
         , a1.Core            as core
         , a1.StdCode         as std_code
         , a1.AdTarget        as ad_target
         , a1.BookType        as story_type
         , a1.Mt              as mt
         , max(a1.R0Std)      as r0_std
      from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily as a1
     where a1.ProjectCode = 1
       and a1.DateKey between '${bf_1_dt}'
       and '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)
, iaa_scale as (
    select a1.ProductId
         , a1.Mt
         , a1.Core
         , a1.AmountDate
         , max(a1.AdMobRatio) as AdMobRatio
         , max(a1.MaxRatio)   as MaxRatio
      from ads.ads_ad_iaa_scale as a1
     where a1.AmountDate between '${bf_1_dt}'
       and '${dt}'
     group by 1, 2, 3, 4
)
, roi_detail as (
    select date(a1.create_time) as roi_dt
         , a2.book_id
         , a3.site_id
         , sum(a1.cost_amount)  as cost_amount
         , sum( case when date(a1.create_time) between '${bf_1_dt}' and '${dt}' then coalesce(a1.day0_amount, 0) + if( date(a1.create_time) >= '2026-01-01' , ifnull(a1.day0_amount_admob * ifnull(a4.AdMobRatio, 1), 0) + ifnull(a1.day0_amount_max * ifnull(a4.MaxRatio, 1), 0) + ifnull(a1.day0_amount_h5, 0) , ifnull(a1.day0_amount_byad * ifnull(a4.AdMobRatio, 1), 0) ) else 0 end ) as d0_amount
         , sum( case when date(a1.create_time) between '${bf_1_dt}' and '${dt}' then coalesce(a7.r0_std, a8.r0_std, 0) * a1.cost_amount else 0 end ) as std_amount
      from dwd.dwd_advertisement_fbadroiinstallreferrer_view    as a1
      left join ads.ads_advertisement_adext_view                as a2
        on a1.product_id = a2.product_id
       and a1.ad_id = a2.ad_id
      join book_info                                            as a3
        on a2.book_id = a3.book_id
      left join iaa_scale                                       as a4
        on a1.product_id = a4.ProductId
       and a1.mt = a4.Mt
       and a1.core = a4.Core
       and date_format(date(a1.create_time), '%Y-%m-%d') = a4.AmountDate
      left join ods.ods_tidb_sharpengine_ads_global_FbAccount   as a5
        on a1.fb_account = a5.account
      left join put_flow_tag                                    as a6
        on a6.dt = date(a1.create_time)
       and a6.ad_set_id = a1.ad_set_id
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
       and ifnull(a8.std_code, '') = ifnull(a6.std_code, '')
       and a8.story_type = a2.story_type
     where date(a1.create_time) <= '${dt}'
       and (a5.fbaccounttype = 0 or a5.fbaccounttype is null)
       and a1.product_id in (
           select b1.ProductId
             from ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da as b1
           where b1.ProjectCode = 1
       )
     group by 1, 2, 3
)
, result as (
    select cast('${bf_1_dt}'   as date) as dt
         , a1.book_id
         , a1.site_id
         , sum(a1.cost_amount) as total_cost_amount
         , sum(case when a1.roi_dt between date_sub('${bf_1_dt}', interval 2 day) and '${bf_1_dt}' then a1.cost_amount else 0 end) / 3 as avg_3d_cost_amount
         , sum(case when a1.roi_dt = '${bf_1_dt}' then a1.d0_amount else 0 end) as today_amount
         , sum(case when a1.roi_dt = '${bf_1_dt}' then a1.std_amount else 0 end) as today_std_amount
      from roi_detail as a1
     where a1.roi_dt <= '${bf_1_dt}'
     group by 1, 2, 3

union all

    select cast('${dt}'        as date) as dt
         , a1.book_id
         , a1.site_id
         , sum(a1.cost_amount) as total_cost_amount
         , sum(case when a1.roi_dt between date_sub('${dt}', interval 2 day) and '${dt}' then a1.cost_amount else 0 end) / 3 as avg_3d_cost_amount
         , sum(case when a1.roi_dt = '${dt}' then a1.d0_amount else 0 end) as today_amount
         , sum(case when a1.roi_dt = '${dt}' then a1.std_amount else 0 end) as today_std_amount
      from roi_detail as a1
     where a1.roi_dt <= '${dt}'
     group by 1, 2, 3
)
select a1.dt
     , substr(a1.book_id, 1, length(a1.book_id) - 3) as book_id
     , a1.site_id
     , cast(a1.total_cost_amount                     as decimal(16, 2)) as total_cost_amount
     , cast(a1.avg_3d_cost_amount                    as decimal(16, 2)) as avg_3d_cost_amount
     , cast(a1.today_amount                          as decimal(16, 2)) as today_amount
     , cast(a1.today_std_amount                      as decimal(16, 2)) as today_std_amount
     , cast(case when a1.today_std_amount > 0 then a1.today_amount / a1.today_std_amount end as decimal(16, 4)) as d0_reach_rate
     , now()                                         as etl_tm
  from result as a1
;