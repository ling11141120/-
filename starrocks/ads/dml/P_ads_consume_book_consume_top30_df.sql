----------------------------------------------------------------
-- 程序功能：书籍维度近14天合计消费（礼券 / VIP/SVIP/ 阅币等）TOP30
-- 程序名： P_ads_consume_book_14d_top30_df
-- 目标表： ads.ads_consume_book_14d_top30_df
-- 负责人： xjc
-- 开发日期：2025-12-08
-- 版本号：v0.0.0
----------------------------------------------------------------

insert into ads.ads_consume_book_consume_top30_df
with t1 as (
    select a1.product_id
          ,a1.book_id
          ,a1.StoryType
          ,a1.language_id
          ,a1.language_name
          ,a1.consume_14d
         ,row_number() over (partition by a1.language_id, a1.StoryType order by consume_14d desc)    as rn
      from (select b1.product_id
                  ,b1.book_id
                  ,b3.StoryType
                  ,b1.languageid     as language_id
                  ,b4.cd_val_desc    as language_name
                  ,sum(b2.amount)    as consume_14d
              from dim.dim_shuangwen_book_read_consume_info    as b1
              join dws.dws_consume_book_consume_ed             as b2
                on b1.book_id = b2.book_id
               and b1.site_id = b2.site_id
              left join ods.ods_book_novel_book_m              as b3
                on b1.product_id = b3.productid
               and b1.book_id = b3.bookid
              left join dim.dim_pub_code_mapping_dict          as b4
                on b1.languageid = b4.cd_val
               and b4.cd_col = 'lang_cd'
               and b4.app_plat='pub'
             where b2.dt >= date_sub('${dt}', interval 14 day)
               and b2.dt < '${dt}'
               and b2.types in (1, 2, 3, 4)
               and b1.sexy2 = 0
             group by 1, 2, 3, 4, 5
           )    as a1
)
select '${dt}'             as dt                 -- 日期
      ,a1.product_id       as product_id         -- 产品id
      ,a1.book_id          as book_id            -- 书籍id
      ,a1.language_id      as language_id        -- 语言id
      ,a1.StoryType        as story_type_id      -- 书籍类型id
      ,a1.language_name    as language_name      -- 语言名称
      ,case when a1.StoryType=0 then '长篇'
            when a1.StoryType=1 then '短篇'
            else null
        end                as story_type_name    -- 书籍类型名称
      ,a1.consume_14d      as consume_14d        -- 近14天合计消费
      ,a1.rn               as desc_rank          -- 倒序排名
      ,now()               as etl_time           -- etl清洗时间
  from t1    as a1
 where a1.rn<=30
;