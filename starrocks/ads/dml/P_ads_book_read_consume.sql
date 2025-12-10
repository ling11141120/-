----------------------------------------------------------------
-- 程序功能：书籍维度阅读消耗人数
-- 程序名： P_ads_book_read_consume
-- 目标表： ads.ads_book_read_consume
-- 负责人： xjc
-- 开发日期：2025-12-05
-- 版本号：v0.0.0
----------------------------------------------------------------

insert overwrite ads.ads_book_read_consume
select a8.UpdateTime                      as dt                       -- 日期
      ,a1.book_id                         as book_id                  -- 书籍ID
      ,a1.site_id2                        as site_id2                 -- 站点ID
      ,a1.new_cid                         as new_cid                  -- 新CID
      ,a1.channel                         as channel                  -- 渠道
      ,a1.is_full                         as is_full                  -- 完结状态
      ,a1.full_time                       as full_time                -- 完结时间
      ,a1.sexy2                           as sexy2                    -- 上架状态
      ,a1.build_time                      as build_time               -- 上架时间
      ,a1.sign_type                       as sign_type                -- 签名类型
      ,a1.languageid                      as languageid               -- 书籍语言
      ,a1.public_fontlength               as public_fontlength        -- 书籍发布总字数
      ,a1.update_time                     as book_update_time         -- 书籍更新时间
      ,coalesce(a2.consume_1d,0)          as consume_1d               -- 近1日阅币加礼券消耗
      ,coalesce(a3.consume_7d,0)          as consume_7d               -- 近7日阅币加礼券消耗
      ,coalesce(a3.consume_30d,0)         as consume_30d              -- 近30日阅币加礼券消耗
      ,coalesce(a4.consume_td,0)          as consume_td               -- 历史阅币加礼券消耗
      ,coalesce(a2.full_consume_1d,0)     as full_consume_1d          -- 近1日阅币+礼券+赠送币+VIP消费消耗
      ,coalesce(a3.full_consume_7d,0)     as full_consume_7d          -- 近7日阅币+礼券+赠送币+VIP消费消耗
      ,coalesce(a3.full_consume_30d,0)    as full_consume_30d         -- 近30日阅币+礼券+赠送币+VIP消费消耗
      ,coalesce(a4.full_consume_td,0)     as full_consume_td          -- 历史阅币+礼券+赠送币+VIP消费消耗
      ,a5.read_1d                         as read_1d                  -- 近1日阅读人数
      ,a5.read_7d                         as read_7d                  -- 近7日阅读人数
      ,a5.read_30d                        as read_30d                 -- 近30日阅读人数
      ,a6.read_td                         as read_td                  -- 历史阅读人数
      ,a7.chapter_length_1d               as update_word_count_1d     -- 近1日更新字数
      ,a7.chapter_length_7d               as update_word_count_7d     -- 近7日更新字数
      ,a7.chapter_length_30d              as update_word_count_30d    -- 近30日更新字数
      ,now()                              as etl_time                 -- etl清洗时间
      ,a1.book_nature                     as book_nature              -- 书籍来源
      ,a9.Score                           as score_type               -- 书籍评分
  from (select book_id
              ,site_id2
              ,new_cid
              ,channel
              ,is_full
              ,full_time
              ,sexy2
              ,build_time
              ,sign_type
              ,languageid
              ,public_fontlength
              ,book_nature
              ,'SyncBi_ads_book_read_consume'                                 as tn
              ,if(update_time is null, '1970-01-01 00:00:00', update_time)    as update_time
          from dim.dim_shuangwen_book_read_consume_info
         where sexy2 = 0
       )    as a1
  left join (select book_id
                   ,site_id
                   ,sum(consume_1d)        as consume_1d
                   ,sum(full_amount_1d)    as full_consume_1d
               from (select book_id
                           ,if(site_id in (775, 885), 777, site_id)    as site_id
                           ,if(types in (1, 2), amount, 0)             as consume_1d
                           ,amount                                     as full_amount_1d
                       from dws.dws_consume_book_consume_ed
                      where dt = date_sub('${dt}', interval 1 day)
                        and types in (1, 2, 3, 4)
                    )    as b1
              group by 1, 2
            )    as a2
    on a1.site_id2 = a2.site_id
   and a1.book_id = a2.book_id
  left join (select book_id
                   ,site_id
                   ,sum(if(dt >= date_sub('${dt}', interval 7 day) and types in (1, 2), amount, 0))    as consume_7d
                   ,sum(if(types in (1, 2),amount,0))                                                  as consume_30d
                   ,sum(if(dt >= date_sub('${dt}', interval 7 day), amount, 0))                        as full_consume_7d
                   ,sum(amount)                                                                        as full_consume_30d
               from dws.dws_consume_book_consume_ed
              where dt >= date_sub('${dt}', interval 30 day)
                and dt < '${dt}'
                and types in (1, 2, 3, 4)
              group by 1, 2
            )    as a3
    on a1.site_id2 = a3.site_id
   and a1.book_id = a3.book_id
  left join (select book_id
                   ,site_id
                   ,sum(consume_td)         as consume_td
                   ,sum(full_consume_td)    as full_consume_td
               from (select book_id
                           ,if(site_id in (775, 885), 777, site_id)    as site_id
                           ,if(types in (1, 2), consume_td,0)          as consume_td
                           ,consume_td                                 as full_consume_td
                       from dws.dws_consume_book_consume_a
                      where dt = '${dt}'
                        and types in (1, 2, 3, 4)
                    )    as b1
              group by 1, 2
            )    as a4
    on a1.site_id2 = a4.site_id
   and a1.book_id = a4.book_id
  left join (select book_id
                   ,site_id
                   ,count(distinct if (dt>=date_sub('${dt}',interval 1 day ),user_id,null))    as read_1d
                   ,count(distinct if (dt>=date_sub('${dt}',interval 7 day ),user_id,null))    as read_7d
                   ,count(distinct user_id)                                                    as read_30d
               from (select dt
                           ,if(site_id = 775 or site_id=885, 777, site_id)    as site_id
                           ,book_id
                           ,user_id
                       from dws.dws_read_user_readbook_ed
                      where dt>=date_sub('${dt}',interval 30 day )
                        and dt<'${dt}'
                    )    as b1
              group by 1, 2
            )    as a5
    on a1.site_id2 = a5.site_id
   and a1.book_id = a5.book_id
  left join (select book_id
                   ,site_id
                   ,bitmap_count(user_id)    as read_td
               from dws.dws_read_book_a
              where dt = '${dt}'
            )    as a6
    on a1.site_id2 = a6.site_id
   and a1.book_id = a6.book_id
  left join (select book_id
                   ,site_id
                   ,chapter_length_1d
                   ,chapter_length_7d
                   ,chapter_length_30d
               from dws.dws_content_book_chapter_length
              where dt = '${dt}'
            )    as a7
    on a1.site_id2 = a7.site_id
   and a1.book_id = a7.book_id
  left join (select TableName
                   ,UpdateTime
               from ads.ads_SyncBi_update_status
              where TableName = 'SyncBi_ads_book_read_consume'
              limit 1
            )    as a8
    on a1.tn = a8.TableName
  left join ods.ods_tidb_readernovel_tidb_tag_center_book_information    as a9
    on a1.book_id = a9.BookId
   and a1.languageid = a9.LangId
