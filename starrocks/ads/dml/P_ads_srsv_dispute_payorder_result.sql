----------------------------------------------------------------
-- 程序功能： 订单争议结果表数据
-- 程序名： P_ads_srsv_dispute_payorder_result
-- 目标表： ads.ads_srsv_dispute_payorder_result
-- 负责人： wx/xjc
-- 开发日期： 2025-09-19
-- 版本号： v0.0.1  (新增 Airwallex 渠道)
----------------------------------------------------------------

insert into ads.ads_srsv_dispute_payorder_result
with dispute_stripe as (
    select a1.id
          ,'Stripe'                          as product_type
          ,a1.dispute_id
          ,a1.insert_time
          ,a2.product_id                     as product_id
          ,a2.order_id
          ,a2.user_id
          ,a3.user_type
          ,a2.core
          ,a4.enum_name                      as mt
          ,coalesce(a7.remarks, '其他')      as current_language2
          ,a2.shop_item_id
          ,a6.country
          ,case when a8.source_chl in ('fbgroup', 'fbpage', 'fbpost', 'social') then '社媒'
                when a8.source_chl in ('unattributed', 'google-play', 'organic', '(not set)', 'none') then '自然量'
                when a8.source_chl in ('exlink', 'officialsite', 'pinterest', 'podcasts', 'rss', 'webshare', 'seoyt') then 'SEO媒体'
                when a8.source_chl in ('facebook', 'fbs2s', 'tt', 'adwords', 'mediago', 'appleadservice', 'sem', 'mapit', 'tiktok app', 'applovin', 'kwai') then '广告媒体'
                else '其他'
            end                              as source_chl_type
          ,a8.source_chl
          ,if(a1.update_time >= '2025-06-24' and a1.final_status in (3, 4, 6, 9)
             ,a1.update_time
             ,null
             )                               as refund_time
          ,a1.dispute_fee
          ,a1.final_settle_amount            as final_amount
          ,a1.final_balance_transactions_amount
          ,a1.final_dispute_fee
          ,a1.balance_transactions_amount    as balance_transactions_amount
          ,if(a1.final_status = 3, 1, 0)     as is_status_succeed
          ,a1.final_status
          ,a1.counter_fee
      from ods.ods_cdmoney_report_tidb_cn_dispute_stripe               as a1
      left join ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe    as a2
        on a1.dispute_id = a2.dispute_id
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.user_type
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.user_type
                               ,row_number() over (partition by c1.product_id, c1.user_id order by c1.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_short_video_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                  union all
                                 select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                )    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )    as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                      as a3
        on a3.user_id = a2.user_id
       and a3.product_id = ifnull(a2.product_id, left(a2.pay_channel_id, 4))
      left join dim.dim_dic                                            as a4
        on a2.os_type = a4.enum_id
       and a4.table_name = 'dim_user_accountinfo_df'
       and a4.dic_column = 'mt'
      left join (select product_id
                       ,id    as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view
                  group by 1, 2, 3, 4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1, 2, 3, 4
                )                                                      as a5
        on a3.user_id = a5.user_id
       and a3.product_id = a5.product_id
      left join dim.dim_country_dic                                    as a6
        on a5.reg_country = a6.code
      left join dim.dim_dic                                            as a7
        on a5.current_language2 = a7.enum_id
       and a7.table_name = 'dim_producttype'
       and a7.dic_column = 'language_id'
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.last_source    as source_chl
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.last_source
                               ,row_number() over (partition by c1.product_id, c1.user_id
                                                       order by c1.install_date desc, c1.mt asc, c1.corever asc, c1.lang2 asc
                                                  )    as rn
                           from dws.dws_user_market_channel_info_detail_td    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )                                             as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                      as a8
        on ifnull(a2.product_id, left(a2.pay_channel_id, 4)) = a8.product_id
       and a2.user_id = a8.user_id
)
, dispute_paypal as (
    select a1.id
          ,'PayPalV2'                          as product_type
          ,a1.dispute_id
          ,a1.insert_time
          ,a2.product_id                       as product_id
          ,a2.order_id
          ,a2.user_id
          ,a3.user_type
          ,a2.core
          ,a4.enum_name                        as mt
          ,coalesce(a7.remarks, '其他')        as current_language2
          ,a2.shop_item_id
          ,a6.country
          ,case when a8.source_chl in ('fbgroup', 'fbpage', 'fbpost', 'social') then '社媒'
                when a8.source_chl in ('unattributed', 'google-play', 'organic', '(not set)', 'none') then '自然量'
                when a8.source_chl in ('exlink', 'officialsite', 'pinterest', 'podcasts', 'rss', 'webshare', 'seoyt') then 'SEO媒体'
                when a8.source_chl in ('facebook', 'fbs2s', 'tt', 'adwords', 'mediago', 'appleadservice', 'sem', 'mapit', 'tiktok app', 'applovin', 'kwai') then '广告媒体'
                else '其他'
            end                                as source_chl_type
          ,a8.source_chl
          ,if(a1.update_time >= '2025-06-24' and a1.final_status in (5, 6, 7, 8)
             ,a1.update_time
             ,null
             )    as refund_time
          ,0                                   as dispute_fee
          ,a1.final_amount                     as final_amount
          ,a1.adjudication_amount
          ,a1.dispute_fee                      as final_dispute_fee
          ,a1.dispute_amount                   as balance_transactions_amount
          ,if(a1.final_status in (6), 1, 0)    as is_status_succeed
          ,a1.final_status
          ,null                                as counter_fee
      from ods.ods_cdmoney_report_tidb_cn_dispute_paypal               as a1
      left join ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal    as a2
        on a1.dispute_id = a2.dispute_id
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.user_type
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.user_type
                               ,row_number() over (partition by c1.product_id, c1.user_id order by c1.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_short_video_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                  union all
                                 select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                )    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )    as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                      as a3
        on a3.user_id = a2.user_id
       and a3.product_id = ifnull(a2.product_id, left(a2.pay_channel_id, 4))
      left join dim.dim_dic                                            as a4
        on a2.os_type = a4.enum_id
       and a4.table_name = 'dim_user_accountinfo_df'
       and a4.dic_column = 'mt'
      left join (select product_id
                       ,id    as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view
                  group by 1, 2, 3, 4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1, 2, 3, 4
                )                                                      as a5
        on a3.user_id = a5.user_id
       and a3.product_id = a5.product_id
      left join dim.dim_country_dic                                    as a6
        on a5.reg_country = a6.code
      left join dim.dim_dic                                            as a7
        on a5.current_language2 = a7.enum_id
       and a7.table_name = 'dim_producttype'
       and a7.dic_column = 'language_id'
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.last_source    as source_chl
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.last_source
                               ,row_number() over (partition by c1.product_id, c1.user_id
                                                       order by c1.install_date desc, c1.mt asc, c1.corever asc, c1.lang2 asc)    as rn
                           from dws.dws_user_market_channel_info_detail_td    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )                                             as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                      as a8
        on ifnull(a2.product_id, left(a2.pay_channel_id, 4)) = a8.product_id
       and a2.user_id = a8.user_id
)
, ams as (
    select a1.id
          ,'Ams'                           as product_type
          ,a1.dispute_id
          ,a1.insert_time
          ,a2.product_id                   as product_id
          ,a2.order_id
          ,a2.user_id
          ,a3.user_type
          ,a2.core
          ,a4.enum_name                    as mt
          ,coalesce(a7.remarks, '其他')    as current_language2
          ,a2.shop_item_id
          ,a6.country
          ,case when a8.source_chl in ('fbgroup', 'fbpage', 'fbpost', 'social') then '社媒'
                when a8.source_chl in ('unattributed', 'google-play', 'organic', '(not set)', 'none') then '自然量'
                when a8.source_chl in ('exlink', 'officialsite', 'pinterest', 'podcasts', 'rss', 'webshare', 'seoyt') then 'SEO媒体'
                when a8.source_chl in ('facebook', 'fbs2s', 'tt', 'adwords', 'mediago', 'appleadservice', 'sem', 'mapit', 'tiktok app', 'applovin', 'kwai') then '广告媒体'
                else '其他'
            end                       as source_chl_type
          ,a8.source_chl
          ,if(a1.update_time >= '2025-06-24' and a1.final_status in (2, 3, 5, 6)
             ,a1.update_time
             ,null
             )    as refund_time
          ,a1.dispute_fee                  as dispute_fee
          ,a1.dispute_total_amount         as final_amount
          ,a1.dispute_judged_amount
          ,a1.dispute_judged_fee           as final_dispute_fee
          ,a1.dispute_amount               as balance_transactions_amount
          ,if(a1.status = 3, 1, 0)         as is_status_succeed
          ,a1.status                       as final_status
          ,null                            as counter_fee
      from ods.ods_cdmoney_report_tidb_cn_dispute_antom               as a1
      left join ods.ods_cdmoney_report_tidb_cn_dispute_order_antom    as a2
        on a1.dispute_id = a2.dispute_id
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.user_type
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.user_type
                               ,row_number() over (partition by c1.product_id, c1.user_id order by c1.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_short_video_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                  union all
                                 select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                )    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )    as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                     as a3
        on a3.user_id = a2.user_id
       and a3.product_id = ifnull(a2.product_id, left(a2.pay_channel_id, 4))
      left join dim.dim_dic                                           as a4
        on a2.os_type = a4.enum_id
       and a4.table_name = 'dim_user_accountinfo_df'
       and a4.dic_column = 'mt'
      left join (select product_id
                       ,id    as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view
                  group by 1, 2, 3, 4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1, 2, 3, 4
                )                                                     as a5
        on a3.user_id = a5.user_id
       and a3.product_id = a5.product_id
      left join dim.dim_country_dic                                   as a6
        on a5.reg_country = a6.code
      left join dim.dim_dic                                           as a7
        on a5.current_language2 = a7.enum_id
       and a7.table_name = 'dim_producttype'
       and a7.dic_column = 'language_id'
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.last_source    as source_chl
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.last_source
                               ,row_number() over (partition by c1.product_id, c1.user_id
                                                       order by c1.install_date desc, c1.mt asc, c1.corever asc, c1.lang2 asc)    as rn
                           from dws.dws_user_market_channel_info_detail_td    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )                                             as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                                     as a8
        on ifnull(a2.product_id, left(a2.pay_channel_id, 4)) = a8.product_id
       and a2.user_id = a8.user_id
)
, apple as (
    select a1.id
          ,'AppStore'                      as product_type
          ,a1.coo_order_id                 as dispute_id
          ,a1.insert_time
          ,a1.product_id                   as product_id
          ,a1.order_id
          ,a1.user_id
          ,a2.user_type
          ,a1.core
          ,a3.enum_name                    as mt
          ,coalesce(a6.remarks, '其他')    as current_language2
          ,a1.shop_item_id
          ,a5.country
          ,case when a7.source_chl in ('fbgroup', 'fbpage', 'fbpost', 'social') then '社媒'
                when a7.source_chl in ('unattributed', 'google-play', 'organic', '(not set)', 'none') then '自然量'
                when a7.source_chl in ('exlink', 'officialsite', 'pinterest', 'podcasts', 'rss', 'webshare', 'seoyt') then 'SEO媒体'
                when a7.source_chl in ('facebook', 'fbs2s', 'tt', 'adwords', 'mediago', 'appleadservice', 'sem', 'mapit', 'tiktok app', 'applovin', 'kwai') then '广告媒体'
                else '其他'
            end                            as source_chl_type
          ,a7.source_chl
          ,if(a1.update_time >= '2025-06-24' and a1.status in (2, 3)
             ,a1.update_time
             ,null
             )                             as refund_time
          ,0                               as dispute_fee
          ,a1.final_settle_amount          as final_amount
          ,a1.final_settle_amount
          ,0                               as final_dispute_fee
          ,a1.dispute_fee                  as balance_transactions_amount
          ,if(a1.status = 3, 1, 0)         as is_status_succeed
          ,a1.status                       as final_status
          ,null                            as counter_fee
      from ods.ods_cdmoney_report_tidb_cn_dispute_applepay    as a1
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.user_type
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.user_type
                               ,row_number() over (partition by c1.product_id, c1.user_id order by c1.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_short_video_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                  union all
                                 select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                )    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )    as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                             as a2
        on a2.user_id = a1.user_id
       and a2.product_id = ifnull(a1.product_id, left(a1.pay_channel_id, 4))
      left join dim.dim_dic                                   as a3
        on a1.os_type = a3.enum_id
       and a3.table_name = 'dim_user_accountinfo_df'
       and a3.dic_column = 'mt'
      left join (select product_id
                       ,id    as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view
                  group by 1, 2, 3, 4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1, 2, 3, 4
                )                                             as a4
        on a2.user_id = a4.user_id
       and a2.product_id = a4.product_id
      left join dim.dim_country_dic                           as a5
        on a4.reg_country = a5.code
      left join dim.dim_dic                                   as a6
        on a4.current_language2 = a6.enum_id
       and a6.table_name = 'dim_producttype'
       and a6.dic_column = 'language_id'
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.last_source    as source_chl
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.last_source
                               ,row_number() over (partition by c1.product_id, c1.user_id
                                                       order by c1.install_date desc, c1.mt asc, c1.corever asc, c1.lang2 asc)    as rn
                           from dws.dws_user_market_channel_info_detail_td    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )                                             as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                             as a7
        on ifnull(a1.product_id, left(a1.pay_channel_id, 4)) = a7.product_id
       and a1.user_id = a7.user_id
)
, airwallex as (
    select a1.id
          ,'airwallex'                        as product_type
          ,a1.dispute_id                      as dispute_id
          ,a1.insert_time
          ,a1.product_id                      as product_id
          ,a1.order_id
          ,a1.user_id
          ,a2.user_type
          ,a1.core
          ,a3.enum_name                       as mt
          ,coalesce(a6.remarks, '其他')       as current_language2
          ,a1.shop_item_id
          ,a5.country
          ,case when a7.source_chl in ('fbgroup', 'fbpage', 'fbpost', 'social') then '社媒'
                when a7.source_chl in ('unattributed', 'google-play', 'organic', '(not set)', 'none') then '自然量'
                when a7.source_chl in ('exlink', 'officialsite', 'pinterest', 'podcasts', 'rss', 'webshare', 'seoyt') then 'SEO媒体'
                when a7.source_chl in ('facebook', 'fbs2s', 'tt', 'adwords', 'mediago', 'appleadservice', 'sem', 'mapit', 'tiktok app', 'applovin', 'kwai') then '广告媒体'
                else '其他'
            end                               as source_chl_type
          ,a7.source_chl
          ,if(a1.update_time >= '2025-06-24'
             and a1.statusdispute_judged_result in ('WON', 'LOST', 'ACCEPTED', 'REVERSED', 'EXPIRED')
             ,a1.update_time
             ,null
             )                                as refund_time
          ,a1.dispute_fee                     as dispute_fee
          ,a1.final_settle_amount             as final_amount
          ,a1.final_dispute_amount            as final_balance_transactions_amount
          ,a1.dispute_fee                     as final_dispute_fee
          ,a1.dispute_amount                  as balance_transactions_amount
          ,if(a1.statusdispute_judged_result = 'WON', 1, 0)  as is_status_succeed
          ,case a1.statusdispute_judged_result
                when 'REQUIRES_RESPONSE'  then 0   -- 待回复
                when 'CHALLENGED'         then 1   -- 已回复
                when 'ACCEPTED'           then 2   -- 已接受
                when 'REVERSED'           then 3   -- 已撤销
                when 'WON'                then 4   -- 胜诉
                when 'LOST'               then 5   -- 败诉
                when 'EXPIRED'            then 6   -- 已过期
                when 'PENDING_CLOSURE'    then 7   -- 待关闭
                when 'PENDING_DECISION'   then 8   -- 仲裁中
                else 9
              end                             as final_status
          ,null                               as counter_fee
      from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex    as a1
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.user_type
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.user_type
                               ,row_number() over (partition by c1.product_id, c1.user_id order by c1.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_short_video_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                  union all
                                 select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                   from dws.dws_user_wide_active_period_ed
                                  where period_type = 'ctt'
                                  group by 1, 2, 3, 4
                                )    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )    as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                             as a2
        on a2.user_id = a1.user_id
       and a2.product_id = ifnull(a1.product_id, left(a1.pay_channel_id, 4))
      left join dim.dim_dic                                   as a3
        on a1.os_type = a3.enum_id
       and a3.table_name = 'dim_user_accountinfo_df'
       and a3.dic_column = 'mt'
      left join (select product_id
                       ,id    as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view
                  group by 1, 2, 3, 4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1, 2, 3, 4
                )                                             as a4
        on a2.user_id = a4.user_id
       and a2.product_id = a4.product_id
      left join dim.dim_country_dic                           as a5
        on a4.reg_country = a5.code
      left join dim.dim_dic                                   as a6
        on a4.current_language2 = a6.enum_id
       and a6.table_name = 'dim_producttype'
       and a6.dic_column = 'language_id'
      left join (select b1.product_id
                       ,b1.user_id
                       ,b1.last_source    as source_chl
                   from (select c1.product_id
                               ,c1.user_id
                               ,c1.last_source
                               ,row_number() over (partition by c1.product_id, c1.user_id
                                                       order by c1.install_date desc, c1.mt asc, c1.corever asc, c1.lang2 asc)    as rn
                           from dws.dws_user_market_channel_info_detail_td    as c1
                           join (select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_antom
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_applepay
                                  group by 1, 2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex
                                  group by 1, 2
                                )                                             as c2
                             on c1.product_id = c2.product_id
                            and c1.user_id = c2.user_id
                        )    as b1
                  where b1.rn = 1
                )                                             as a7
        on ifnull(a1.product_id, left(a1.pay_channel_id, 4)) = a7.product_id
       and a1.user_id = a7.user_id
)
select a1.id                                   as dt                                   -- id
      ,a1.product_type                         as product_type                         -- 三方产品类型
      ,a1.dispute_id                           as dispute_id                           -- 争议ID
      ,a1.insert_time                          as insert_time                          -- 添加时间
      ,a1.product_id                           as product_id                           -- 订单表>产品ID
      ,a1.order_id                             as order_id                             -- 订单表>订单号
      ,a1.user_id                              as user_id                              -- 订单表>用户ID
      ,a1.user_type                            as user_type                            -- 用户类型
      ,a1.core                                 as core                                 -- 订单表>core
      ,a1.mt                                   as mt                                   -- 订单表>平台,mt,1-iOS,4-安卓,其他
      ,a1.current_language2                    as current_language2                    -- 投放语言
      ,a1.shop_item_id                         as shop_item_id                         -- 充值类型
      ,a1.country                              as country                              -- 国家/地区
      ,a1.source_chl_type                      as source_chl_type                      -- 媒体来源(总)/分类
      ,a1.source_chl                           as source_chl                           -- 媒体来源
      ,a1.refund_time                          as refund_time                          -- 退款时间
      ,a1.dispute_fee                          as dispute_fee                          -- 预扣争议费用
      ,a1.final_amount                         as final_amount                         -- 损失金额
      ,a1.final_balance_transactions_amount    as final_balance_transactions_amount    -- 退款金额
      ,a1.final_dispute_fee                    as final_dispute_fee                    -- 争议费用
      ,a1.balance_transactions_amount          as balance_transactions_amount          -- 争议金额
      ,a1.is_status_succeed                    as is_status_succeed                    -- 是否胜诉，1是0否
      ,a1.final_status                         as final_status                         -- 最终状态
      ,a1.counter_fee                          as counter_fee                          -- 反驳费
      ,now()                                   as etl_time                             -- 数据清洗时间
  from dispute_stripe    as a1
 union all
