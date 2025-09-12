----------------------------------------------------------------
-- 程序功能： 运营业务bi报表需求-阅读域用户粒度书籍阅读信息数据
-- 程序名： P_ads_bi_user_read_book_info
-- 目标表： ads.ads_bi_user_read_book_info
-- 负责人： Ryan
-- 开发日期：
-- 初始版本号: v1.0.0
----------------------------------------------------------------

insert into ads.ads_bi_user_read_book_info
     select a.dt
           ,a.product_id
           ,a.user_id
           ,a.book_id
           ,a.site_id
           ,a.corever
           ,a.mt
           ,case when d.user_id is not null then 1
                 else 0
            end         as is_channel_book
           ,now()       as etl_time
       from dws.dws_read_user_readbook_ed             as a
       left join (select Product_Id
                        ,user_id
                        ,mt
                        ,corever
                        ,lang2
                        ,last_bookid
                    from dws.dws_user_market_channel_info_detail_td
                   where dt='${bf_1_dt}'
                     and last_bookid >0
                  )                                   as d
         on a.product_id =d.product_id
        and a.book_id =d.last_bookid
        and a.user_id =d.user_id
        and a.mt=d.mt
        and a.corever=d.corever
        and a.current_language2=d.lang2
      where a.dt>='${bf_1_dt}'
        and a.dt<'${dt}'
        and a.product_id not in (8888,7777,3399);