----------------------------------------------------------------
-- 程序功能：首次阅读章节消费结果表装载（基于 contrib 聚合）-- 重构版
-- 程序名称：P_ads_bi_read_first_read_consume_est_ed
-- 目标表：ads.ads_bi_read_first_read_consume_est_ed
-- 负责人：roger
-- 开发日期：2026-04-16
-- 版本号：v1.0
----------------------------------------------------------------

set enable_spill = true;
set spill_mode = "auto";
set spill_mem_limit_threshold = 0.7;
set pipeline_dop = 2;
set parallel_fragment_exec_instance_num = 1;
set query_mem_limit = 96636764160;
set batch_size = 2048;
set query_timeout = 7200;
set new_planner_optimize_timeout = 3000;
set enable_global_runtime_filter = false;
set enable_topn_runtime_filter = false;
set enable_runtime_adaptive_dop = false;

insert into ads.ads_bi_read_first_read_consume_est_ed
with agg as (
  select
    anchor_dt                                                          as dt
    , lang_id
    , book_id
    , chapter_id
    , mt
    , corever
    , user_tp
    , source_user_tp
    , source
    , bitmap_union(case when window_type = '0d' then read_unt end)     as read_unt
    , bitmap_union(case when window_type = '0d' then tot_csm_unt end)  as tot_csm_unt
    , bitmap_union(case when window_type = '0d' then csm_unt end)      as csm_unt
    , sum(case when window_type = '0d' then tot_csm_amt else 0 end)    as tot_csm_amt
    , sum(case when window_type = '0d' then csm_amt else 0 end)        as csm_amt

    , bitmap_union(case when window_type = 'h12' then read_unt end)    as h12_read_unt
    , bitmap_union(case when window_type = 'h12' then tot_csm_unt end) as h12_tot_csm_unt
    , bitmap_union(case when window_type = 'h12' then csm_unt end)     as h12_csm_unt
    , sum(case when window_type = 'h12' then tot_csm_amt else 0 end)   as h12_tot_csm_amt
    , sum(case when window_type = 'h12' then csm_amt else 0 end)       as h12_csm_amt

    , bitmap_union(case when window_type = 'h24' then read_unt end)    as h24_read_unt
    , bitmap_union(case when window_type = 'h24' then tot_csm_unt end) as h24_tot_csm_unt
    , bitmap_union(case when window_type = 'h24' then csm_unt end)     as h24_csm_unt
    , sum(case when window_type = 'h24' then tot_csm_amt else 0 end)   as h24_tot_csm_amt
    , sum(case when window_type = 'h24' then csm_amt else 0 end)       as h24_csm_amt

    , bitmap_union(case when window_type = 'd3' then read_unt end)     as d3_read_unt
    , bitmap_union(case when window_type = 'd3' then tot_csm_unt end)  as d3_tot_csm_unt
    , bitmap_union(case when window_type = 'd3' then csm_unt end)      as d3_csm_unt
    , sum(case when window_type = 'd3' then tot_csm_amt else 0 end)    as d3_tot_csm_amt
    , sum(case when window_type = 'd3' then csm_amt else 0 end)        as d3_csm_amt

    , bitmap_union(case when window_type = 'd7' then read_unt end)     as d7_read_unt
    , bitmap_union(case when window_type = 'd7' then tot_csm_unt end)  as d7_tot_csm_unt
    , bitmap_union(case when window_type = 'd7' then csm_unt end)      as d7_csm_unt
    , sum(case when window_type = 'd7' then tot_csm_amt else 0 end)    as d7_tot_csm_amt
    , sum(case when window_type = 'd7' then csm_amt else 0 end)        as d7_csm_amt

    , bitmap_union(case when window_type = 'd30' then read_unt end)    as d30_read_unt
    , bitmap_union(case when window_type = 'd30' then tot_csm_unt end) as d30_tot_csm_unt
    , bitmap_union(case when window_type = 'd30' then csm_unt end)     as d30_csm_unt
    , sum(case when window_type = 'd30' then tot_csm_amt else 0 end)   as d30_tot_csm_amt
    , sum(case when window_type = 'd30' then csm_amt else 0 end)       as d30_csm_amt
  from ads.ads_mid_read_first_contrib_di
  where
    anchor_dt between date_sub('${bf_1_dt}', interval 30 day) and '${bf_1_dt}'
    -- 对齐原逻辑 detail_log 的 35 天扫描范围
    and dt between date_sub('${bf_1_dt}', interval 35 day) and '${bf_1_dt}'
  group by
    anchor_dt
    , lang_id
    , book_id
    , chapter_id
    , mt
    , corever
    , user_tp
    , source_user_tp
    , source
)

select
  agg.dt
  , md5(concat(
    agg.lang_id, agg.book_id, c.serial_number
    , coalesce(agg.mt, -99)
    , coalesce(agg.corever, 1)
    , agg.user_tp, agg.source_user_tp
    , coalesce(agg.source, '-99')
  ))                                                                  as md5_key
  , agg.lang_id
  , agg.book_id
  , c.serial_number
  , nullif(agg.mt, -99)                                               as mt
  , agg.corever
  , agg.user_tp
  , agg.source_user_tp
  , nullif(agg.source, '-99')                                         as source
  , case when c.free_chapter_num = 0 then 0 else c.chapter_length end as chapter_length
  , agg.read_unt
  , agg.tot_csm_unt
  , agg.csm_unt
  , agg.tot_csm_amt
  , agg.csm_amt
  , agg.h12_read_unt
  , agg.h12_tot_csm_unt
  , agg.h12_csm_unt
  , agg.h12_tot_csm_amt
  , agg.h12_csm_amt
  , agg.h24_read_unt
  , agg.h24_tot_csm_unt
  , agg.h24_csm_unt
  , agg.h24_tot_csm_amt
  , agg.h24_csm_amt
  , agg.d3_read_unt
  , agg.d3_tot_csm_unt
  , agg.d3_csm_unt
  , agg.d3_tot_csm_amt
  , agg.d3_csm_amt
  , agg.d7_read_unt
  , agg.d7_tot_csm_unt
  , agg.d7_csm_unt
  , agg.d7_tot_csm_amt
  , agg.d7_csm_amt
  , agg.d30_read_unt
  , agg.d30_tot_csm_unt
  , agg.d30_csm_unt
  , agg.d30_tot_csm_amt
  , agg.d30_csm_amt
  , now()                                                             as etl_tm
from agg
inner join dim.dim_book_chapter_info as c
  on
    agg.book_id = c.book_id
    and agg.chapter_id = c.chapter_id
;
