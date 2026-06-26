----------------------------------------------------------------
-- 程序功能：海剧频道推荐算法书池日表
-- 程序名： P_ads_sv_channel_recommend_book_pool_di
-- 目标表：ads.ads_sv_channel_recommend_book_pool_di
-- 负责人：lwb
-- 开发日期： 2026-06-22
-- 口径说明：
-- 1. 原书池：解说漫关联的原书，且原书为上架状态。
--    解说漫按源剧字段 LocalType=5 识别，通过短剧后台表 BookId 关联海阅原书。
-- 2. 推荐池：先筛选上架且无互斥或属于互斥主推版本的书，再取近30天或近60天总消费排名前1000。
--    总消费口径：阅币、礼券、赠送币、VIP消费金额合计。
-- 3. 算法书池：原书池和推荐池并集。
----------------------------------------------------------------

delete from ads.ads_sv_channel_recommend_book_pool_di
 where dt = '${bf_1_dt}';

insert into ads.ads_sv_channel_recommend_book_pool_di (
    dt
   ,language_id
   ,book_id
   ,product_id
   ,book_name
   ,book_code
   ,channel
   ,category_name
   ,build_time
   ,is_original_pool
   ,is_recommend_pool
   ,consume_amount_30d
   ,consume_rank_30d
   ,consume_amount_60d
   ,consume_rank_60d
   ,ad_income_30d
   ,ad_income_60d
   ,has_mutex
   ,is_main_push_mutex
   ,etl_time
)
with book_dim as (
    select product_id
         , book_id
         , book_name
         , languageid as language_id
         , book_code
         , channel
         , new_cname as category_name
         , build_time
      from dim.dim_shuangwen_book_read_consume_info
     where book_id is not null
       and book_id > 0
       and languageid is not null
       and sexy2 < 4
)
, mutex_info as (
    select BookId as book_id
         , 1 as has_mutex
         , max(if(IsMainPush = 1, 1, 0)) as is_main_push_mutex
      from dim.dim_mutexconfigbook_view
     where coalesce(IsDelete, 0) = 0
       and BookId is not null
       and BookId > 0
     group by BookId
)
, eligible_recommend_book as (
    select distinct bd.book_id
      from book_dim bd
      left join mutex_info mi
        on bd.book_id = mi.book_id
     where mi.book_id is null
        or mi.is_main_push_mutex = 1
)
, original_relation as (
    select sv.BookId as original_book_id
      from ods.ods_tidb_short_video_admin_series sv
      join dim.dim_short_video_source_series_view src
        on sv.SourceSeriesId = src.series_id
      join book_dim bd
        on sv.BookId = bd.book_id
     where coalesce(sv.IsDelete, 0) = 0
       and coalesce(src.is_delete, 0) = 0
       and src.local_type = 5
       and sv.BookId is not null
       and sv.BookId > 0
     group by sv.BookId
)
, consume_amount_30d as (
    select book_id
         , sum(coalesce(amount, 0)) as consume_amount_30d
      from dws.dws_consume_book_consume_ed
     where dt >= date_sub('${bf_1_dt}', interval 29 day)
       and dt <= '${bf_1_dt}'
       and types in (1, 2, 3, 4)
       and book_id is not null
       and book_id > 0
     group by book_id
)
, consume_30d as (
    select a.book_id
         , a.consume_amount_30d
         , row_number() over (order by a.consume_amount_30d desc, a.book_id) as consume_rank_30d
      from consume_amount_30d a
      join eligible_recommend_book e
        on a.book_id = e.book_id
)
, consume_amount_60d as (
    select book_id
         , sum(coalesce(amount, 0)) as consume_amount_60d
      from dws.dws_consume_book_consume_ed
     where dt >= date_sub('${bf_1_dt}', interval 59 day)
       and dt <= '${bf_1_dt}'
       and types in (1, 2, 3, 4)
       and book_id is not null
       and book_id > 0
     group by book_id
)
, consume_60d as (
    select a.book_id
         , a.consume_amount_60d
         , row_number() over (order by a.consume_amount_60d desc, a.book_id) as consume_rank_60d
      from consume_amount_60d a
      join eligible_recommend_book e
        on a.book_id = e.book_id
)
, ad_income_30d as (
    select book_id
         , ad_income_30d
      from (
          select book_id
               , sum(coalesce(amt, 0)) as ad_income_30d
            from dws.dws_advertisement_user_position_amt_ed
           where dt >= date_sub('${bf_1_dt}', interval 29 day)
             and dt <= '${bf_1_dt}'
             and book_id is not null
             and book_id > 0
           group by book_id
      ) t
)
, ad_income_60d as (
    select book_id
         , ad_income_60d
      from (
          select book_id
               , sum(coalesce(amt, 0)) as ad_income_60d
            from dws.dws_advertisement_user_position_amt_ed
           where dt >= date_sub('${bf_1_dt}', interval 59 day)
             and dt <= '${bf_1_dt}'
             and book_id is not null
             and book_id > 0
           group by book_id
      ) t
)
, original_pool as (
    select bd.product_id
         , bd.book_id
         , bd.book_name
         , bd.language_id
         , bd.book_code
         , bd.channel
         , bd.category_name
         , bd.build_time
         , 1 as is_original_pool
         , 0 as is_recommend_pool
         , ca30.consume_amount_30d
         , c30.consume_rank_30d
         , ca60.consume_amount_60d
         , c60.consume_rank_60d
         , a30.ad_income_30d
         , a60.ad_income_60d
         , coalesce(mi.has_mutex, 0) as has_mutex
         , coalesce(mi.is_main_push_mutex, 0) as is_main_push_mutex
      from original_relation ori
      join book_dim bd
        on ori.original_book_id = bd.book_id
      left join mutex_info mi
        on bd.book_id = mi.book_id
      left join consume_30d c30
        on bd.book_id = c30.book_id
      left join consume_amount_30d ca30
        on bd.book_id = ca30.book_id
      left join consume_60d c60
        on bd.book_id = c60.book_id
      left join consume_amount_60d ca60
        on bd.book_id = ca60.book_id
      left join ad_income_30d a30
        on bd.book_id = a30.book_id
      left join ad_income_60d a60
        on bd.book_id = a60.book_id
)
, recommend_pool as (
    select bd.product_id
         , bd.book_id
         , bd.book_name
         , bd.language_id
         , bd.book_code
         , bd.channel
         , bd.category_name
         , bd.build_time
         , 0 as is_original_pool
         , 1 as is_recommend_pool
         , c30.consume_amount_30d
         , c30.consume_rank_30d
         , c60.consume_amount_60d
         , c60.consume_rank_60d
         , a30.ad_income_30d
         , a60.ad_income_60d
         , coalesce(mi.has_mutex, 0) as has_mutex
         , coalesce(mi.is_main_push_mutex, 0) as is_main_push_mutex
      from book_dim bd
      left join mutex_info mi
        on bd.book_id = mi.book_id
      left join consume_30d c30
        on bd.book_id = c30.book_id
      left join consume_60d c60
        on bd.book_id = c60.book_id
      left join ad_income_30d a30
        on bd.book_id = a30.book_id
      left join ad_income_60d a60
        on bd.book_id = a60.book_id
     where (mi.book_id is null or mi.is_main_push_mutex = 1)
       and (c30.consume_rank_30d <= 1000 or c60.consume_rank_60d <= 1000)
)
, pool_union as (
    select * from original_pool
    union all
    select * from recommend_pool
)
select '${bf_1_dt}' as dt
     , language_id
     , book_id
     , max(product_id) as product_id
     , max(book_name) as book_name
     , max(book_code) as book_code
     , max(channel) as channel
     , max(category_name) as category_name
     , max(build_time) as build_time
     , max(is_original_pool) as is_original_pool
     , max(is_recommend_pool) as is_recommend_pool
     , max(consume_amount_30d) as consume_amount_30d
     , min(consume_rank_30d) as consume_rank_30d
     , max(consume_amount_60d) as consume_amount_60d
     , min(consume_rank_60d) as consume_rank_60d
     , max(ad_income_30d) as ad_income_30d
     , max(ad_income_60d) as ad_income_60d
     , max(has_mutex) as has_mutex
     , max(is_main_push_mutex) as is_main_push_mutex
     , now() as etl_time
  from pool_union
 group by language_id, book_id
;
