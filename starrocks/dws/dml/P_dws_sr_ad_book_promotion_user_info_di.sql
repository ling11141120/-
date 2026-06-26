----------------------------------------------------------------
-- 程序功能： 海阅-记录在站外针对全量用户进行推书，用户信息表临时表
-- 程序名： P_dws_sr_ad_book_promotion_user_info_di
-- 目标表： dws.dws_sr_ad_book_promotion_user_info_di
-- 负责人： yanxh
-- 开发日期：2026-06-17
----------------------------------------------------------------

-- 前置SQL语句
delete from dws.dws_sr_ad_book_promotion_user_info_di where dt>='${bf_1_dt}' and dt<='${dt}';

insert into dws.dws_sr_ad_book_promotion_user_info_di
select dt
     , product_id
     , bookid           as book_id
     , user_id
     , chl              as chl2
     , campaign
     , source_chl
     , mt
     , core
     , current_language as current_language2
     , concat( '$', bookid
              ,'@', campaign
              ,'|SourceChl=', source_chl
              ,'|Mt=', mt
              ,'|Core=', core
              ,'|Chl2=', chl
              ,'|CurrentLanguage2=', current_language
             ) as adcamp_id
     , now()            as etl_tm
  from (select tag.dt
             , tag.product_id
             , tag.create_time
             , tag.chl
             , tag.mt
             , tag.core
             , tag.unique_cdreader_id
             , tag.current_language
             , ifnull(tag.bookid, -99) as bookid
             , tag.campaign
             , tag.source_chl
             , tag.user_id
             , rd.user_id              as read_user
          from (select a.dt
                     , a.product_id
                     , a.create_time
                     , a.chl
                     , a.mt
                     , a.core
                     , a.unique_cdreader_id
                     , a.current_language
                     , a.bookid
                     , a.campaign
                     , a.source_chl
                     , b.id as user_id
                  from (select a.dt
                             , a.product_id
                             , a.create_time
                             , a.chl
                             , a.mt
                             , a.core
                             , a.unique_cdreader_id
                             , a.current_language
                             , a.bookid
                             , a.campaign
                             , a.source_chl
                          from (select dt
                                     , product_id
                                     , create_time
                                     , chl
                                     , mt
                                     , core
                                     , unique_cdreader_id
                                     , current_language
                                     , substring_index(substring_index(decrypt_data, 'bookid=', -1), '&', 1)       as bookid
                                     , substring_index(substring_index(decrypt_data, 'utm_campaign=', -1), '&', 1) as campaign
                                     , substring_index(substring_index(decrypt_data, 'utm_medium=', -1), '&', 1)   as source_chl
                                  from dwd.dwd_sr_ad_install_referrer_log_view
                                 where dt >= '${bf_1_dt}'
                                   and dt <= '${dt}'
                                   and decrypt_data like 'ndaction:readonline%' -- 推书活动
                                   and decrypt_data like '%utm_campaign=%'
                                   and decrypt_data like '%utm_medium=%'
                               ) as a
                         where bookid > 0
                       qualify row_number() over (partition by dt, product_id, bookid, unique_cdreader_id order by create_time) = 1
                       )                                   as a
                  left join dim.dim_user_account_info_view as b
                    on a.product_id = b.product_id
                   and a.unique_cdreader_id = b.unique_cdreader_id
                   and a.chl = b.chl  -- 获取用户id
               )      as tag
          left join (-- 近7天有阅读记录的用户
                     select product_id
                          , user_id
                          , book_id
                          , create_time
                          , dt
                          , count(1)
                       from dwd.dwd_read_user_chapter_view as drucv
                      where dt >= date_sub('${dt}', interval 8 day )
                        and dt <= '${dt}'
                      group by 1, 2, 3, 4, 5
                      order by 4
                    ) as rd
            on tag.product_id = rd.product_id
           and tag.user_id = rd.user_id
           and tag.bookid = rd.book_id
           and rd.create_time < tag.create_time           -- 阅读时间要小于活动时间
           and rd.dt >= date_sub(tag.dt, interval 7 day)  -- 7天内
       )              as v
 where read_user is null
   and user_id is not null
   and cast(bookid as int ) > 0
 group by 1, 2, 3, 4, 5 , 6, 7, 8, 9, 10
;