select a1.id                             as dt
      ,a1.product_type                   as product_type
      ,a1.dispute_id                     as dispute_id
      ,a1.insert_time                    as insert_time
      ,a1.product_id                     as product_id
      ,a1.order_id                       as order_id
      ,a1.user_id                        as user_id
      ,a1.user_type                      as user_type
      ,a1.core                           as core
      ,a1.mt                             as mt
      ,a1.current_language2              as current_language2
      ,a1.shop_item_id                   as shop_item_id
      ,a1.country                        as country
      ,a1.source_chl_type                as source_chl_type
      ,a1.source_chl                     as source_chl
      ,a1.refund_time                    as refund_time
      ,a1.dispute_fee                    as dispute_fee
      ,a1.final_amount                   as final_amount
      ,a1.adjudication_amount            as final_balance_transactions_amount
      ,a1.final_dispute_fee              as final_dispute_fee
      ,a1.balance_transactions_amount    as balance_transactions_amount
      ,a1.is_status_succeed              as is_status_succeed
      ,a1.final_status                   as final_status
      ,a1.counter_fee                    as counter_fee
      ,now()                             as etl_time
  from dispute_paypal    as a1
 union all
select a1.id                             as dt
      ,a1.product_type                   as product_type
      ,a1.dispute_id                     as dispute_id
      ,a1.insert_time                    as insert_time
      ,a1.product_id                     as product_id
      ,a1.order_id                       as order_id
      ,a1.user_id                        as user_id
      ,a1.user_type                      as user_type
      ,a1.core                           as core
      ,a1.mt                             as mt
      ,a1.current_language2              as current_language2
      ,a1.shop_item_id                   as shop_item_id
      ,a1.country                        as country
      ,a1.source_chl_type                as source_chl_type
      ,a1.source_chl                     as source_chl
      ,a1.refund_time                    as refund_time
      ,a1.dispute_fee                    as dispute_fee
      ,a1.final_amount                   as final_amount
      ,a1.dispute_judged_amount          as final_balance_transactions_amount
      ,a1.final_dispute_fee              as final_dispute_fee
      ,a1.balance_transactions_amount    as balance_transactions_amount
      ,a1.is_status_succeed              as is_status_succeed
      ,a1.final_status                   as final_status
      ,a1.counter_fee                    as counter_fee
      ,now()                             as etl_time
  from ams    as a1
 union all
