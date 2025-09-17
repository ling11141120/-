----------------------------------------------------------------
-- 程序功能： bi:用户消耗书籍数据
-- 程序名： P_ads_bi_user_book_consume_info
-- 目标表： ads.ads_bi_user_book_consume_info
-- 负责人： wx
-- 开发日期：
-- 初始版本号: v1.0.0
----------------------------------------------------------------

insert into ads.ads_bi_user_book_consume_info
select a1.dt
      ,a1.product_id
      ,a1.book_id
      ,0        as book_name
      ,0        as book_nature
      ,0        as new_cname
      ,0        as build_time
      ,0        as normal_chapter_num_f
      ,a1.user_id
      ,a1.corever
      ,a1.types
      ,a1.amount           -- 消耗货币数
      ,a1.con_chapter_nums -- 消耗章节数
      ,0        as is_read
      ,case when d1.user_id is not null then 1
            else 0
        end     as is_channel_book
      ,coalesce(a1.mt, -99)               as mt
      ,now()    as etl_time
  from dws.dws_consume_user_consume_ed    as a1
  left join ( select Product_Id
                    ,user_id
                    ,mt
                    ,corever
                    ,lang2
                    ,last_bookid
                from dws.dws_user_market_channel_info_detail_td
               where dt='${bf_1_dt}'
                 and last_bookid >0
            )                             as d1
    on a1.product_id =d1.product_id
   and a1.book_id =d1.last_bookid
   and a1.user_id =d1.user_id
   and a1.mt=d1.mt
   and a1.corever=d1.corever
   and a1.current_language2=d1.lang2
 where a1.dt>='${bf_1_dt}'
   and a1.dt<'${dt}'
   and a1.product_id not in (8888,7777,3399)
   and a1.types!=5
;