----------------------------------------------------------------
-- 程序功能： 海阅海剧koc用户数据报表
-- 程序名： P_ads_srsv_bi_koc_attribution_result_data
-- 目标表： ads.ads_srsv_bi_koc_attribution_result_data
-- 负责人： qhr
-- 开发日期： 2026-02-10
----------------------------------------------------------------

insert into tmp.ads_srsv_bi_koc_attribution_result_data
with attribution_user as (
    select a.product_id
         , a.dt
         , a.ad_id
         , a.user_id
         , if(minutes_diff(d.create_time, b.create_time) < 1440, 1, 0) as is_new_user
         , ifnull(b.reg_country, -99)                                  as reg_country
         , a.begin_time
         , a.end_time
         , a.resource_id
         , a.create_time
         , a.koc_text
         , c.InstitutionId                                             as institution_id
         , c.StarId                                                    as star_id
         , e.distributor
      from (select product_id
                 , user_id
                 , date(begin_time) as dt
                 , ad_id
                 , begin_time
                 , end_time
                 , resource_id
                 , koc_text
                 , min(create_time) as create_time
              from dwd.dwd_srsv_advertisement_koc_attribution_record_view
             where begin_time >= '${bf_30_dt}'
               and begin_time <= '${dt}'
             group by 1, 2, 3, 4, 5, 6, 7, 8
           )                              as a
      left join (select product_id     as product_id
                      , id             as user_id
                      , create_time    as create_time
                      , reg_country    as reg_country
                   from dim.dim_user_account_info_view
                  union all
                 select product_id     as product_id
                      , user_id        as user_id
                      , create_time    as create_time
                      , reg_country    as reg_country
                   from dim.dim_short_video_user_accountinfo
                )                         as b
        on a.product_id = b.product_id
       and a.user_id = b.user_id
      left join ods.ods_tidb_koc_codeinfo as c
        on a.koc_text = c.KocCode
      left join (select product_id
                      , user_id
                      , ad_id
                      , date(begin_time) as dt
                      , min(create_time) as create_time
                   from dwd.dwd_srsv_advertisement_koc_attribution_record_view
                  where begin_time >= '${bf_30_dt}'
                    and begin_time <= '${dt}'
                  group by 1, 2, 3, 4
                )                         as d
        on a.dt = d.dt
       and a.product_id = d.product_id
       and a.user_id = d.user_id
       and a.ad_id = d.ad_id
      left join (select a.id as star_id
                      , concat(b.code, '(', a.StarName, ')') as distributor
                   from ods.ods_tidb_koc_starinfo            as a
                   left join dim.dim_koc_invitationcode_view as b
                     on a.Id = b.star_id
                )                         as e
        on c.StarId = e.star_id
)
, active_user as (
    select product_id
         , dt
         , ad_id
         , is_new_user
         , reg_country
         , count(distinct user_id) as dev_unt
      from attribution_user
     group by 1, 2, 3, 4, 5
)
, koc_user_chapter as (
    select b.dt
         , a.product_id
         , a.ad_id
         , a.user_id
         , a.is_new_user
         , a.reg_country
         , b.book_id
         , b.chapter_id
         , b.chapter_num
         , b.create_time
         , chapter_sign
      from attribution_user as a
      left join (select dt
                      , product_id
                      , book_id
                      , chapter_id
                      , null           as chapter_num
                      , user_id
                      , create_time
                      , chapter_id     as chapter_sign
                   from dwd.dwd_read_user_chapter_view
                  where dt >= '${bf_20_dt}'
                    and dt <= '${dt}'
                  union all
                 select dt             as dt
                      , 6833           as product_id
                      , series_id      as book_id
                      , epis_id        as chapter_id
                      , epis_num       as chapter_num
                      , account_id     as user_id
                      , create_time    as create_time
                      , epis_num       as chapter_sign
                   from ods.ods_tidb_short_video_log_ext_epis_watch_log_part2
                  where dt >= '${bf_20_dt}'
                    and dt <= '${dt}'
                 )          as b
        on a.begin_time <= b.create_time
       and a.end_time > b.create_time
       and a.product_id = b.product_id
       and a.user_id = b.user_id
     where b.user_id is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
, consume_chapter as (
    select dt
         , product_id
         , ad_id
         , a.is_new_user
         , a.reg_country
         , count(1) as first_consume_user_num
      from (select a.product_id
                 , a.ad_id
                 , a.user_id
                 , a.is_new_user
                 , a.reg_country
                 , max(dt) as dt
              from (select a.dt
                         , a.ad_id
                         , a.product_id
                         , a.is_new_user
                         , a.reg_country
                         , a.book_id
                         , a.chapter_id
                         , a.user_id
                         , if(b.serial_number > c.Free_ChapterNum, 0, 1) as is_free
                      from (select a.dt
                                 , a.ad_id
                                 , a.product_id
                                 , a.is_new_user
                                 , a.reg_country
                                 , a.book_id
                                 , a.chapter_id
                                 , a.user_id
                              from koc_user_chapter a
                             where product_id <> 6833
                             group by 1, 2, 3, 4, 5, 6, 7, 8
                           )                                             as a
                      left join ods.ods_edit_shuangwen_chapter           as b
                        on a.product_id = b.Productid
                       and a.book_id = concat(b.book_id, site_id)
                       and a.chapter_id = b.chapter_id
                      left join dim.dim_shuangwen_book_read_consume_info as c
                        on a.product_id = c.product_id
                       and a.book_id = c.book_id
                     union all
                    select a.dt          as dt
                         , a.ad_id       as ad_id
                         , a.product_id  as product_id
                         , a.is_new_user as is_new_user
                         , a.reg_country as reg_country
                         , a.book_id     as book_id
                         , a.chapter_id  as chapter_id
                         , a.user_id     as user_id
                         , b.is_free     as is_free
                      from (select a.dt
                                 , a.ad_id
                                 , a.product_id
                                 , a.is_new_user
                                 , a.reg_country
                                 , a.book_id
                                 , a.chapter_id
                                 , a.user_id
                              from koc_user_chapter a
                             where product_id = 6833
                             group by 1, 2, 3, 4, 5, 6, 7, 8
                           )                            as a
                      left join dim.dim_sv_epis_di_view as b
                      on a.book_id = b.series_id
                          and a.chapter_id = b.epis_id
                          and b.is_delete = 0
                   ) a
             where is_free = 0
             group by 1, 2, 3, 4, 5
           ) a
     group by 1, 2, 3, 4, 5
)
, chapter_watch as (
    select a.dt
         , a.product_id
         , a.ad_id
         , a.is_new_user
         , a.reg_country
         , bitmap_union(to_bitmap(concat(a.user_id, a.book_id, a.user_watch_chapter))) as user_watch_chapter
         , bitmap_union(to_bitmap(a.user_id))                                          as watch_user_id
      from (select a.product_id
                 , a.dt
                 , a.ad_id
                 , a.user_id
                 , a.is_new_user
                 , a.reg_country
                 , a.book_id
                 , a.chapter_sign as user_watch_chapter
              from koc_user_chapter a
             group by 1, 2, 3, 4, 5, 6, 7, 8
           ) a
     group by 1, 2, 3, 4, 5
)
, attribution_data as (
    select b.datestr                                                                      as dt
         , a.product_id
         , a.user_id
         , a.resource_id
         , a.begin_time
         , a.end_time
         , a.ad_id
         , cast(substring_index(substring_index(a.ad_id, 'Mt=', -1), '|', 1) as int)      as mt
         , cast(substring_index(substring_index(a.ad_id, 'Chl2=', -1), '|', 1) as string) as chl
         , IFNULL(c.languageid
                 ,cast(substring_index(substring_index(a.ad_id, 'CurrentLanguage2=', -1), '|',1) as int)
                 )                                                                        as current_language
         , cast(substring_index(substring_index(a.ad_id, 'Core=', -1), '|', 1) as int)    as core
         , a.koc_text
         , a.institution_id
         , a.star_id
         , a.distributor
         , date(a.create_time)                                                            as user_dt
         , a.is_new_user
         , a.reg_country
      from attribution_user     as a
      left join dim.dim_date    as b
        on b.datestr >= '${bf_20_dt}'
       and b.datestr <= '${dt}'
      left join (select 6833          as product_id
                      , series_id     as book_id
                      , language      as languageid
                   from dim.dim_short_video_series_view
                  union all
                 select product_id    as product_id
                      , book_id       as book_id
                      , languageid    as languageid
                   from dim.dim_shuangwen_book_read_consume_info
                )               as c
        on a.product_id = c.product_id
       and a.resource_id = c.book_id
     where a.dt >= '${bf_20_dt}'
       and a.dt <= '${dt}'
)
, payorder_data as (
    select dt
         , ProductId                 as product_id
         , UserId                    as user_id
         , cast(substring_index(
                    substring_index(
                            substring_index(
                                    substring_index(
                                            substring_index(packageid, '|', 1), 'Ps_Half_', -1
                                    ), 'Ps_Shop_half_', -1
                            ), '_', 1
                    ), '_', -1
               ) as int)             as book_id
         , CreateTime                as create_time
         , OrderId                   as order_id
         , sum(ItemCount)            as item_count
         , sum(BaseAmount) / 100     as base_amount
      from dwd.dwd_sr_user_koc_payorder_view
     where dt >= '${bf_30_dt}'
       and dt <= '${dt}'
     group by 1, 2, 3, 4, 5, 6
     union all
    select dt                        as dt
         , product_id                as product_id
         , user_id                   as user_id
         , cast(substring_index(
                    substring_index(
                            substring_index(package_id, 'Ps_Half_', -1), '_', 1
                    ), '_', -1
                ) as int)            as book_id
         , create_time               as create_time
         , order_id                  as order_id
         , sum(item_count)           as item_count
         , sum(base_amount) / 100    as base_amount
      from dwd.dwd_trade_short_video_payorder_view
     where dt >= '${bf_30_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and test_flag = 0
       and status = 0
     group by 1, 2, 3, 4, 5, 6
)
, koc_order as (
    select a.dt
         , a.product_id
         , a.ad_id
         , a.is_new_user
         , a.reg_country
         , a.resource_id
         , a.user_id
         , a.mt
         , a.core
         , a.chl
         , a.current_language
         , a.koc_text
         , case when a.product_id = 6833  and a.core = 1 then 'MoboReels'
                when a.product_id = 6833  and a.core = 2 then 'MoboShort'
                when a.product_id <> 6833 and a.core = 1 then 'MoboReader'
                when a.product_id <> 6833 and a.core = 2 then 'ReadNow'
           end                                        as product
         , a.institution_id
         , a.star_id
         , a.distributor
         , a.user_dt
         , b.item_count
         , if(a.is_new_user = 1, b.item_count, 0)     as new_koc_amt
         , if(a.is_new_user = 0, b.item_count, 0)     as active_koc_amt
         , b.base_amount
         , if(a.is_new_user = 1, b.base_amount, 0)    as new_koc_amt_after
         , if(a.is_new_user = 0, b.base_amount, 0)    as active_koc_amt_after
         , b.order_id
      from attribution_data      as a
      left join payorder_data    as b
        on a.dt = b.dt
       and b.dt >= '${bf_20_dt}'
       and b.dt <= '${dt}'
       and if(a.product_id = 6833, 2, 1) = if(b.product_id = 6833, 2, 1)
       and a.user_id = b.user_id
       and b.create_time >= a.begin_time
       and b.create_time < a.end_time
     where b.dt is not null
)
, ltv_data as (
    select dt
         , product_id
         , ad_id
         , is_new_user
         , reg_country
         , sum(case when ltv.diff_dt_num = 0 then ltv.pay_amt else 0 end) as ltv0_amt
         , case when sum(case when ltv.diff_dt_num = 1 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 1 then ltv.pay_amt else 0 end)
           end                                                            as ltv1_amt
         , case when sum(case when ltv.diff_dt_num = 2 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 2 then ltv.pay_amt else 0 end)
           end                                                            as ltv2_amt
         , case when sum(case when ltv.diff_dt_num = 3 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 3 then ltv.pay_amt else 0 end)
           end                                                            as ltv3_amt
         , case when sum(case when ltv.diff_dt_num = 4 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 4 then ltv.pay_amt else 0 end)
           end                                                            as ltv4_amt
         , case when sum(case when ltv.diff_dt_num = 5 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 5 then ltv.pay_amt else 0 end)
           end                                                            as ltv5_amt
         , case when sum(case when ltv.diff_dt_num = 6 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 6 then ltv.pay_amt else 0 end)
           end                                                            as ltv6_amt
         , case when sum(case when ltv.diff_dt_num = 7 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 7 then ltv.pay_amt else 0 end)
           end                                                            as ltv7_amt
         , case when sum(case when ltv.diff_dt_num = 8 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 8 then ltv.pay_amt else 0 end)
           end                                                            as ltv8_amt
         , case when sum(case when ltv.diff_dt_num = 9 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 9 then ltv.pay_amt else 0 end)
           end                                                            as ltv9_amt
         , case when sum(case when ltv.diff_dt_num = 10 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 10 then ltv.pay_amt else 0 end)
           end                                                            as ltv10_amt
         , case when sum(case when ltv.diff_dt_num = 11 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 11 then ltv.pay_amt else 0 end)
           end                                                            as ltv11_amt
         , case when sum(case when ltv.diff_dt_num = 12 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 12 then ltv.pay_amt else 0 end)
           end                                                            as ltv12_amt
         , case when sum(case when ltv.diff_dt_num = 13 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 13 then ltv.pay_amt else 0 end)
           end                                                            as ltv13_amt
         , case when sum(case when ltv.diff_dt_num = 14 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 14 then ltv.pay_amt else 0 end)
           end                                                            as ltv14_amt
         , case when sum(case when ltv.diff_dt_num = 15 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 15 then ltv.pay_amt else 0 end)
           end                                                            as ltv15_amt
         , case when sum(case when ltv.diff_dt_num = 16 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 16 then ltv.pay_amt else 0 end)
           end                                                            as ltv16_amt
         , case when sum(case when ltv.diff_dt_num = 17 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 17 then ltv.pay_amt else 0 end)
           end                                                            as ltv17_amt
         , case when sum(case when ltv.diff_dt_num = 18 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 18 then ltv.pay_amt else 0 end)
           end                                                            as ltv18_amt
         , case when sum(case when ltv.diff_dt_num = 19 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 19 then ltv.pay_amt else 0 end)
           end                                                            as ltv19_amt
         , case when sum(case when ltv.diff_dt_num = 20 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 20 then ltv.pay_amt else 0 end)
           end                                                            as ltv20_amt
         , case when sum(case when ltv.diff_dt_num = 21 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 21 then ltv.pay_amt else 0 end)
           end                                                            as ltv21_amt
         , case when sum(case when ltv.diff_dt_num = 22 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 22 then ltv.pay_amt else 0 end)
           end                                                            as ltv22_amt
         , case when sum(case when ltv.diff_dt_num = 23 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 23 then ltv.pay_amt else 0 end)
           end                                                            as ltv23_amt
         , case when sum(case when ltv.diff_dt_num = 24 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 24 then ltv.pay_amt else 0 end)
           end                                                            as ltv24_amt
         , case when sum(case when ltv.diff_dt_num = 25 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 25 then ltv.pay_amt else 0 end)
           end                                                            as ltv25_amt
         , case when sum(case when ltv.diff_dt_num = 26 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 26 then ltv.pay_amt else 0 end)
           end                                                            as ltv26_amt
         , case when sum(case when ltv.diff_dt_num = 27 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 27 then ltv.pay_amt else 0 end)
           end                                                            as ltv27_amt
         , case when sum(case when ltv.diff_dt_num = 28 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 28 then ltv.pay_amt else 0 end)
           end                                                            as ltv28_amt
         , case when sum(case when ltv.diff_dt_num = 29 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 29 then ltv.pay_amt else 0 end)
           end                                                            as ltv29_amt
         , case when sum(case when ltv.diff_dt_num = 30 then ltv.pay_amt else 0 end) is null then null
                else sum(case when ltv.diff_dt_num <= 30 then ltv.pay_amt else 0 end)
           end                                                            as ltv30_amt
      from (select uinfo.dt
                 , uinfo.product_id
                 , uinfo.ad_id
                 , uinfo.is_new_user
                 , uinfo.reg_country
                 , uinfo.user_id
                 , datediff(pay.dt, uinfo.dt)     as diff_dt_num
                 , coalesce(pay.item_count, 0)    as pay_amt
              from attribution_user      as uinfo
              left join payorder_data    as pay
                on pay.dt between '${bf_30_dt}' and '${dt}'
               and pay.dt between uinfo.dt and date_add(uinfo.dt, interval 30 day)
               and uinfo.user_id = pay.user_id
           ) ltv
     group by 1, 2, 3, 4, 5
)
, first_order as (
    select dt
         , product_id
         , ad_id
         , is_new_user
         , reg_country
         , count(user_id) as pay_user_num
      from (select product_id
                 , ad_id
                 , user_id
                 , is_new_user
                 , reg_country
                 , min(dt) as dt
              from koc_order
             where item_count > 0
             group by 1, 2, 3, 4, 5
            ) a
     group by 1, 2, 3, 4, 5
)
select a.dt
     , a.product_id
     , a.ad_id
     , a.is_new_user
     , a.reg_country
     , a.project_tp
     , a.book_id
     , a.mt
     , a.core
     , a.source_chl
     , a.chl
     , a.current_language
     , a.koc_code
     , a.business_mode
     , a.product
     , a.institution_id
     , a.star_id
     , a.distributor
     , case when f.country_type in (1, 2) then country_type
            when f.country_type = 0 and f.ip_country not in ('LAN', 'CN') and f.ip_country is not null then 2
            else 1
       end                  as country_type
     , b.dev_unt
     , d.user_watch_chapter as watch_chapters
     , d.watch_user_id
     , c.first_consume_user_num
     , e.pay_user_num
     , a.order_num
     , a.koc_amt
     , a.koc_amt_after
     , case when g.cooperation_type <= 0 or g.app_type is null then 0
            when g.cooperation_type = 1 and g.transaction_fee_type = 3  then a.koc_amt_after * (1 - g.cost_factor / 100) * g.split_ratio / 100
            when g.cooperation_type = 1 and g.transaction_fee_type <> 3 then a.koc_amt * (1 - g.transaction_fee / 100) * (1 - g.cost_factor / 100) * g.split_ratio / 100
        end                 as real_income
     , case when g.leader_id <= 0 or g.institution_status <= 0 or a.star_id <= 0 or g.star_status <= 0 or g.cooperation_type <= 0 or g.app_type is null then 0
            when g.cooperation_type = 1 and g.transaction_fee_type = 3 then a.koc_amt_after * (1 - g.cost_factor / 100) * g.distribute_ratio / 100
            when g.cooperation_type = 1 and g.transaction_fee_type <> 3 then a.koc_amt * (1 - g.transaction_fee / 100) * (1 - g.cost_factor / 100) * g.distribute_ratio / 100
        end                 as real_distrib_income
     , now()                as etl_tm
     ,ltv.ltv0_amt          as ltv0
     ,ltv.ltv1_amt          as ltv1
     ,ltv.ltv2_amt          as ltv2
     ,ltv.ltv3_amt          as ltv3
     ,ltv.ltv4_amt          as ltv4
     ,ltv.ltv5_amt          as ltv5
     ,ltv.ltv6_amt          as ltv6
     ,ltv.ltv7_amt          as ltv7
     ,ltv.ltv8_amt          as ltv8
     ,ltv.ltv9_amt          as ltv9
     ,ltv.ltv10_amt         as ltv10
     ,ltv.ltv11_amt         as ltv11
     ,ltv.ltv12_amt         as ltv12
     ,ltv.ltv13_amt         as ltv13
     ,ltv.ltv14_amt         as ltv14
     ,ltv.ltv15_amt         as ltv15
     ,ltv.ltv16_amt         as ltv16
     ,ltv.ltv17_amt         as ltv17
     ,ltv.ltv18_amt         as ltv18
     ,ltv.ltv19_amt         as ltv19
     ,ltv.ltv20_amt         as ltv20
     ,ltv.ltv21_amt         as ltv21
     ,ltv.ltv22_amt         as ltv22
     ,ltv.ltv23_amt         as ltv23
     ,ltv.ltv24_amt         as ltv24
     ,ltv.ltv25_amt         as ltv25
     ,ltv.ltv26_amt         as ltv26
     ,ltv.ltv27_amt         as ltv27
     ,ltv.ltv28_amt         as ltv28
     ,ltv.ltv29_amt         as ltv29
     ,ltv.ltv30_amt         as ltv30
  from (select a.dt
             , a.product_id
             , a.ad_id
             , a.is_new_user
             , a.reg_country
             , if(max(a.product_id) = 6833, 2, 1)           as project_tp -- 1:海阅 2：海剧
             , max(a.resource_id)                           as book_id
             , max(a.mt)                                    as mt
             , max(a.core)                                  as core
             , 'koc'                                        as source_chl
             , max(a.chl)                                   as chl
             , max(a.current_language)                      as current_language
             , max(a.koc_text)                              as koc_code
             , if(max(a.institution_id) = 48, 'ToC', 'ToB') as business_mode
             , max(a.product)                               as product
             , max(a.institution_id)                        as institution_id
             , max(a.star_id)                               as star_id
             , max(a.distributor)                           as distributor
             , count(order_id)                              as order_num
             , sum(item_count)                              as koc_amt
             , sum(base_amount)                             as koc_amt_after
          from koc_order    as a
         where a.dt >= '${bf_3_dt}'
           and a.dt <= '${dt}'
           and a.core = 1
         group by 1, 2, 3, 4, 5
       )                    as a
  left join active_user     as b
    on a.dt = b.dt
   and a.product_id = b.product_id
   and a.ad_id = b.ad_id
   and a.is_new_user = b.is_new_user
   and a.reg_country = b.reg_country
  left join consume_chapter as c
    on a.dt = c.dt
   and a.product_id = c.product_id
   and a.ad_id = c.ad_id
   and a.is_new_user = c.is_new_user
   and a.reg_country = c.reg_country
  left join chapter_watch   as d
    on a.dt = d.dt
   and a.product_id = d.product_id
   and a.ad_id = d.ad_id
   and a.is_new_user = d.is_new_user
   and a.reg_country = d.reg_country
  left join first_order     as e
    on a.dt = e.dt
   and a.product_id = e.product_id
   and a.ad_id = e.ad_id
   and a.is_new_user = e.is_new_user
   and a.reg_country = e.reg_country
  left join (select b.id
                  , a.country_type
                  , ip_country
               from dim.dim_koc_b_userinfo_tb_view as a
               left join dim.dim_koc_starinfo_view as b
                 on a.user_id = b.UserId
            )              as f
    on a.star_id = f.id
  left join (select date_key as dt
                  , product_id
                  , ad_id
                  , cooperation_type
                  , split_ratio
                  , transaction_fee_type
                  , transaction_fee
                  , cost_factor_type
                  , cost_factor
                  , leader_id
                  , distribute_type
                  , distribute_ratio
                  , app_type
                  , institution_id
                  , institution_status
                  , star_id
                  , star_status
               from dwd.dwd_koc_adltvitem
              group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
            )              as g
    on a.dt = g.dt
   and a.product_id = g.product_id
   and a.ad_id = g.ad_id
  left join ltv_data       as ltv
    on a.dt = ltv.dt
   and a.product_id = ltv.product_id
   and a.ad_id = ltv.ad_id
   and a.is_new_user = ltv.is_new_user
   and a.reg_country = ltv.reg_country
 where (    b.dev_unt > 0
         or bitmap_count(d.user_watch_chapter) > 0
         or bitmap_count(d.watch_user_id) > 0
         or c.first_consume_user_num > 0
         or e.pay_user_num > 0
         or a.koc_amt > 0
       )
;