create or replace view dim.dim_novel_book_info_view (
     product_id     comment '产品ID'
    ,book_id        comment '书籍ID'
    ,book_name      comment '书籍名称'
    ,author_name    comment '作者名称'
    ,book_length    comment '书籍字数'
    ,site_id        comment '语言id'
    ,language_id    comment '语言'
    ,build_time     comment '创建时间'
    ,introduce      comment '书籍简介'
    ,newc_id        comment '新分类ID'
    ,newc_name      comment '新分类名称'
    ,sexy2          comment '涉黄等级'
    ,sign_type      comment '签约类型'
    ,book_nature    comment '书籍性质'
) 
comment '小说书籍信息视图'
as
select a.productid     as product_id
      ,a.bookid        as book_id
      ,a.bookname      as book_name
      ,a.AuthorName    as author_name
      ,a.Length        as book_length
      ,a.SiteID        as site_id
      ,a.Language      as language_id
      ,a.BuildTime     as build_time
      ,a.introduce
      ,a.NewCID        as newc_id
      ,b.CName         as newc_name
      ,a.sexy2
      ,a.SignType      as sign_type
      ,a.BookNature    as book_nature
  from ods.ods_book_novel_book_m                                       as a
  left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new    as b
    on a.productid = b.productid
   and a.Language = b.Language
   and a.NewCID = b.CID
 where (    (a.productid = 3366 and a.Language = 3)
         or (a.productid = 3311 and a.Language = 6)
         or (a.productid = 3322 and a.Language = 5)
         or (a.productid = 3333 and a.Language = 2)
         or (a.productid = 3388 and a.Language = 4)
         or (a.productid = 3371 and a.Language = 7)
         or (a.productid = 3399 and a.Language = 9)
         or (a.productid = 3501 and a.Language = 11)
         or (a.productid = 3511 and a.Language = 12)
       )
 union all
select a.productid     as product_id
      ,a.bookid        as book_id
      ,a.bookname      as book_name
      ,a.AuthorName    as author_name
      ,a.Length        as book_length
      ,a.SiteID        as site_id
      ,a.Language      as language_id
      ,a.BuildTime     as build_time
      ,a.introduce
      ,a.NewCID        as newc_id
      ,b.CName         as newc_name
      ,a.sexy2
      ,a.SignType      as sign_type
      ,a.BookNature    as book_nature
  from ods.ods_book_novel_book_m                                       as a
  left join ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new    as b
    on a.NewCID = b.CID
   and b.Language = 3
 where a.productid = 3366
   and a.Language in (13, 14, 15, 16)
;