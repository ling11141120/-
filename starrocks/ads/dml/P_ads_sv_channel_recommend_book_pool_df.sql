----------------------------------------------------------------
-- 程序功能：海剧频道推荐算法书池快照表
-- 程序名： P_ads_sv_channel_recommend_book_pool_df
-- 目标表：ads.ads_sv_channel_recommend_book_pool_df
-- 负责人：lwb
-- 开发日期： 2026-06-22
-- 口径说明：
-- 1. 原书池：解说漫关联的原书，且原书为上架状态。
--    解说漫按源剧字段 LocalType=5 识别，通过短剧后台表 BookId 关联海阅原书。
-- 2. 推荐池：先筛选上架且无互斥或属于互斥主推版本的书，再取近30天或近60天总消费排名前1000。
--    总消费口径：阅币、礼券、赠送币、VIP消费金额合计。
-- 3. 算法书池：原书池和推荐池并集。
----------------------------------------------------------------

truncate table ads.ads_sv_channel_recommend_book_pool_df;

insert into ads.ads_sv_channel_recommend_book_pool_df (
    language_id
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
select language_id
     , book_id
     , product_id
     , book_name
     , book_code
     , channel
     , category_name
     , build_time
     , is_original_pool
     , is_recommend_pool
     , consume_amount_30d
     , consume_rank_30d
     , consume_amount_60d
     , consume_rank_60d
     , ad_income_30d
     , ad_income_60d
     , has_mutex
     , is_main_push_mutex
     , now() as etl_time
  from ads.ads_sv_channel_recommend_book_pool_di
 where dt = '${bf_1_dt}'
;
