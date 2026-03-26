----------------------------------------------------------------
-- 程序功能： 海阅阅读每日信息统计表
-- 程序名： P_ads_sr_beidou_books_daily_stat_di
-- 目标表： ads.ads_sr_beidou_books_daily_stat_di
-- 负责人： roger
-- 开发日期：2026-03-17
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sr_beidou_books_daily_stat_di
with
-- 书籍维度信息（按需求口径）
book_info as (
    select t1.book_id
         , t1.book_name
         , t1.book_code
         , regexp_replace(t1.book_code, '[0-9].*$', '')      as series_name
         , t1.build_time
         , t1.total_chapter_num
         , t1.font_length                                     as word_count
         , t1.free_chapternum                                 as free_chapter_num
         , t1.languageid                                      as language_cd
         , dic_lang.remarks                                   as language_name
         , case
               when substr(cast(t1.book_id as string), 1, 8) = '11100000' then 3
               when t2.storytype = 0 then 1
               when t2.storytype = 1 then 2
               else 0
           end                                                as content_type_cd
         , case
               when substr(cast(t1.book_id as string), 1, 8) = '11100000' then '解说漫'
               when t2.storytype = 0 then '长篇小说'
               when t2.storytype = 1 then '短篇小说'
               else '其他'
           end                                                as content_type_name
         , dic_booknature.enum_name                           as book_source
         , eb.cover_src                                       as cover_url
    from dim.dim_shuangwen_book_read_consume_info t1
    left join (select bookid as book_id
                    , storytype
               from ods.ods_book_novel_book_m
               group by bookid, storytype
              ) t2
      on t1.book_id = t2.book_id
    left join dim.dim_dic dic_lang
      on t1.languageid = dic_lang.enum_id
     and dic_lang.table_name = 'dim_producttype'
     and dic_lang.dic_column = 'language_id'
    left join dim.dim_dic dic_booknature
      on t1.book_nature = dic_booknature.enum_id
     and dic_booknature.table_name = 'dim_shuangwen_book_read_consume_info'
     and dic_booknature.dic_column = 'book_nature'
    left join (select (book_id * 1000) + site_id as book_id
                    , cover_src
               from dim.dim_edit_book_view
               where cover_src is not null
               group by 1, 2
              ) as eb
      on t1.book_id = eb.book_id
    where t1.is_put_down = 1
      and t1.build_time != '1970-01-01 00:00:00'
),
-- 主表：endReading 明细（西五区口径 + 分区 dt 过滤）
end_main as (
    select date(date_add(a.event_tm, interval -13 hour)) as dt
         , coalesce(cast(a.app_core_ver as int), 0)      as core
         , cast(a.book_id as bigint)                     as book_id
         , cast(a.chapter_id as bigint)                  as chapter_id
         , cast(a.login_id as bigint)                    as user_id
         , cast(a.read_chapter_sort as int)              as chapter_sort
         , coalesce(cast(a.reading_duration as bigint), 0) as reading_duration
    from ads.ads_sensors_production_endreadingchapter_view a
    left semi join dim.dim_shuangwen_book_read_consume_info eb_filter
      on cast(a.book_id as bigint) = eb_filter.book_id
    where a.dt >= '${bf_1_dt}'
      and a.dt <= '${af_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) >= '${bf_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) <= '${dt}'
      and cast(a.book_id as bigint) > 0
      and cast(a.chapter_id as bigint) > 0
      and cast(a.login_id as bigint) > 0
),
-- 主表聚合：阅读核心指标
end_stat as (
    select dt
         , core
         , book_id
         , count(1) as total_read_pv
         , bitmap_agg(user_id) as total_read_uv
         , sum(reading_duration) as total_read_duration
         , count(distinct concat(cast(chapter_id as string), '_', cast(user_id as string))) as total_read_chapter_num
    from end_main
    group by 1, 2, 3
),
-- 封面曝光点击指标（core 来自 corever）
item_exposure_stat as (
    select dt
         , core
         , book_id
         , sum(exposure_pv) as cover_exposure_pv
         , sum(click_pv) as cover_click_pv
    from (
             select date(date_add(ie.event_tm, interval -13 hour)) as dt
                  , coalesce(cast(ie.app_core_ver as int), 0) as core
                  , cast(ie.book_id as bigint) as book_id
                  , count(1) as exposure_pv
                  , 0 as click_pv
             from ads.ads_sensors_production_itemexposure_view ie
             where ie.dt >= '${bf_1_dt}'
               and ie.dt <= '${af_1_dt}'
               and date(date_add(ie.event_tm, interval -13 hour)) >= '${bf_1_dt}'
               and date(date_add(ie.event_tm, interval -13 hour)) <= '${dt}'
               and cast(ie.identity_login_id as bigint) > 0
               and cast(ie.book_id as bigint) > 0
               and ie.app_product_id is not null
             group by 1, 2, 3

             union all

             select date(date_add(ic.event_tm, interval -13 hour)) as dt
                  , coalesce(cast(ic.app_core_ver as int), 0) as core
                  , cast(ic.book_id as bigint) as book_id
                  , 0 as exposure_pv
                  , count(1) as click_pv
             from ads.ads_sensors_production_itemclick_view ic
             where ic.dt >= '${bf_1_dt}'
               and ic.dt <= '${af_1_dt}'
               and date(date_add(ic.event_tm, interval -13 hour)) >= '${bf_1_dt}'
               and date(date_add(ic.event_tm, interval -13 hour)) <= '${dt}'
               and cast(ic.identity_login_id as bigint) > 0
               and cast(ic.book_id as bigint) > 0
               and ic.app_product_id is not null
             group by 1, 2, 3
         ) it
    group by 1, 2, 3
),
-- 首章流失 / 付费相关指标（core 来自 corever）
first_read_stat as (
    select a.dt
         , a.core
         , a.book_id
         , bitmap_union(case when a.serial_number = 1 then a.read_unt end) as chapter1_read_uv
         , bitmap_union(case when a.serial_number = 2 then a.read_unt end) as chapter2_read_uv
         , bitmap_union(case when a.is_pay_amount = 0 and a.free_last_chapter = a.serial_number then a.d7_read_unt end) as before_paid_chapter_read_uv
         , bitmap_union(a.tot_csm_unt) as paid_chapter_unlock_uv
         , bitmap_union(a.d7_read_unt) as paid_chapter_read_uv
    from (
          select dt
               , coalesce(t.corever, 0)                                                     as core
               , lang_id                                                                    as lang_id_
               , book_id
               , serial_number                                                              as serial_number
               , if(max(chapter_length) > 0, 1, 0)                                          as is_pay_amount
               , max(if(serial_number > 20, 20, serial_number))
                     over (partition by lang_id,book_id,if(max(chapter_length) > 0, 1, 0) ) as free_last_chapter
               , bitmap_union(read_unt)                                                     as read_unt
               , bitmap_union(tot_csm_unt)                                                  as tot_csm_unt
               , bitmap_union(d7_read_unt)                                                  as d7_read_unt
          from ads.ads_bi_read_first_read_consume_est_ed t
          where t.dt >= '${bf_3_dt}'
            and t.dt <= '${dt}'
          group by 1, 2, 3, 4, 5
         ) a
    left join book_info b
      on a.book_id = b.book_id
    group by 1, 2, 3
),
-- 章节留存指标（与 chapter_stat 同源：endReading 用户最大阅读章）
chapter_retention_stat as (
    select dt
         , core
         , book_id
         , bitmap_agg(case when max_chapter_sort > 30 then user_id end) as chapter30_retention_uv
         , bitmap_agg(case when max_chapter_sort > 60 then user_id end) as chapter60_retention_uv
    from (
          select dt
               , core
               , book_id
               , user_id
               , max(chapter_sort) as max_chapter_sort
          from end_main
          where chapter_sort > 0
          group by 1, 2, 3, 4
         ) t
    group by 1, 2, 3
),
-- 次留分母：首读 cohort（core 取 corever）
cohort_d1 as (
    select a.dt
         , coalesce(a.corever, 0) as core
         , a.product_id
         , a.user_id
         , a.book_id
    from dws.dws_user_first_read_book_est_ed a
    where a.dt >= '${bf_3_dt}'
      and a.dt <= '${bf_1_dt}'
      and a.book_id > 0
      and a.user_id > 0
),
-- 次留行为：次日有阅读即留存（加 dt 分区过滤）
read_activity as (
    select distinct date(hours_add(a.create_time, -13)) as read_dt
         , a.product_id
         , a.user_id
         , a.book_id
    from dwd.dwd_read_user_chapter_view a
    where a.dt >= '${bf_4_dt}'
      and a.dt <= '${af_1_dt}'
      and date(hours_add(a.create_time, -13)) >= '${bf_3_dt}'
      and date(hours_add(a.create_time, -13)) <= '${dt}'
      and a.book_id > 0
      and a.user_id > 0
),
-- 次留指标：分子/分母
d1_retention_stat as (
    select c.dt
         , c.core
         , c.book_id
         , bitmap_agg(c.user_id) as d1_retention_first_read_uv
         , bitmap_agg(case when r.user_id is not null then c.user_id end) as d1_retention_uv
    from cohort_d1 c
    left join read_activity r
      on c.product_id = r.product_id
     and c.user_id = r.user_id
     and c.book_id = r.book_id
     and r.read_dt = date_add(c.dt, interval 1 day)
    group by 1, 2, 3
)
select e.dt
     , e.core
     , e.book_id
     , b.book_code
     , b.book_name
     , b.language_cd
     , b.language_name
     , b.content_type_cd
     , b.content_type_name
     , b.series_name
     , b.build_time
     , b.cover_url
     , b.total_chapter_num
     , b.word_count
     , b.free_chapter_num
     , b.book_source
     , e.total_read_pv
     , e.total_read_uv
     , ie.cover_click_pv
     , ie.cover_exposure_pv
     , fr.chapter1_read_uv
     , bitmap_andnot(fr.chapter1_read_uv, fr.chapter2_read_uv) as chapter1_loss_uv
     , e.total_read_duration
     , e.total_read_chapter_num
     , fr.before_paid_chapter_read_uv
     , fr.paid_chapter_unlock_uv
     , fr.paid_chapter_read_uv
     , cr.chapter30_retention_uv
     , cr.chapter60_retention_uv
     , d1.d1_retention_uv
     , d1.d1_retention_first_read_uv
     , now() as etl_time
from end_stat e
left join book_info b
  on e.book_id = b.book_id
left join item_exposure_stat ie
  on e.dt = ie.dt
 and e.core = ie.core
 and e.book_id = ie.book_id
left join first_read_stat fr
  on e.dt = fr.dt
 and e.core = fr.core
 and e.book_id = fr.book_id
left join chapter_retention_stat cr
  on e.dt = cr.dt
 and e.core = cr.core
 and e.book_id = cr.book_id
left join d1_retention_stat d1
  on e.dt = d1.dt
 and e.core = d1.core
 and e.book_id = d1.book_id
;
