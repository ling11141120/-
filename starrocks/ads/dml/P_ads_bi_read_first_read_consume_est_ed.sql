
-- 1. 强制开启中间结果落盘 (Spill to Disk)
-- 这是防止OOM最关键的参数。当内存不足时，SR会将中间数据写入磁盘，而不是撑爆内存。
SET enable_spill = true;
SET spill_mode = "auto";
SET spill_mem_limit_threshold = 0.7;

-- 2. 限制并行度 (Pipeline DOP)
-- 默认并行度通常是CPU核数的一半或更多。对于18个Bitmap的大宽表，高并发意味着内存消耗xN倍。
-- 将其降至 1 或 2，虽然运行时间会变长，但能极大降低峰值内存，保证任务能跑通。
SET pipeline_dop = 2;
SET parallel_fragment_exec_instance_num = 1;

-- 3. 优化内存限制
-- 建议设置为单节点物理内存的 80% 左右。
SET query_mem_limit = 96636764160; -- 90GB

-- 4. 调整批处理大小
-- 减小每个Batch处理的数据行数，降低瞬时内存压力。
SET batch_size = 2048;

-- 5. 延长超时时间
-- 因为降低了并行度并开启了落盘，任务执行时间会变长，需防止超时中断。
SET query_timeout = 7200;

-- 6. 针对Bitmap的局部聚合优化 (视版本支持情况)
-- 尝试开启Bitmap预聚合优化
SET new_planner_optimize_timeout = 3000;

-- 关闭全局 runtime filter（最关键）
SET enable_global_runtime_filter = false;
-- 关闭 TopN runtime filter（次要，但建议一起关）
SET enable_topn_runtime_filter = false;
-- 关闭 runtime 自适应并行（防止 bitmap 放大）
SET enable_runtime_adaptive_dop = false;

insert into ads.ads_bi_read_first_read_consume_est_ed
-- 1. 预处理左表：提前计算 lang_id，避免在 Group By 中进行复杂运算
with user_base as (
select dt
    , product_id
    , user_id
    , book_id
    , mt
    , corever
    , user_tp
    , source_user_tp
    , source
    , fst_read_tm
    , h12_time
    , h24_time
    , d3_time
    , d7_time
    , d30_time
    -- 提前计算 user-book 唯一标识，减少聚合时的重复计算
    , concat(user_id, book_id) as ub_key
    -- 将巨大的 CASE WHEN 逻辑下推到这里
    , case
          when right(book_id, 3) = 322                then 3
          when right(book_id, 3) = 418                then 7
          when right(book_id, 3) = 409                then 5
          when right(book_id, 3) = 414                then 11
          when right(book_id, 3) = 445                then 15
          when right(book_id, 3) = 375                then 4
          when right(book_id, 3) = 410                then 6
          when right(book_id, 3) = 419                then 9
          when right(book_id, 3) = 433                then 12
          when right(book_id, 3) = 436                then 14
          when right(book_id, 3) = 435                then 13
          when right(book_id, 3) = 412                then 16
          when right(book_id, 3) = 413                then 8
          when right(book_id, 3) = 415                then 10
          when right(book_id, 3) = 447                then 17
          when right(book_id, 3) = 448                then 18
          when right(book_id, 3) = 491                then 19
          when right(book_id, 3) = 492                then 20
          when right(book_id, 3) = 497                then 22
          when product_id = 3333                      then 2
          when product_id in (7757, 8858, 7777, 8888) then 1 end as lang_id
from dws.dws_user_first_read_book_est_ed
where dt >= date_sub('${bf_1_dt}', interval 31 day)
  and dt < '${dt}'
),
-- 2. 预处理右表：保持原有的 Union 逻辑，确保谓词下推
detail_log as (
-- ----------------阅读的明细----------------------------------
    select hours_add(create_time, -13) as create_time
         , product_id
         , user_id
         , book_id
         , chapter_id
         , 1                           as tps
         , 0                           as types
         , 0                           as amt
    from dwd.dwd_read_user_chapter_view
    where dt >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
      and create_time >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
      and dt < hours_add('${dt}', 13)

    union all
-- ----------------章节解锁的明细-------------------------------
    select hours_add(fst_time, -13) as create_time
         , product_id
         , user_id
         , book_id
         , chapter_id
         , 2                        as tps
         , types
         , con_chp_amount           as amt
    from dwm.dwm_consume_user_consume_mild_ed
    where dt >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
      and fst_time >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
      and dt < hours_add('${dt}', 13)
)

