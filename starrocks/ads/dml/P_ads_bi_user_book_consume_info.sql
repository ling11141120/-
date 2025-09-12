----------------------------------------------------------------
-- 程序功能： bi:用户消耗书籍数据
-- 程序名： P_ads_bi_user_book_consume_info
-- 目标表： ads.ads_bi_user_book_consume_info
-- 负责人： Ryan
-- 开发日期： 
----------------------------------------------------------------
insert into ads.ads_bi_user_book_consume_info
     select a.dt
           ,a.product_id
           ,a.book_id
           ,0 as book_name
           ,0 as book_nature
           ,0 as new_cname
           ,0 as build_time
           ,0 as normal_chapter_num_f
           ,a.user_id
           ,a.corever
           ,a.types
           ,a.amount           -- 消耗货币数
           ,a.con_chapter_nums -- 消耗章节数
           ,0 as is_read
           ,case when d.user_id is not null then 1 
                 else 0 
             end  as is_channel_book
           ,now() as etl_time
       from dws.dws_consume_user_consume_ed a 
       left join ( select Product_Id
                         ,user_id
                         ,mt
                         ,corever
                         ,lang2
                         ,last_bookid
                     from dws.dws_user_market_channel_info_detail_td
                    where dt='${bf_1_dt}' 
                      and last_bookid >0 ) d 
              on a.product_id =d.product_id  
             and a.book_id =d.last_bookid  
             and a.user_id =d.user_id 
             and a.mt=d.mt
             and a.corever=d.corever
             and a.current_language2=d.lang2 
           where a.dt>='${bf_1_dt}'
             and a.dt<'${dt}' 
             and a.product_id not in (8888,7777,3399)
             and a.types!=5 
 ;