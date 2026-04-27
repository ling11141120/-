----------------------------------------------------------------
-- 程序功能：首次阅读章节消费贡献表按天增量装载（event 不落盘），
--         用于ads_bi_read_first_read_consume_est_ed脚本重构，其他用途请勿使用
-- 程序名称：P_ads_mid_read_first_contrib_di
-- 目标表：ads.ads_mid_read_first_contrib_di
-- 负责人：roger
-- 开发日期：2026-04-16
-- 版本号：v1.0
----------------------------------------------------------------

set enable_spill = true;
set spill_mode = "auto";
set spill_mem_limit_threshold = 0.7;
set pipeline_dop = 2;
set parallel_fragment_exec_instance_num = 1;
set enable_global_runtime_filter = false;
set enable_topn_runtime_filter = false;


-- 约束：{p_bf_1_dt} 需与 {bf_1_dt} 对应同一天（格式 yyyyMMdd，例如 20260414）
alter table ads.ads_mid_read_first_contrib_di
drop partition if exists p${p_bf_1_dt};

insert into ads.ads_mid_read_first_contrib_di
with anchor_scope as (
    select dt as anchor_dt
         , product_id
         , user_id
         , book_id
         , concat(user_id, book_id) as ub_key
         , case
               when right(book_id, 3) = 322                 then 3
               when right(book_id, 3) = 418                 then 7
               when right(book_id, 3) = 409                 then 5
               when right(book_id, 3) = 414                 then 11
               when right(book_id, 3) = 445                 then 15
               when right(book_id, 3) = 375                 then 4
               when right(book_id, 3) = 410                 then 6
               when right(book_id, 3) = 419                 then 9
               when right(book_id, 3) = 433                 then 12
               when right(book_id, 3) = 436                 then 14
               when right(book_id, 3) = 435                 then 13
               when right(book_id, 3) = 412                 then 16
               when right(book_id, 3) = 413                 then 8
               when right(book_id, 3) = 415                 then 10
               when right(book_id, 3) = 447                 then 17
               when right(book_id, 3) = 448                 then 18
               when right(book_id, 3) = 491                 then 19
               when right(book_id, 3) = 492                 then 20
               when right(book_id, 3) = 497                 then 22
               when product_id = 3333                       then 2
               when product_id in (7757, 8858, 7777, 8888) then 1
               else -99
           end                  as lang_id
         , coalesce(mt, -99)       as mt
         , coalesce(corever, 1)    as corever
         , user_tp
         , source_user_tp
         , coalesce(source, '-99') as source
         , fst_read_tm
         , h12_time
         , h24_time
         , d3_time
         , d7_time
         , d30_time
    from dws.dws_user_first_read_book_est_ed
    -- 为了与基线 35 天明细扫描等价，锚点保留未来 5 天（承接“明细先发生、锚点后发生”的零指标分组）
    where dt between date_sub('${bf_1_dt}', interval 30 day) and date_add('${bf_1_dt}', interval 5 day)
),
detail_event as (
    select hours_add(create_time, -13) as create_time
         , product_id
         , user_id
         , book_id
         , chapter_id
         , 1                           as tps
         , 0                           as types
         , 0                           as amt
    from dwd.dwd_read_user_chapter_view
    where dt = '${bf_1_dt}'
      and chapter_id is not null
      and create_time is not null

    union all

    select hours_add(fst_time, -13) as create_time
         , product_id
         , user_id
         , book_id
         , cast(`Chapter_id` as bigint) as chapter_id
         , 2                        as tps
         , types
         , con_chp_amount           as amt
    from dwm.dwm_consume_user_consume_mild_ed
    where dt = '${bf_1_dt}'
      and `Chapter_id` is not null
      and trim(`Chapter_id`) <> ''
      and cast(`Chapter_id` as bigint) is not null
      and fst_time is not null
),
joined as (
    select '${bf_1_dt}'                         as dt
         , a.anchor_dt                          as anchor_dt
         , datediff(date(e.create_time), a.anchor_dt) as lag_day
         , a.lang_id
         , a.book_id
         , e.chapter_id
         , a.mt
         , a.corever
         , a.user_tp
         , a.source_user_tp
         , a.source
         , a.ub_key
         , a.fst_read_tm
         , a.h12_time
         , a.h24_time
         , a.d3_time
         , a.d7_time
         , a.d30_time
         , e.create_time
         , e.tps
         , e.types
         , e.amt
    from anchor_scope a
    join detail_event e
      on a.product_id = e.product_id
     and a.user_id = e.user_id
     and a.book_id = e.book_id
),
flags as (
    select *
         , anchor_dt = date(create_time)                         as hit_0d
         , create_time >= fst_read_tm and create_time <= h12_time as hit_h12
         , create_time >= fst_read_tm and create_time <= h24_time as hit_h24
         , create_time >= fst_read_tm and create_time <= d3_time  as hit_d3
         , create_time >= fst_read_tm and create_time <= d7_time  as hit_d7
         , create_time >= fst_read_tm and create_time <= d30_time as hit_d30
    from joined
)
select dt
     , anchor_dt
     , lag_day
     , window_type
     , lang_id
     , book_id
     , chapter_id
     , mt
     , corever
     , user_tp
     , source_user_tp
     , source
     , bitmap_agg(case when tps = 1 then ub_key end)               as read_unt
     , bitmap_agg(case when tps = 2 then ub_key end)               as tot_csm_unt
     , bitmap_agg(case when tps = 2 and types = 1 then ub_key end) as csm_unt
     , sum(case when tps = 2 then amt else 0 end)                  as tot_csm_amt
     , sum(case when tps = 2 and types = 1 then amt else 0 end)    as csm_amt
     , now()                                                        as etl_tm
from (
         -- 保留分组基线：用于对齐原逻辑中“主键存在但各窗口指标均为0”的行
         -- 该分支不参与任何窗口指标汇总（下游仅消费 0d/h12/h24/d3/d7/d30）
         select *
              , 'base' as window_type
         from flags

         union all

         select *
              , '0d' as window_type
         from flags
         where hit_0d

         union all

         select *
              , 'h12' as window_type
         from flags
         where hit_h12

         union all

         select *
              , 'h24' as window_type
         from flags
         where hit_h24

         union all

         select *
              , 'd3' as window_type
         from flags
         where hit_d3

         union all

         select *
              , 'd7' as window_type
         from flags
         where hit_d7

         union all

         select *
              , 'd30' as window_type
         from flags
         where hit_d30
     ) t
where dt is not null
  and anchor_dt is not null
  and lag_day is not null
  and window_type is not null
  and lang_id is not null
  and book_id is not null
  and chapter_id is not null
  and mt is not null
  and corever is not null
  and user_tp is not null
  and source_user_tp is not null
  and source is not null
group by dt
       , anchor_dt
       , lag_day
       , window_type
       , lang_id
       , book_id
       , chapter_id
       , mt
       , corever
       , user_tp
       , source_user_tp
       , source;
