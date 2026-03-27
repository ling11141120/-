----------------------------------------------------------------
-- 程序功能： 海阅阅读来源统计表
-- 程序名： P_ads_sr_beidou_books_source_stat_di
-- 目标表： ads.ads_sr_beidou_books_source_stat_di
-- 负责人： roger
-- 开发日期：2026-03-17
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sr_beidou_books_source_stat_di
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
-- 主表：startReading 来源事件（西五区口径 + 分区 dt 过滤）
source_main as (
    select date(date_add(a.event_tm, interval -13 hour)) as dt
         , coalesce(cast(a.app_core_ver as int), 0)      as core
         , cast(a.book_id as bigint)                     as book_id
         , coalesce(a.read_source_page_name, 'Unknown')  as read_source_page_name
    from ads.ads_sensors_production_startreadingchapter_view a
    left semi join dim.dim_shuangwen_book_read_consume_info eb_filter
      on cast(a.book_id as bigint) = eb_filter.book_id
    where a.dt >= '${bf_1_dt}'
      and a.dt <= '${af_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) >= '${bf_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) <= '${dt}'
      and cast(a.book_id as bigint) > 0
      and cast(a.identity_login_id as bigint) > 0
),
-- 指标聚合：按来源页统计阅读 PV
source_stat as (
    select dt
         , core
         , book_id
         , read_source_page_name
         , count(1) as total_read_pv  -- 阅读总PV=startReading事件次数
    from source_main
    group by 1, 2, 3, 4
)
select s.dt
     , s.core
     , s.book_id
     , s.read_source_page_name
     , b.book_code
     , b.book_name
     , b.language_cd
     , b.language_name
     , b.content_type_cd
     , b.content_type_name
     , b.series_name
     , b.build_time
     , s.total_read_pv
     , now() as etl_time
from source_stat s
left join book_info b
  on s.book_id = b.book_id
;
