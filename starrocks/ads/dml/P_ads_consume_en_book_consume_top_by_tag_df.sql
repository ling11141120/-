----------------------------------------------------------------
-- 程序功能： 消费域-英语产品线3366小说阅币收入标签维度榜单
-- 程序名： P_ads_consume_en_book_consume_top_by_tag_df
-- 目标表： ads.ads_consume_en_book_consume_top_by_tag_df
-- 负责人： xjc
-- 开发日期：2026-03-11
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_consume_en_book_consume_top_by_tag_df
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
     union all
    select 3333                             as product_id
          ,a1.bookid
          ,group_concat(distinct a2.Tag)    as tag_name
     from ods.ods_mysql_zhangzhong_xzz_tagbookinfo       as a1
     left join ods.ods_mysql_zhangzhong_xzz_tagconfig    as a2
       on a1.tagid = a2.id
    /*where a1.isdelete=0
      and a2.isdelete=0*/
    group by 1, 2
)
, novel_book as (
    select a1.productid
          ,a1.BookID
          ,a1.BookName
          ,lpad(a1.siteid,3,0)    as siteid
          ,a1.Introduce
          ,a1.StoryType
          ,a1.NewCID
          ,a2.BookId              as source_book_id
          ,a2.BookName            as source_book_name
          ,a2.bookcode            as source_book_code
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
     where lpad(a1.siteid,3,0) in('322','449','090')
       and a1.productid in(3366,3333)
)
, amount as (
    select a1.dt
          ,a1.book_id
          ,a2.tag_name
          ,a3.bookname
          ,a3.siteid
          ,a3.Introduce
          ,a3.StoryType
          ,a4.CName
          ,a3.source_book_id
          ,a3.source_book_name
          ,a3.source_book_code
          ,sum(amount)    as revenue
      from dwd.dwd_consume_user_consume                                as a1
      left join tag                                                    as a2
        on a1.book_id = a2.bookid
       and a1.product_id = a2.product_id
      join novel_book                                                  as a3
        on a1.book_id = a3.BookID
       and a1.product_id = a3.productid
      left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new    as a4
        on a3.NewCID = a4.CID
       and a4.productid in(3366,3333)
       and a3.productid = a4.productid
     where a1.dt = '${bf_1_dt}'
       and a1.product_id in(3366,3333)
       and a1.types = 1
       and a1.book_id !=0
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9 ,10 ,11
)
select a1.dt                                        as dt                  -- 日期
      ,1                                            as top_flag            -- 日榜:1,历史总榜:2
      ,a1.book_id                                   as book_id             -- 书籍id
      ,a1.bookname                                  as book_name           -- 书籍名称
      ,a3.bookcode                                  as book_code           -- 书籍编码
      ,a1.tag_name                                  as tag_name            -- 标签名称
      ,a1.StoryType                                 as story_type          -- 故事类型
      ,date_add(a1.dt,1)                            as show_date           -- 展示日期
      ,a1.siteid                                    as site_id             -- 站点id
      ,a3.channel                                   as channel             -- 渠道
      ,a1.revenue                                   as revenue             -- 收入
      ,a1.Introduce                                 as introduce           -- 简介
      ,now()                                        as etl_tm              -- 处理时间
      ,a1.CName                                     as c_name              -- 语言
      ,a1.source_book_id                            as source_book_id      -- 原书id
      ,a1.source_book_name                          as source_book_name    -- 原书名
      ,coalesce(a4.BookCode,a1.source_book_code)    as source_book_code    -- 原书编码
  from amount    as a1
  left join (select concat(BookId,lpad(siteid,3,0))    as book_id
                   ,if(BookCode ='-' or BookCode =''
                      ,null
                      ,BookCode
                      )                                as BookCode
                   ,Channel
              from ods.ods_edit_book
             group by 1, 2, 3
             union
             select
                   book_id
                  ,if(Book_Code ='-' or Book_Code =''
                     ,null
                     ,Book_Code
                     )                                 as Book_Code
                  ,channel
              from dim.dim_shuangwen_book_read_consume_info
             group by 1, 2, 3
            )   as a3
    on a1.book_id = a3.book_id
  left join (select concat(BookId,lpad(siteid,3,0))    as book_id
                   ,if(BookCode ='-' or BookCode =''
                      ,null
                      ,BookCode
                      )                                as BookCode
                   ,Channel
              from ods.ods_edit_book
             group by 1, 2, 3
             union
             select
                   book_id
                  ,if(Book_Code ='-' or Book_Code =''
                     ,null
                     ,Book_Code
                     )                                 as Book_Code
                  ,channel
              from dim.dim_shuangwen_book_read_consume_info
             group by 1, 2, 3
            )   as a4
    on a1.source_book_id = a4.book_id
