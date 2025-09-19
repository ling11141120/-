----------------------------------------------------------------
-- 程序功能： 订单争议结果表数据
-- 程序名： P_ads_srsv_dispute_payorder_result
-- 目标表： ads.ads_srsv_dispute_payorder_result
-- 负责人： wx
-- 开发日期： 2025-09-19
-- 版本号： v0.0.0
----------------------------------------------------------------
insert into ads.ads_srsv_dispute_payorder_result
with dispute_stripe as (
    select a.id
          ,'Stripe'                                                                     as product_type
          ,a.dispute_i
          ,a.insert_tim
          ,b.product_id                                                                 as product_id
          ,b.order_i
          ,b.user_i
          ,t1.user_typ
          ,b.cor
          ,dic_mt.enum_name                                                             as mt
          ,coalesce(dic_lang.remarks,'其他')                                            as current_language2
          ,b.shop_item_id
          ,t4.country
          ,case when t5.source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
                when t5.source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
                when t5.source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
                when t5.source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
                else '其他'
            end                                                                         as source_chl_type
          ,t5.source_chl
          ,if(a.update_time>='2025-06-24' and a.final_status=3,a.update_time,null)      as refund_time
          ,a.final_settle_amount                                                        as final_amount
          ,a.balance_transactions_amount                                                as balance_transactions_amount
          ,if(a.final_status=3,1,0) is_status_succeed
          ,a.final_statuss
      from ods.ods_cdmoney_report_tidb_cn_dispute_stripe                                as a
      left join ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe                     as b
        on a.dispute_id=b.dispute_id
      left join (select s1.product_id
                       ,s1.user_id
                       ,s1.user_type
                   from (select a.product_id
                               ,a.user_id
                               ,a.user_type
                               ,row_number() over (partition by a.product_id,a.user_id order by a.dt desc)    as rn
                           from (select dt
                                       ,product_id
                                       ,user_id
                                       ,user_type
                                  from dws.dws_user_short_video_wide_active_period_ed
                                 where period_type='ctt'
                                 group by 1,2,3,4
                                 union all
                                select dt
                                      ,product_id
                                      ,user_id
                                      ,user_type
                                  from dws.dws_user_wide_active_period_ed
                                 where period_type='ctt'
                                 group by 1,2,3,4
                                )                                                                             as a
                           join (select product_id
                                      ,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                 group by 1,2
                                 union all
                                select product_id
                                      ,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                 group by 1,2
                                )                                                                             as b
                             on a.product_id=b.product_id
                            and a.user_id=b.user_id
                        )                                                                                     as s1
                  where s1.rn = 1
                )                                                                                             as t1
        on t1.user_id=b.user_id
       and t1.product_id=ifnull(b.product_id,left(b.pay_channel_id,4))
      left join dim.dim_dic dic_mt  -- mt
        on b.os_type = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
      left join (select product_id
                       ,id                                                                                                                                as user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_user_account_info_view 
                  group by 1,2,3,4
                  union all
                 select product_id
                       ,user_id
                       ,reg_country
                       ,current_language2
                   from dim.dim_short_video_user_accountinfo
                  group by 1,2,3,4
                )                                                                                                                                         as t3
        on t1.user_id = t3.user_id
       and t1.product_id=t3.product_id
      left join dim.dim_country_dic t4
        on t3.reg_country = t4.code
      left join dim.dim_dic dic_lang  -- 注册/投放语言
        on t3.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join (select s1.product_id
                      ,s1.user_id
                      ,s1.last_source                                                                                                                     as source_chl
                    from (select a.product_id
                              ,a.user_id
                              ,a.last_source
                              ,row_number() over (partition by a.product_id,a.user_id order by a.install_date desc,a.mt asc,a.corever asc,a.lang2 asc)    as rn
                          from dws.dws_user_market_channel_info_detail_td                                                                                 as a
                          join (select product_id
                                      ,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                 group by 1,2
                                 union all
                                select product_id
                                      ,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                 group by 1,2
                                )                                                                                                                         as b
                            on a.product_id=b.product_i
                           and a.user_id=b.user_i
                         )                                                                                                                                as s1
                   where s1.rn = 1
                )                                                                                                                                         as t5
        on ifnull(b.product_id,left(b.pay_channel_id,4))=t5.product_id
       and b.user_id=t5.user_id
                       )
