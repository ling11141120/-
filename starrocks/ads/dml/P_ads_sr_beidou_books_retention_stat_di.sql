----------------------------------------------------------------
-- 程序功能： 海阅阅读1到7天留存统计表
-- 程序名： P_ads_sr_beidou_books_retention_stat_di
-- 目标表： ads.ads_sr_beidou_books_retention_stat_di
-- 负责人： roger
-- 开发日期：2026-03-17
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sr_beidou_books_retention_stat_di
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

),
-- 主表：endReading 键集（西五区口径 + 分区 dt 过滤）
end_main_key as (
    select date(date_add(a.event_tm, interval -13 hour)) as dt
         , coalesce(cast(a.app_core_ver as int), 0)      as core
         , cast(a.book_id as bigint)                     as book_id
    from ads.ads_sensors_production_endreadingchapter_view a
    left semi join dim.dim_shuangwen_book_read_consume_info eb_filter
      on cast(a.book_id as bigint) = eb_filter.book_id
    where a.dt >= '${bf_8_dt}'
      and a.dt <= '${af_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) >= '${bf_7_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) <= '${dt}'
      and cast(a.book_id as bigint) > 0
      and cast(a.login_id as bigint) > 0
    group by 1, 2, 3
),
-- 留存天数枚举（1-7天）
retention_day as (
    select 1 as retention_day
    union all select 2
    union all select 3
    union all select 4
    union all select 5
    union all select 6
    union all select 7
),
-- 首读 cohort（core 取 corever）
cohort as (
    select a.dt
         , coalesce(a.corever, 0) as core
         , a.product_id
         , a.user_id
         , a.book_id
    from dws.dws_user_first_read_book_est_ed a
    where a.dt >= '${bf_7_dt}'
      and a.dt <= '${bf_1_dt}'
      and a.book_id > 0
      and a.user_id > 0
),
-- 阅读行为（加分区 dt 过滤）
read_activity as (
    select distinct date(hours_add(a.create_time, -13)) as read_dt
         , a.product_id
         , a.user_id
         , a.book_id
    from dwd.dwd_read_user_chapter_view a
    where a.dt >= '${bf_8_dt}'
      and a.dt <= '${af_1_dt}'
      and date(hours_add(a.create_time, -13)) >= '${bf_7_dt}'
      and date(hours_add(a.create_time, -13)) <= '${dt}'
      and a.book_id > 0
      and a.user_id > 0
),
-- 留存原子指标（分子/分母）
retention_stat as (
    select c.dt
         , c.core
         , c.book_id
         , d.retention_day
         , bitmap_agg(c.user_id) as first_read_uv
         , bitmap_agg(case when r.user_id is not null then c.user_id end) as retention_read_uv
    from cohort c
    cross join retention_day d
    left join read_activity r
      on c.product_id = r.product_id
     and c.user_id = r.user_id
     and c.book_id = r.book_id
     and r.read_dt = date_add(c.dt, interval d.retention_day day)
    where date_add(c.dt, interval d.retention_day day) <= cast('${dt}' as date)
    group by 1, 2, 3, 4
),
-- 主表输出键（保证最终输出以主表为准）
output_key as (
    select k.dt
         , k.core
         , k.book_id
         , d.retention_day
    from end_main_key k
    cross join retention_day d
)
select k.dt
     , k.core
     , k.book_id
     , k.retention_day
     , b.book_code
     , b.book_name
     , b.language_cd
     , b.language_name
     , b.content_type_cd
     , b.content_type_name
     , b.series_name
     , b.build_time
     , r.first_read_uv
     , r.retention_read_uv
     , now() as etl_time
from output_key k
 join retention_stat r
  on k.dt = r.dt
 and k.core = r.core
 and k.book_id = r.book_id
 and k.retention_day = r.retention_day
left join book_info b
  on k.book_id = b.book_id
;