;




insert into ads.ads_consume_en_book_consume_top_by_tag_df
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
     union all
    select 3333                             as product_id
          ,a1.bookid
          ,group_concat(distinct a2.Tag)    as tag_name
     from ods.ods_mysql_zhangzhong_xzz_tagbookinfo       as a1
     left join ods.ods_mysql_zhangzhong_xzz_tagconfig    as a2
       on a1.tagid = a2.id
    /*where a1.isdelete=0
      and a2.isdelete=0*/
    group by 1, 2
)
, novel_book as (
    select a1.productid
          ,a1.BookID
          ,a1.BookName
          ,lpad(a1.siteid,3,0)    as siteid
          ,a1.Introduce
          ,a1.StoryType
          ,a1.NewCID
          ,a2.BookId              as source_book_id
          ,a2.BookName            as source_book_name
          ,a2.bookcode            as source_book_code
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
     where lpad(a1.siteid,3,0) in('322','449','090')
       and a1.productid in(3366,3333)
)
, base_consume as (
    select product_id
          ,book_id
          ,sum(amount)  as revenue
      from dwd.dwd_consume_user_consume
     where types = 1
       and book_id != 0
       and product_id in (3366, 3333)
     group by 1, 2
)
, top_100_consume as (
select product_id
      ,book_id
      ,revenue
      ,bookname
      ,siteid
      ,Introduce
      ,StoryType
      ,NewCID
      ,source_book_id
      ,source_book_name
      ,source_book_code
      ,rn
from (select b1.product_id
            ,b1.book_id
            ,b1.revenue
            ,b2.bookname
            ,b2.siteid
            ,b2.Introduce
            ,b2.StoryType
            ,b2.NewCID
            ,b2.source_book_id
            ,b2.source_book_name
            ,b2.source_book_code
            ,row_number() over (partition by b1.product_id order by b1.revenue desc) as rn
        from base_consume as b1
        join novel_book   as b2
          on b1.book_id = b2.BookID
         and b1.product_id = b2.productid
     )    as a1
where rn <= 100
)
select '${bf_1_dt}'                                 as dt                  -- 日期
      ,2                                            as top_flag            -- 日榜:1,历史总榜:2
      ,a1.book_id                                   as book_id             -- 书籍id
      ,a1.bookname                                  as book_name           -- 书籍名称
      ,a3.bookcode                                  as book_code           -- 书籍编码
      ,a5.tag_name                                  as tag_name            -- 标签名称
      ,a1.StoryType                                 as story_type          -- 故事类型
      ,date_add('${bf_1_dt}',1)                     as show_date           -- 展示日期
      ,a1.siteid                                    as site_id             -- 站点id
      ,a3.channel                                   as channel             -- 渠道
      ,a1.revenue                                   as revenue             -- 收入
      ,a1.Introduce                                 as introduce           -- 简介
      ,now()                                        as etl_tm              -- 处理时间
      ,a6.CName                                     as c_name              -- 语言
      ,a1.source_book_id                            as source_book_id      -- 原书id
      ,a1.source_book_name                          as source_book_name    -- 原书名
      ,coalesce(a4.BookCode,a1.source_book_code)    as source_book_code    -- 原书编码
  from top_100_consume    as a1
  left join (select concat(BookId,lpad(siteid,3,0))    as book_id
                   ,if(BookCode ='-' or BookCode =''
                      ,null
                      ,BookCode
                      )                                as BookCode
                   ,Channel
              from ods.ods_edit_book
             group by 1, 2, 3
             union
             select
                   book_id
                  ,if(Book_Code ='-' or Book_Code =''
                     ,null
                     ,Book_Code
                     )                                 as Book_Code
                  ,channel
              from dim.dim_shuangwen_book_read_consume_info
             group by 1, 2, 3
            )   as a3
    on a1.book_id = a3.book_id
  left join (select concat(BookId,lpad(siteid,3,0))    as book_id
                   ,if(BookCode ='-' or BookCode =''
                      ,null
                      ,BookCode
                      )                                as BookCode
                   ,Channel
              from ods.ods_edit_book
             group by 1, 2, 3
             union
             select
                   book_id
                  ,if(Book_Code ='-' or Book_Code =''
                     ,null
                     ,Book_Code
                     )                                 as Book_Code
                  ,channel
              from dim.dim_shuangwen_book_read_consume_info
             group by 1, 2, 3
            )   as a4
    on a1.source_book_id = a4.book_id
  left join tag                                                    as a5
    on a1.book_id = a5.bookid
   and a1.product_id = a5.product_id
  left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new    as a6
    on a1.NewCID = a6.CID
   and a6.productid in(3366,3333)
   and a1.product_id = a6.productid
;