,dispute_paypal as (
    select a.id
          ,'PayPalV2'                                                                     as product_type
          ,a.dispute_id
          ,a.insert_time
          ,b.product_id                                                                   as product_id
          ,b.order_id
          ,b.user_id
          ,t1.user_type
          ,b.core
          ,dic_mt.enum_name                                                               as mt
          ,coalesce(dic_lang.remarks,'其他')                                              as current_language2
          ,b.shop_item_id
          ,t4.country
          ,case when t5.source_chl in ('fbgroup','fbpage','fbpost','social') then '社媒'
                when t5.source_chl in ('unattributed','google-play','organic','(not set)','none') then '自然量'
                when t5.source_chl in ('exlink','officialsite','pinterest','podcasts','rss','webshare','seoyt') then 'SEO媒体'
                when t5.source_chl in ('facebook','fbs2s','tt','adwords','mediago','appleadservice','sem','mapit','tiktok app','applovin','kwai') then '广告媒体'
                else '其他'
            end                                                                           as source_chl_type
          ,t5.source_chl
          ,if(a.update_time>='2025-06-24' and a.final_status in (5,7),a.update_time,null) as refund_time
          ,a.final_amount                                                                 as final_amount
          ,a.dispute_amount                                                               as balance_transactions_amount
          ,if(a.final_status in (6),1,0)                                                  as is_status_succeed
          ,a.final_status
      from ods.ods_cdmoney_report_tidb_cn_dispute_paypal                                  as a
      left join ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal                       as b
        on a.dispute_id=b.dispute_id
      left join (select s1.product_id
                       ,s1.user_id,
                       ,s1.user_type
                   from (select a.product_id
                               ,a.user_id
                               ,a.user_type
                               ,row_number() over (partition by a.product_id,a.user_id order by a.dt desc)    as rn
                          from (select dt
                                      ,product_id
                                      ,user_id
                                      ,user_type
                                  from dws.dws_user_short_video_wide_active_period_ed
                                 where period_type='ctt'
                                 group by 1,2,3,4
                                 union all
                                select dt
                                      ,product_id
                                      ,user_id
                                      ,user_type
                                  from dws.dws_user_wide_active_period_ed
                                 where period_type='ctt'
                                 group by 1,2,3,4
                                )                                                                             as a
                          join (select product_id
                                      ,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                 group by 1,2
                                 union all
                                select product_id,user_id
                                  from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                 group by 1,2
                                )                                                                             as b
                            on a.product_id=b.product_id
                           and a.user_id=b.user_id
                        )                                                                                     as s1
                  where s1.rn = 1
                )                                                                                             as t1
        on t1.user_id=b.user_id
       and t1.product_id=ifnull(b.product_id,left(b.pay_channel_id,4))
      left join dim.dim_dic  dic_mt  -- mt
        on b.os_type = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
      left join (select product_id
                       ,id as user_id
                       ,reg_country
                       ,current_language2
                  from dim.dim_user_account_info_view
                 group by 1,2,3,4
                 union all
                select product_id
                      ,user_id
                      ,reg_country
                      ,current_language2
                  from dim.dim_short_video_user_accountinfo
                 group by 1,2,3,4 )                                                                                                                        as t3
        on t1.user_id = t3.user_id
       and t1.product_id=t3.product_id
      left join dim.dim_country_dic t4
        on t3.reg_country = t4.code
      left join dim.dim_dic dic_lang  -- 注册/投放语言
        on t3.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join (select s1.product_id
                       ,s1.user_id
                       ,s1.last_source as source_chl
                   from (select a.product_id
                               ,a.user_id
                               ,a.last_source
                               ,row_number() over (partition by a.product_id,a.user_id order by a.install_date desc,a.mt asc,a.corever asc,a.lang2 asc)    as rn
                         from dws.dws_user_market_channel_info_detail_td                                                                                   as a
                         join (select product_id
                                  ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe
                                  group by 1,2
                                  union all
                                 select product_id
                                       ,user_id
                                   from ods.ods_cdmoney_report_tidb_cn_dispute_order_paypal
                                  group by 1,2
                               )                                                                                                                           as b
                           on a.product_id=b.product_id
                          and a.user_id=b.user_id
                        )                                                                                                                                  as s1
                  where s1.rn = 1
                )                                                                                                                                          as t5
        on ifnull(b.product_id,left(b.pay_channel_id,4))=t5.product_id
       and b.user_id=t5.user_id
)
select
      id
      ,product_type
      ,dispute_id
      ,insert_time
      ,product_id
      ,order_id
      ,user_id
      ,user_type
      ,core
      ,mt
      ,current_language2
      ,shop_item_id
      ,country
      ,source_chl_type
      ,source_chl
      ,refund_time
      ,final_amount
      ,balance_transactions_amount
      ,is_status_succeed
      ,final_status
      ,now()                  as etl_time
  from dispute_stripe
 union all
select
      id
      ,product_type
      ,dispute_id
      ,insert_time
      ,product_id
      ,order_id
      ,user_id
      ,user_type
      ,core
      ,mt
      ,current_language2
      ,shop_item_id
      ,country
      ,source_chl_type
      ,source_chl
      ,refund_time
      ,final_amount
      ,balance_transactions_amount
      ,is_status_succeed
      ,final_status
      ,now()                  as etl_time
  from dispute_paypal
;