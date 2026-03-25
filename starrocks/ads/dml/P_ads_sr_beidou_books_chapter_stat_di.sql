----------------------------------------------------------------
-- 程序功能： 海阅阅读章节节点留存与流失统计表
-- 程序名： P_ads_sr_beidou_books_chapter_stat_di
-- 目标表： ads.ads_sr_beidou_books_chapter_stat_di
-- 负责人： roger
-- 开发日期：2026-03-17
-- 版本号： v1.0
----------------------------------------------------------------

insert into ads.ads_sr_beidou_books_chapter_stat_di
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
    where t1.is_put_down = 1
      and t1.build_time != '1970-01-01 00:00:00'
),
-- 主表：endReading 用户阅读明细（西五区口径 + 分区 dt 过滤）
end_main as (
    select date(date_add(a.event_tm, interval -13 hour)) as dt
         , coalesce(cast(a.app_core_ver as int), 0)      as core
         , cast(a.book_id as bigint)                     as book_id
         , cast(a.login_id as bigint)                    as user_id
         , cast(a.read_chapter_sort as int)              as chapter_sort
    from ads.ads_sensors_production_endreadingchapter_view a
    left semi join dim.dim_shuangwen_book_read_consume_info eb_filter
      on cast(a.book_id as bigint) = eb_filter.book_id
    where a.dt >= '${bf_1_dt}'
      and a.dt <= '${af_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) >= '${bf_1_dt}'
      and date(date_add(a.event_tm, interval -13 hour)) <= '${dt}'
      and cast(a.book_id as bigint) > 0
      and cast(a.login_id as bigint) > 0
      and cast(a.read_chapter_sort as int) > 0
),
-- 主表键集：最终输出以主表为准
end_main_key as (
    select dt
         , core
         , book_id
    from end_main
    group by 1, 2, 3
),
-- 用户级最大阅读章节（用于留存阈值判断）
user_max_chapter as (
    select dt
         , core
         , book_id
         , user_id
         , max(chapter_sort) as max_chapter_sort
    from end_main
    group by 1, 2, 3, 4
),
-- 章节节点枚举
chapter_scope as (
    select 30 as chapter_scope
    union all select 60
    union all select 90
    union all select 120
    union all select 150
    union all select 180
    union all select 210
    union all select 250
    union all select 300
    union all select 350
    union all select 400
    union all select 450
    union all select 500
),
-- 节点指标拼装（口径：endReading）
scope_stat as (
    select k.dt
         , k.core
         , k.book_id
         , s.chapter_scope
         , bitmap_agg(case when u.max_chapter_sort > s.chapter_scope then u.user_id end) as gt_chapter_scope_read_uv -- 大于章节范围阅读UV
         , bitmap_agg(case when u.max_chapter_sort >= 1 then u.user_id end) as book_read_uv -- 书籍阅读UV（大于等于1章用户）
    from end_main_key k
    cross join chapter_scope s
    left join user_max_chapter u
      on k.dt = u.dt
     and k.core = u.core
     and k.book_id = u.book_id
    group by 1, 2, 3, 4
)
select s.dt
     , s.core
     , s.book_id
     , s.chapter_scope
     , b.book_code
     , b.book_name
     , b.language_cd
     , b.language_name
     , b.content_type_cd
     , b.content_type_name
     , b.series_name
     , b.build_time
     , s.gt_chapter_scope_read_uv
     , s.book_read_uv
     , now() as etl_time
from scope_stat s
left join book_info b
  on s.book_id = b.book_id
;
