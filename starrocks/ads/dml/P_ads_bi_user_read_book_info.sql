----------------------------------------------------------------
-- 程序功能： 运营业务bi报表需求-阅读域用户粒度书籍阅读信息数据
-- 程序名： P_ads_bi_user_read_book_info
-- 目标表： ads.ads_bi_user_read_book_info
-- 负责人： wx
-- 开发日期：
-- 初始版本号: v1.0.0
----------------------------------------------------------------

insert into ads.ads_bi_user_read_book_info
select a1.dt
      ,a1.product_id
      ,a1.user_id
      ,a1.book_id
      ,a1.site_id
      ,a1.corever
      ,case when d1.user_id is not null then 1
            else 0
       end                             as is_channel_book
      ,coalesce(a1.mt, -99)            as mt
      ,now()                           as etl_time
  from dws.dws_read_user_readbook_ed             as a1
  left join (select Product_Id
                   ,user_id
                   ,mt
                   ,corever
                   ,lang2
                   ,last_bookid
               from dws.dws_user_market_channel_info_detail_td
              where dt='${bf_1_dt}'
                and last_bookid >0
             )                                   as d1
    on a1.product_id =d1.product_id
   and a1.book_id =d1.last_bookid
   and a1.user_id =d1.user_id
   and a1.mt=d1.mt
   and a1.corever=d1.corever
   and a1.current_language2=d1.lang2
 where a1.dt>='${bf_1_dt}'
   and a1.dt<'${dt}'
   and a1.product_id not in (8888,7777,3399)
;