;


insert into ads.ads_book_read_consume
with orginal_bookid_map as (
    select a1.dt
          ,a1.book_id
          ,a1.site_id
          ,a1.new_cid
          ,a1.channel
          ,a1.is_full
          ,a1.full_time
          ,a1.sexy2
          ,a1.build_time
          ,a1.sign_type
          ,a1.languageid
          ,a1.public_fontlength
          ,a1.book_update_time
          ,a1.consume_1d
          ,a1.consume_7d
          ,a1.consume_30d
          ,a1.consume_td
          ,a1.full_consume_1d
          ,a1.full_consume_7d
          ,a1.full_consume_30d
          ,a1.full_consume_td
          ,a1.read_1d
          ,a1.read_7d
          ,a1.read_30d
          ,a1.read_td
          ,a1.update_word_count_1d
          ,a1.update_word_count_7d
          ,a1.update_word_count_30d
          ,a1.etl_time
          ,a1.book_nature
          ,a1.score_type
          ,a2.orginalbookid    as orginal_book_id
      from ads.ads_book_read_consume                        as a1
      left join ods.ods_readernovel_cnaborad_BookMapping    as a2
        on a1.book_id = (a2.mappedbookid * 1000 + 491)
      where a1.site_id = 491
)
, chapter_length as (
    select book_id
          ,site_id
          ,chapter_length_1d
          ,chapter_length_7d
          ,chapter_length_30d
      from dws.dws_content_book_chapter_length
     where dt = '${dt}'
       and site_id = 777
)
select a1.dt                    as dt                    -- 日期
      ,a1.book_id               as book_id               -- 书籍id
      ,a1.site_id               as site_id               -- 书籍语言
      ,a1.new_cid               as new_cid               -- 书籍分类id
      ,a1.channel               as channel               -- 频道
      ,a1.is_full               as is_full               -- 完结状态
      ,a1.full_time             as full_time             -- 完结时间
      ,a1.sexy2                 as sexy2                 -- 上架状态
      ,a1.build_time            as build_time            -- 上架时间
      ,a1.sign_type             as sign_type             -- 签约状态
      ,a1.languageid            as languageid            -- 书籍语言
      ,a1.public_fontlength     as public_fontlength     -- 书籍发布总字数
      ,a1.book_update_time      as book_update_time      -- 书籍更新时间
      ,a1.consume_1d            as consume_1d            -- 近1日阅币加礼券消耗
      ,a1.consume_7d            as consume_7d            -- 近7日阅币加礼券消耗
      ,a1.consume_30d           as consume_30d           -- 近30日阅币加礼券消耗
      ,a1.consume_td            as consume_td            -- 历史阅币加礼券消耗
      ,a1.full_consume_1d       as full_consume_1d       -- 近1日完结阅币加礼券消耗
      ,a1.full_consume_7d       as full_consume_7d       -- 近7日完结阅币加礼券消耗
      ,a1.full_consume_30d      as full_consume_30d      -- 近30日完结阅币加礼券消耗
      ,a1.full_consume_td       as full_consume_td       -- 历史完结阅币加礼券消耗
      ,a1.read_1d               as read_1d               -- 近1日阅读人数
      ,a1.read_7d               as read_7d               -- 近7日阅读人数
      ,a1.read_30d              as read_30d              -- 近30日阅读人数
      ,a1.read_td               as read_td               -- 历史阅读人数
      ,a2.chapter_length_1d     as chapter_length_1d     -- 近1日章节长度
      ,a2.chapter_length_7d     as chapter_length_7d     -- 近7日章节长度
      ,a2.chapter_length_30d    as chapter_length_30d    -- 近30日章节长度
      ,a1.etl_time              as etl_time              -- etl清洗时间
      ,a1.book_nature           as book_nature           -- 书籍来源
      ,a1.score_type            as score_type            -- 书籍评分类型
  from orginal_bookid_map       as a1
  left join chapter_length      as a2
    on a1.orginal_book_id = a2.book_id
;