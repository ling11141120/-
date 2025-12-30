----------------------------------------------------------------
-- 程序功能： 阅读-西五区-用户书籍首次阅读章节消耗数据
-- 程序名： P_ads_bi_read_first_read_consume_est_ed
-- 目标表： ads.ads_bi_read_first_read_consume_est_ed
-- 负责人： qhr
-- 开发日期： 2025-12-30
----------------------------------------------------------------

-- 在查询前设置内存限制
SET enable_spill = true;
SET query_mem_limit = 118111600640;  -- 110GB
SET exec_mem_limit = 214748364800;   -- 200GB

insert into tmp.ads_bi_read_first_read_consume_est_ed
with read_dtl as (
    select user_id                        as user_id
         , book_id                        as book_id
         , chapter_id                     as chapter_id
         , product_id                     as product_id
         , hours_add(create_time, -13)    as create_time    -- 统一西五区时区转换
         , 1                              as tps
         , 0                              as types
         , cast(0 as DECIMAL(18, 6))      as amt
      from dwd.dwd_read_user_chapter_view
     where dt >= date_sub('${bf_1_dt}', interval 35 day)
       and dt < '${dt}'
       and create_time >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
       and create_time < hours_add('${dt}', 13)
     union all
    select user_id                        as user_id
         , book_id                        as book_id
         , cast(chapter_id as bigint)     as chapter_id
         , product_id                     as product_id
         , hours_add(fst_time, -13)       as create_time    -- 消费时间转西五区
         , 2                              as tps
         , types                          as types
         , con_chp_amount                 as amt
      from dwm.dwm_consume_user_consume_mild_ed
     where dt >= date_sub('${bf_1_dt}', interval 35 day)
       and dt < '${dt}'
       and fst_time >= date_sub(hours_add('${bf_1_dt}', 13), interval 35 day)
       and fst_time < hours_add('${dt}', 13)
)
, fst_read as (
    select fstr.dt
         , fstr.product_id
         , fstr.user_id
         , fstr.book_id
--         , fstr.chapter_id
         , fstr.mt
         , fstr.corever
         , fstr.user_tp
         , fstr.source_user_tp
         , fstr.source
         , fstr.fst_read_tm
         , fstr.h12_time
         , fstr.h24_time
         , fstr.d3_time
         , fstr.d7_time
         , fstr.d30_time
         , case when fstr.product_id in (7757, 8858, 7777, 8888) then 1
                when fstr.product_id = 3333 then 2
                else dict.p_cd_val
           end as lang_id
      from dws.dws_user_first_read_book_est_ed as fstr
      left join dim.dim_pub_code_mapping_dict  as dict
        on right(fstr.book_id, 3) = dict.cd_val
       and dict.app_plat = 'pub'
       and dict.cd_col = 'book_lang_cd'
     where fstr.dt >= date_sub('${bf_1_dt}', interval 31 day)
       and fstr.dt < '${dt}'
)
, joined_data as (
    select fr.dt
         , fr.product_id
         , fr.user_id
         , fr.book_id
         , rd.chapter_id
         , fr.mt
         , fr.corever
         , fr.user_tp
         , fr.source_user_tp
         , fr.source
         , fr.fst_read_tm
         , fr.h12_time
         , fr.h24_time
         , fr.d3_time
         , fr.d7_time
         , fr.d30_time
         , fr.lang_id
         , rd.tps
         , rd.types
         , rd.amt
         , rd.create_time
         , to_bitmap(concat(fr.user_id, fr.book_id)) as user_book_bitmap
      from fst_read         as fr
      left join read_dtl    as rd
        on fr.product_id = rd.product_id
       and fr.user_id = rd.user_id
       and fr.book_id = rd.book_id
       and rd.create_time >= fr.fst_read_tm    -- 关键：时间条件前置，消除825亿行中间结果
       and rd.create_time <= fr.d30_time       -- 最大时间窗口边界
    group by fr.dt
           , fr.product_id
           , fr.user_id
           , fr.book_id
           , rd.chapter_id
           , fr.mt
           , fr.corever
           , fr.user_tp
           , fr.source_user_tp
           , fr.source
           , fr.fst_read_tm
           , fr.h12_time
           , fr.h24_time
           , fr.d3_time
           , fr.d7_time
           , fr.d30_time
           , fr.lang_id
           , rd.tps
           , rd.types
           , rd.amt
           , rd.create_time
)
, win_agg as (
    select dt
         , lang_id
         , book_id
         , chapter_id
         , mt
         , corever
         , user_tp
         , source_user_tp
         , source
         , bitmap_union(case when tps = 1 and dt = date(create_time) then user_book_bitmap end)                   as read_unt
         , bitmap_union(case when tps = 2 and dt = date(create_time) then user_book_bitmap end)                   as tot_csm_unt
         , bitmap_union(case when tps = 2 and dt = date(create_time) and types = 1 then user_book_bitmap end)     as csm_unt
         , sum(case when tps = 2 and dt = date(create_time) then amt else 0 end)                                as tot_csm_amt
         , sum(case when tps = 2 and dt = date(create_time) and types = 1 then amt else 0 end)                  as csm_amt
         -- h12窗口
         , bitmap_union(case when tps = 1 and create_time <= h12_time then user_book_bitmap end)                  as h12_read_unt
         , bitmap_union(case when tps = 2 and create_time <= h12_time then user_book_bitmap end)                  as h12_tot_csm_unt
         , bitmap_union(case when tps = 2 and create_time <= h12_time and types = 1 then user_book_bitmap end)    as h12_csm_unt
         , sum(case when tps = 2 and create_time <= h12_time then amt else 0 end)                               as h12_tot_csm_amt
         , sum(case when tps = 2 and create_time <= h12_time and types = 1 then amt else 0 end)                 as h12_csm_amt
         -- h24窗口
         , bitmap_union(case when tps = 1 and create_time <= h24_time then user_book_bitmap end)                  as h24_read_unt
         , bitmap_union(case when tps = 2 and create_time <= h24_time then user_book_bitmap end)                  as h24_tot_csm_unt
         , bitmap_union(case when tps = 2 and create_time <= h24_time and types = 1 then user_book_bitmap end)    as h24_csm_unt
         , sum(case when tps = 2 and create_time <= h24_time then amt else 0 end)                               as h24_tot_csm_amt
         , sum(case when tps = 2 and create_time <= h24_time and types = 1 then amt else 0 end)                 as h24_csm_amt
         -- d3窗口
         , bitmap_union(case when tps = 1 and create_time <= d3_time then user_book_bitmap end)                   as d3_read_unt
         , bitmap_union(case when tps = 2 and create_time <= d3_time then user_book_bitmap end)                   as d3_tot_csm_unt
         , bitmap_union(case when tps = 2 and create_time <= d3_time and types = 1 then user_book_bitmap end)     as d3_csm_unt
         , sum(case when tps = 2 and create_time <= d3_time then amt else 0 end)                                as d3_tot_csm_amt
         , sum(case when tps = 2 and create_time <= d3_time and types = 1 then amt else 0 end)                  as d3_csm_amt
         -- d7窗口
         , bitmap_union(case when tps = 1 and create_time <= d7_time then user_book_bitmap end)                   as d7_read_unt
         , bitmap_union(case when tps = 2 and create_time <= d7_time then user_book_bitmap end)                   as d7_tot_csm_unt
         , bitmap_union(case when tps = 2 and create_time <= d7_time and types = 1 then user_book_bitmap end)     as d7_csm_unt
         , sum(case when tps = 2 and create_time <= d7_time then amt else 0 end)                                as d7_tot_csm_amt
         , sum(case when tps = 2 and create_time <= d7_time and types = 1 then amt else 0 end)                  as d7_csm_amt
         -- d30窗口
         , bitmap_union(case when tps = 1 and create_time <= d30_time then user_book_bitmap end)                  as d30_read_unt
         , bitmap_union(case when tps = 2 and create_time <= d30_time then user_book_bitmap end)                  as d30_tot_csm_unt
         , bitmap_union(case when tps = 2 and create_time <= d30_time and types = 1 then user_book_bitmap end)    as d30_csm_unt
         , sum(case when tps = 2 and create_time <= d30_time then amt else 0 end)                               as d30_tot_csm_amt
         , sum(case when tps = 2 and create_time <= d30_time and types = 1 then amt else 0 end)                 as d30_csm_amt
      from joined_data
      group by dt
             , lang_id
             , book_id
             , chapter_id
             , mt
             , corever
             , user_tp
             , source_user_tp
             , source
)
select wa.dt
     , md5(concat( wa.lang_id
                 , wa.book_id
                 , ci.serial_number
                 , case when wa.mt is null then -99 else wa.mt end
                 , case when wa.corever is null then 1 else wa.corever end
                 , wa.user_tp
                 , wa.source_user_tp
                 , case when wa.Source is null then -99 else wa.Source end
                 )
          )                      as md5_key
     , wa.lang_id
     , wa.book_id
     , ci.serial_number
     , wa.mt
     , wa.corever
     , wa.user_tp
     , wa.source_user_tp
     , wa.source
     , case when ci.Free_Chapter_Num = 0 then 0
            else ci.chapter_length
        end                      as chapter_length
     , wa.read_unt
     , wa.tot_csm_unt
     , wa.csm_unt
     , wa.tot_csm_amt
     , wa.csm_amt
     , wa.h12_read_unt
     , wa.h12_tot_csm_unt
     , wa.h12_csm_unt
     , wa.h12_tot_csm_amt
     , wa.h12_csm_amt
     , wa.h24_read_unt
     , wa.h24_tot_csm_unt
     , wa.h24_csm_unt
     , wa.h24_tot_csm_amt
     , wa.h24_csm_amt
     , wa.d3_read_unt
     , wa.d3_tot_csm_unt
     , wa.d3_csm_unt
     , wa.d3_tot_csm_amt
     , wa.d3_csm_amt
     , wa.d7_read_unt
     , wa.d7_tot_csm_unt
     , wa.d7_csm_unt
     , wa.d7_tot_csm_amt
     , wa.d7_csm_amt
     , wa.d30_read_unt
     , wa.d30_tot_csm_unt
     , wa.d30_csm_unt
     , wa.d30_tot_csm_amt
     , wa.d30_csm_amt
     , now()                     as etl_tm
  from win_agg                   as wa
  join dim.dim_book_chapter_info as ci
    on wa.book_id = ci.book_id
   and wa.chapter_id = ci.chapter_id
;