select agg.dt
     -- 重新计算 MD5，逻辑保持不变
     , md5(concat(agg.lang_id, agg.book_id, c.serial_number,
                  case when agg.mt is null then -99 else agg.mt end,
                  case when agg.corever is null then 1 else agg.corever end,
                  agg.user_tp, agg.source_user_tp,
                  case when agg.Source is null then -99 else agg.Source end)) as md5_key
     , agg.lang_id
     , agg.book_id
     , c.serial_number
     , agg.mt
     , agg.corever
     , agg.user_tp
     , agg.source_user_tp
     , agg.source
     , case when c.Free_Chapter_Num = 0 then 0 else c.chapter_length end      as chapter_length
     -- 指标列
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
     , now()                                                                  as etl_tm
from (
    select
        a.dt,
        a.lang_id, -- 直接使用 CTE 中算好的 ID
        a.book_id,
        b.chapter_id,
        a.mt,
        a.corever,
        a.user_tp,
        a.source_user_tp,
        a.source,
        -- 使用 ub_key 替代原先的 concat(a.user_id, a.book_id)
        bitmap_agg(CASE WHEN b.tps=1 and a.dt=date(b.create_time) THEN a.ub_key ELSE null END ) as read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and a.dt=date(b.create_time) THEN a.ub_key ELSE null END ) as tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and a.dt=date(b.create_time) THEN a.ub_key ELSE null END ) as csm_unt,
        sum(CASE WHEN b.tps=2 and a.dt=date(b.create_time) THEN b.amt ELSE 0 END ) as tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and a.dt=date(b.create_time) THEN b.amt ELSE 0 END) as csm_amt,

        bitmap_agg(CASE WHEN b.tps=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h12_time THEN a.ub_key ELSE null END) as h12_read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.h12_time THEN a.ub_key ELSE null END) as h12_tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h12_time THEN a.ub_key ELSE null END) as h12_csm_unt,
        sum(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.h12_time THEN b.amt ELSE 0 END) as h12_tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h12_time THEN b.amt ELSE 0 END) as h12_csm_amt,

        bitmap_agg(CASE WHEN b.tps=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h24_time THEN a.ub_key ELSE null END) as h24_read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.h24_time THEN a.ub_key ELSE null END) as h24_tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h24_time THEN a.ub_key ELSE null END) as h24_csm_unt,
        sum(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.h24_time THEN b.amt ELSE 0 END) as h24_tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.h24_time THEN b.amt ELSE 0 END) as h24_csm_amt,

        bitmap_agg(CASE WHEN b.tps=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d3_time THEN a.ub_key ELSE null END) as d3_read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d3_time THEN a.ub_key ELSE null END) as d3_tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d3_time THEN a.ub_key ELSE null END) as d3_csm_unt,
        sum(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d3_time THEN b.amt ELSE 0 END) as d3_tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d3_time THEN b.amt ELSE 0 END) as d3_csm_amt,

        bitmap_agg(CASE WHEN b.tps=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d7_time THEN a.ub_key ELSE null END) as d7_read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d7_time THEN a.ub_key ELSE null END) as d7_tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d7_time THEN a.ub_key ELSE null END) as d7_csm_unt,
        sum(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d7_time THEN b.amt ELSE 0 END) as d7_tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d7_time THEN b.amt ELSE 0 END) as d7_csm_amt,

        bitmap_agg(CASE WHEN b.tps=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d30_time THEN a.ub_key ELSE null END) as d30_read_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d30_time THEN a.ub_key ELSE null END) as d30_tot_csm_unt,
        bitmap_agg(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d30_time THEN a.ub_key ELSE null END) as d30_csm_unt,
        sum(CASE WHEN b.tps=2 and b.create_time>=a.fst_read_tm and b.create_time<=a.d30_time THEN b.amt ELSE 0 END) as d30_tot_csm_amt,
        sum(CASE WHEN b.tps=2 and b.types=1 and b.create_time>=a.fst_read_tm and b.create_time<=a.d30_time THEN b.amt ELSE 0 END) as d30_csm_amt

    from user_base                a
             left join detail_log b
               on a.product_id = b.product_id
              and a.book_id = b.book_id
              and a.user_id = b.user_id
    group by a.dt
           , a.lang_id
           , a.book_id
           , b.chapter_id
           , a.mt
           , a.corever
           , a.user_tp
           , a.source_user_tp
           , a.source
) agg
    inner join dim.dim_book_chapter_info c
       on agg.book_id = c.book_id
      and agg.chapter_id = c.chapter_id
;