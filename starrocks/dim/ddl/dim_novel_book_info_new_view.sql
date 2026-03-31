create or replace view dim.dim_novel_book_info_new_view (
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
comment '小说书籍信息视图-新'
as
select a1.productid     as product_id
      ,a1.bookid        as book_id
      ,a1.bookname      as book_name
      ,a1.AuthorName    as author_name
      ,a1.Length        as book_length
      ,a1.SiteID        as site_id
      ,a1.Language      as language_id
      ,a1.BuildTime     as build_time
      ,a1.introduce     as introduce
      ,a1.NewCID        as newc_id
      ,a2.CName         as newc_name
      ,a1.sexy2         as sexy2
      ,a1.SignType      as sign_type
      ,a1.BookNature    as book_nature
  from ods.ods_book_novel_book_m                                       as a1
  left join ods.ods_tidb_readernovel_tidb_xx_novel_bookcategory_new    as a2
    on a1.productid = a2.productid
   and a1.Language = a2.Language
   and a1.NewCID = a2.CID
  join (select app_plat
              ,cd_col
              ,cd_val
              ,cd_col_desc
              ,cd_val_desc
              ,p_cd_col
              ,p_cd_col_desc
              ,if(p_cd_val=3571,3366,p_cd_val) as p_cd_val  -- 适应意大利语数据来自法语服务器，但要归属到英语服务器
              ,p_cd_desc
          from dim.dim_pub_code_mapping_dict
         where app_plat='pub'
           and cd_col='lang_cd'
       )                                                               as a3
    on a1.productid = a3.p_cd_val
   and a1.Language = a3.cd_val
   and a3.app_plat='pub'
   and a3.cd_col='lang_cd'
;
