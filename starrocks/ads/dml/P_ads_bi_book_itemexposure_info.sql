----------------------------------------------------------------
-- 程序功能： 海阅小说曝光点击事件数据
-- 程序名： P_ads_bi_book_itemexposure_info
-- 目标表： ads.ads_bi_book_itemexposure_info
-- 负责人： qhr
-- 开发日期： 
----------------------------------------------------------------

insert into ads.ads_bi_book_itemexposure_info
with expo as (
    select a.dt
          ,a.product_id
          ,a.book_lang_id
          ,a.corever
          ,a.book_id
          ,ifnull(a.is_channel_book, -99)      as is_channel_book
          ,a.mt
          ,bitmap_union(to_bitmap(user_id))    as expo_unt
      from (select a.dt
                  ,a.product_id
                  ,a.book_lang_id
                  ,ifnull(a.corever, -99)                       as corever
                  ,a.book_id
                  ,a.user_id
                  ,if(b.book_id is not null, 1, 0)              as is_channel_book
                  ,a.mt
                  ,row_number() over(partition by a.dt
                                                 ,a.product_id
                                                 ,a.book_lang_id
                                                 ,a.book_id
                                                 ,a.user_id
                                                 ,a.mt
                                         order by b.dt desc)    as rn
              from (select dt
                          ,product_id
                          ,case when right(book_id, 3) = '410' then 6    -- 通过书籍后三位siteid判断书籍语言，剩余判断不出来的书归为上报的current_language语言
                                when right(book_id, 3) = '409' then 5
                                when right(book_id, 3) = '322' then 3
                                when right(book_id, 3) = '001' then 3    -- 尾号001的书籍比较早期的图书 归为英语
                                when right(book_id, 3) = '418' then 7
                                when right(book_id, 3) = '375' then 4
                                when right(book_id, 3) = '445' then 15
                                when right(book_id, 3) = '436' then 14
                                when right(book_id, 3) = '433' then 12
                                when right(book_id, 3) = '414' then 11
                                when right(book_id, 3) = '419' then 9
                                when product_id = 3333         then 2    -- 繁体的书
                                else current_language                    -- 剩余判断不出来的书归为上报的current_language语言
                            end                             as book_lang_id
                          ,corever
                          ,book_id
                          ,user_id
                          ,coalesce(mt, '-99')              as mt
                      from dws.dws_flow_item_exposure_ed    as a
                     where dt >= '${bf_3_dt}' 
                       and dt < '${dt}' 
                       and user_id is not null
                       and book_id > 0 
                       and product_id is not null    -- 过滤掉非正常的数据
                   )                                        as a
              left join (select dt
                               ,Product_Id                  as product_id
                               ,user_id
                               ,last_bookid                 as book_id
                           from dws.dws_user_market_channel_info_detail_td
                          where dt >= '${bf_3_dt}'
                            and dt < '${dt}'
                          group by 1, 2, 3, 4
                        )                                   as b
                on a.product_id = b.product_id
               and a.user_id = b.user_id
               and a.dt = b.dt
               and a.book_id = b.book_id
           )                                                as a
     where rn = 1
     group by 1, 2, 3, 4, 5, 6, 7
)
, click as (
    select a.dt
          ,a.product_id
          ,a.book_lang_id
          ,a.corever
          ,a.book_id
          ,ifnull(a.is_channel_book, -99)             as is_channel_book
          ,a.mt
          ,bitmap_union(to_bitmap(user_id))           as cli_unt
      from (select a.dt
                  ,a.product_id
                  ,a.book_lang_id
                  ,ifnull(a.corever, -99)             as corever
                  ,a.book_id
                  ,a.user_id
                  ,if(b.book_id is not null, 1, 0)    as is_channel_book
                  ,a.mt
                  ,row_number() over(partition by a.dt
                                                 ,a.product_id
                                                 ,a.book_lang_id
                                                 ,a.book_id
                                                 ,a.user_id
                                                 ,a.mt
                                         order by b.dt desc
                                    )                 as rn
              from (
                    -- 点击书籍
                    select dt
                          ,app_product_id         as product_id
                          ,case when right(book_id, 3) = '410' then 6    -- 通过书籍后三位siteid判断书籍语言，剩余判断不出来的书归为上报的current_language语言
                                when right(book_id, 3) = '409' then 5
                                when right(book_id, 3) = '322' then 3
                                when right(book_id, 3) = '001' then 3    -- 尾号001的书籍比较早期的图书 归为英语
                                when right(book_id, 3) = '418' then 7
                                when right(book_id, 3) = '375' then 4
                                when right(book_id, 3) = '445' then 15
                                when right(book_id, 3) = '436' then 14
                                when right(book_id, 3) = '433' then 12
                                when right(book_id, 3) = '414' then 11
                                when right(book_id, 3) = '419' then 9
                                when app_product_id = 3333 then 2        -- 繁体的书
                                else app_lang_id                         -- 剩余判断不出来的书归为上报的current_language语言
                            end                   as book_lang_id
                          ,app_core_ver           as corever
                          ,book_id
                          ,coalesce(mt, '-99')    as mt
                          ,identity_login_id      as user_id
                      from dwd.dwd_sensors_production_itemclick_view
                     where dt >= '${bf_3_dt}'
                       and dt < '${dt}'
                       and identity_login_id is not null
                       and cast(identity_login_id AS BIGINT) > 0
                       and book_id > 0
                       and app_product_id is not null                    -- 过滤掉非正常的数据
                   )                            as a
              left join (select dt
                               ,Product_Id      as product_id
                               ,user_id
                               ,last_bookid     as book_id
                           from dws.dws_user_market_channel_info_detail_td
                          where dt >= '${bf_3_dt}' 
                            and dt < '${dt}' 
                          group by 1, 2, 3, 4
                        )                       as b
                on a.product_id = b.product_id
               and a.user_id = b.user_id 
               and a.dt = b.dt 
               and a.book_id = b.book_id
           )                                    as a
     where rn = 1
     group by 1, 2, 3, 4, 5, 6, 7
)
select expo.dt
      ,expo.product_id
      ,expo.book_lang_id
      ,expo.corever
      ,expo.book_id
      ,expo.is_channel_book
      ,expo.mt
      ,expo.expo_unt
      ,cl.cli_unt
      ,now() as etl_tm
  from expo
  left join click cl
    on expo.dt = cl.dt
   and expo.product_id = cl.product_id
   and expo.book_lang_id = cl.book_lang_id
   and expo.corever = cl.corever
   and expo.book_id = cl.book_id
   and expo.is_channel_book = cl.is_channel_book
   and expo.mt = cl.mt
;