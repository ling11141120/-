----------------------------------------------------------------
-- 程序功能： 消费域-英语产品线3366小说阅币收入月榜单
-- 程序名： P_ads_consume_en_book_consume_top_mf
-- 目标表： ads.ads_consume_en_book_consume_top_mf
-- 负责人： xjc
-- 开发日期：2026-05-18
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_consume_en_book_consume_top_mf
with tag as (
    select 3366                             as product_id
          ,a1.bookid
          ,group_concat(distinct a2.Tag)    as tag_name
      from ods.ods_tidb_shuangwen_tidb_xx_tagbookinfo       as a1
      left join ods.ods_tidb_shuangwen_tidb_xx_tagconfig    as a2
        on a1.tagid = a2.id
       and a1.product_id = a2.product_id
     where a1.product_id=3366
     group by 1, 2
)
, novel_book as (
    select a1.productid
          ,a1.BookID
          ,a1.BookName
          ,a1.siteid              as siteid
          ,a1.Introduce
          ,a1.StoryType
          ,a1.NewCID
          ,a2.BookId              as source_book_id
          ,a2.BookName            as source_book_name
          ,a2.bookcode            as source_book_code
          ,a1.Sexy2               as sexy
      from ods.ods_book_novel_book_m    as a1
      left join (select concat(SwBookId,ToLanguage)    as SwBookId
                       ,FromLanguage
                       ,BookId
                       ,BookName
                       ,bookcode
                       ,productid
                   from ods.ods_tidb_shuangwen_en_objectbook
                  where IsCustom=0
                    and FromLanguage = 0
                    and ToLanguage=322
                    and productid =3366
                  group by 1, 2, 3, 4, 5, 6
                )                       as a2
        on a1.BookID = a2.SwBookId
       and a1.productid = a2.productid
     where a1.siteid=322
       and a1.productid =3366
       and a1.Status !=0
)
, amount as (
    select '${dt}'    as dt
          ,a1.book_id
          ,a1.product_id
          ,a2.tag_name
          ,a3.bookname
          ,a3.siteid
          ,a3.Introduce
          ,a3.StoryType
          ,a4.CName
          ,a3.source_book_id
          ,a3.source_book_name
          ,a3.source_book_code
          ,a3.sexy
          ,sum(amount)    as revenue
      from dwd.dwd_consume_user_consume                                as a1
      left join tag                                                    as a2
        on a1.book_id = a2.bookid
       and a1.product_id = a2.product_id
      join novel_book                                                  as a3
        on a1.book_id = a3.BookID
       and a1.product_id = a3.productid
      left join ods_tidb_readernovel_tidb_en_novel_bookcategory_new    as a4
        on a3.NewCID = a4.CID
       and a4.productid=3366
       and a3.productid = a4.productid
     where a1.dt >= date_format('${bf_1_dt}', '%Y-01-01')
       and a1.dt <= '${bf_1_dt}'
       and a1.product_id=3366
       and a1.types = 1
       and a1.book_id !=0
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9 ,10 ,11, 12, 13
)
, book_info as (
    select book_id
          ,BookCode
          ,Channel
      from (select book_id
                  ,BookCode
                  ,Channel
                  ,row_number() over(partition by book_id
                                         order by if(BookCode is null, 0, 1)
                                                + if(Channel is null, 0, 1) desc
                                                 ,source_priority
                                                 ,BookCode
                                                 ,Channel
                                     )    as rn
              from (select concat(BookId,lpad(siteid,3,0))    as book_id
                          ,if(BookCode ='-' or BookCode =''
                             ,null
                             ,BookCode
                             )                                as BookCode
                          ,Channel
                          ,1                                  as source_priority
                      from ods.ods_edit_book
                     group by 1, 2, 3, 4
                     union all
                    select book_id
                          ,if(Book_Code ='-' or Book_Code =''
                             ,null
                             ,Book_Code
                             )                                as BookCode
                          ,channel                            as Channel
                          ,2                                  as source_priority
                      from dim.dim_shuangwen_book_read_consume_info
                     group by 1, 2, 3, 4
                   )    as t1
           )    as t2
     where rn = 1
)
select a1.dt                                          as dt                  -- 日期
      ,a1.product_id                                  as product_id          -- 产品id
      ,a1.book_id                                     as book_id             -- 书籍id
      ,a1.siteid                                      as site_id             -- 站点id
      ,a1.bookname                                    as book_name           -- 书籍名称
      ,a3.bookcode                                    as book_code           -- 书籍编码
      ,a1.tag_name                                    as tag_name            -- 标签名称
      ,a1.StoryType                                   as story_type          -- 故事类型
      ,a3.channel                                     as channel             -- 渠道
      ,a1.revenue                                     as revenue             -- 收入
      ,a1.Introduce                                   as introduce           -- 简介
      ,a1.CName                                       as c_name              -- 分类每次
      ,a1.source_book_id                              as source_book_id      -- 原书id
      ,a1.source_book_name                            as source_book_name    -- 原书名
      ,coalesce(a4.BookCode,a1.source_book_code)      as source_book_code    -- 原书编码
      ,row_number() over(order by a1.revenue desc
                                 ,a1.product_id
                                 ,a1.book_id
                                 ,a1.siteid
                         )                            as rn                  -- 收入排名
      ,now()                                          as etl_tm              -- 处理时间
      ,a1.sexy
  from amount            as a1
  left join book_info    as a3
    on a1.book_id = a3.book_id
  left join book_info    as a4
    on a1.source_book_id = a4.book_id
;