select a1.id                             as dt
      ,a1.product_type                   as product_type
      ,a1.dispute_id                     as dispute_id
      ,a1.insert_time                    as insert_time
      ,a1.product_id                     as product_id
      ,a1.order_id                       as order_id
      ,a1.user_id                        as user_id
      ,a1.user_type                      as user_type
      ,a1.core                           as core
      ,a1.mt                             as mt
      ,a1.current_language2              as current_language2
      ,a1.shop_item_id                   as shop_item_id
      ,a1.country                        as country
      ,a1.source_chl_type                as source_chl_type
      ,a1.source_chl                     as source_chl
      ,a1.refund_time                    as refund_time
      ,a1.dispute_fee                    as dispute_fee
      ,a1.final_amount                   as final_amount
      ,a1.final_settle_amount            as final_balance_transactions_amount
      ,a1.final_dispute_fee              as final_dispute_fee
      ,a1.balance_transactions_amount    as balance_transactions_amount
      ,a1.is_status_succeed              as is_status_succeed
      ,a1.final_status                   as final_status
      ,a1.counter_fee                    as counter_fee
      ,now()                             as etl_time
  from apple    as a1
 union all
select a1.id                             as dt
      ,a1.product_type                   as product_type
      ,a1.dispute_id                     as dispute_id
      ,a1.insert_time                    as insert_time
      ,a1.product_id                     as product_id
      ,a1.order_id                       as order_id
      ,a1.user_id                        as user_id
      ,a1.user_type                      as user_type
      ,a1.core                           as core
      ,a1.mt                             as mt
      ,a1.current_language2              as current_language2
      ,a1.shop_item_id                   as shop_item_id
      ,a1.country                        as country
      ,a1.source_chl_type                as source_chl_type
      ,a1.source_chl                     as source_chl
      ,a1.refund_time                    as refund_time
      ,a1.dispute_fee                    as dispute_fee
      ,a1.final_amount                   as final_amount
      ,a1.final_balance_transactions_amount as final_balance_transactions_amount
      ,a1.final_dispute_fee              as final_dispute_fee
      ,a1.balance_transactions_amount    as balance_transactions_amount
      ,a1.is_status_succeed              as is_status_succeed
      ,a1.final_status                   as final_status
      ,a1.counter_fee                    as counter_fee
      ,now()                             as etl_time
  from airwallex    as a1
;