----------------------------------------------------------------
-- 程序功能： 海剧优化师每日投放统计
-- 程序名： P_ads_sv_advertisement_optimize_di
-- 目标表： ads.ads_sv_advertisement_optimize_di
-- 负责人： tyg
-- 开发日期：2026-05-28
----------------------------------------------------------------

insert into ads.ads_sv_advertisement_optimize_di
with book_info as (
    select book_info.series_id                                                                               as book_id
         , book_info.series_name
         , book_info.source_series_code
         , if( source_series_code like '%-%' , split_part(source_series_code, '-', 1) , source_series_code ) as main_code
         , book_info.language                                                                                as languageid
         , dic_booklang.cd_val_desc                                                                          as book_language
         , upper(dic_booklang_en.cd_val)                                                                     as book_en_language
         , regexp_replace(book_info.source_series_code, '[0-9].*$', '')                                      as code_type
         , concat( upper(dic_booklang_en.cd_val) , '-' , book_info.source_series_code )                      as series_code
      from dim.dim_sv_series_hi as book_info
      left join dim.dim_pub_code_mapping_dict as dic_booklang
        on book_info.language = dic_booklang.cd_val
       and dic_booklang.app_plat = 'pub'
       and dic_booklang.cd_col = 'lang_cd'
      left join dim.dim_pub_code_mapping_dict as dic_booklang_en
        on dic_booklang.cd_val_desc = dic_booklang_en.cd_val_desc
       and dic_booklang_en.app_plat = 'pub'
       and dic_booklang_en.cd_col = 'lang_abbr'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)
, z2 as (
    select a.dt
         , b.book_id
         , book_info.languageid
         , book_info.book_language
         , book_info.source_series_code
         , book_info.main_code
         , book_info.code_type
         , a.ad_id
         , b.ad_target
         , b.ad_optimizer_uid
         , b.ads_optimizer
         , a.product_id
         , a.core
         , a.mt
         , a.source_chl
         , sum(a.cost_amount)                           as cost_amount
         , sum(a.reg_num)                               as reg_num
         , sum(a.day0_first_pay_num)                    as pay_num
         , sum(a.day0_amount) + sum(a.day0_amount_byad) as day0_amount
      from ads.ads_advertisement_fbadroiinstallreferrer_view as a
      left join ads.ads_advertisement_adext_view as b
        on a.ad_id = b.ad_id
       and a.product_id = b.product_id
      left join book_info
        on b.book_id = book_info.book_id
    where a.dt = '${dt}'
       and a.product_id = 6833
       and a.core in (1, 4, 15)
       and a.source_chl in ('fbs2s', 'facebook', 'tt', 'applovin_int', 'awords', 'snapchat')
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
)
, z3 as (
    select z2.dt
         , z2.book_id
         , z2.languageid
         , z2.book_language
         , z2.source_series_code
         , z2.main_code
         , z2.code_type
         , z2.ad_id
         , z2.ad_target
         , z2.ad_optimizer_uid
         , z2.ads_optimizer
         , z2.product_id
         , z2.core
         , z2.mt
         , z2.source_chl
         , z2.cost_amount
         , z2.reg_num
         , z2.pay_num
         , z2.day0_amount
         , b.r0std
         , z2.cost_amount * b.r0std as r0_std_amount
      from z2
      left join (select datekey
                      , projectcode
                      , core
                      , mt
                      , sourcechl
                      , currentlanguage
                      , adtarget
                      , max(r0std)      as r0std
                   from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily
                  where projectcode = 2
                  group by 1, 2, 3, 4, 5, 6, 7
                ) as b
        on z2.core = b.core
       and z2.mt = b.mt
       and z2.languageid = b.currentlanguage
       and z2.source_chl = b.sourcechl
       and z2.dt = b.datekey
       and ifnull(z2.ad_target, '') = ifnull(b.adtarget, '')
)
select dt
     , book_id
     , core
     , source_chl
     , ad_optimizer_uid                                              as optimizer_id
     , languageid
     , book_language
     , main_code
     , source_series_code
     , ads_optimizer                                                 as optimizer_name
     , coalesce(sum(cost_amount), 0)                                 as cost_amount
     , coalesce(sum(day0_amount) / nullif(sum(cost_amount), 0), 0)   as d0_roi
     , coalesce(sum(r0_std_amount) / nullif(sum(cost_amount), 0), 0) as d0_standard
     , coalesce(sum(day0_amount) / nullif(sum(r0_std_amount), 0), 0) as d0_attainment_rate
     , coalesce(sum(reg_num), 0)                                     as register_count
     , coalesce(sum(cost_amount) / nullif(sum(reg_num), 0), 0)       as cpi
     , coalesce(sum(cost_amount) / nullif(sum(pay_num), 0), 0)       as d0_cac
     , now()                                                         as etl_tm
  from z3
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
;
