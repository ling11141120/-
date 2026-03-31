----------------------------------------------------------------
-- 程序功能： 小说书籍信息表
-- 程序名： P_ads_syncbi_book_newcid_rank_info
-- 目标表： ads.ads_syncbi_book_newcid_rank_info
-- 负责人： xjc
-- 开发日期： 2026-03-31
----------------------------------------------------------------

insert into ads.ads_syncbi_book_newcid_rank_info
-- ----------------yesterday ---------------------
select '${bf_1_dt}'                                   as dt
      ,1                                              as time_types
      ,a1.language_id
      ,a1.book_id
      ,a1.book_name
      ,a1.introduce
      ,a1.newc_id
      ,a1.newc_name
      ,a1.sign_type
      ,now()                                          as etl_time
      ,a1.build_time
      ,a1.author_name
      ,group_concat(tag order by tag separator ', ')  as tag
  from (select product_id
              ,language_id
              ,b1.book_id
              ,book_name
              ,introduce
              ,newc_id
              ,newc_name
              ,sign_type
              ,build_time
              ,author_name
              ,row_number() over (partition by language_id, newc_id order by date(build_time) desc, if(sign_type = -1, 4, sign_type)) as ranks
          from dim.dim_novel_book_info_new_view       as b1
          left join (select distinct c1.book_id
                       from dim.dim_tag_book_info_view      as c1
                      where c1.tag_id in (select d1.id
                                            from dim.dim_tag_config_view        as d1
                                           where d1.is_delete = 0
                                             and (d1.tag like '%18%' or d1.tag like '%19%')
                                             and d1.site_id not in (409, 410, 418, 433, 414, 0, 446, 450)
                                         )
                        and c1.is_delete = 0
                    )                               as b2
            on b1.book_id = b2.book_id
         where b1.build_time >= '${bf_1_dt}'
           and b1.build_time < '${dt}'
           and b1.sign_type in (0, 1, 2, -1)
           and b1.sexy2 = 0
           and b1.newc_id in (20007, 20008, 20005, 20010, 20011, 20012, 10005, 10003, 10001)
           and b1.product_id != 3333
           and b2.book_id is null
       )                                              as a1
  left join (select b1.product_id
                   ,b1.tag_id
                   ,b1.book_id
               from dim.dim_tag_book_info_view        as b1
              where b1.is_delete = 0
            )                                         as a2
    on a1.product_id = a2.product_id
   and a1.book_id = a2.book_id
  left join (select b1.product_id
                   ,b1.id
                   ,b1.tag
               from dim.dim_tag_config_view           as b1
              where b1.is_delete = 0
            )                                         as a3
    on a2.product_id = a3.product_id
   and a2.tag_id = a3.id
 where a1.ranks <= 20
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

 union all

-- ----------3333------yesterday ---------------------
select '${bf_1_dt}'                                   as dt
      ,1                                              as time_types
      ,a1.language_id
      ,a1.book_id
      ,a1.book_name
      ,a1.introduce
      ,a1.newc_id
      ,a1.newc_name
      ,a1.sign_type
      ,now()                                          as etl_time
      ,a1.build_time
      ,a1.author_name
      ,group_concat(tag order by tag separator ', ')  as tag
  from (select product_id
              ,language_id
              ,b1.book_id
              ,book_name
              ,introduce
              ,newc_id
              ,newc_name
              ,if(sign_type is null, 9999, sign_type) as sign_type
              ,build_time
              ,author_name
              ,row_number() over (partition by language_id, newc_id order by build_time desc) as ranks
          from dim.dim_novel_book_info_new_view       as b1
          left join (select distinct c1.book_id
                       from dim.dim_tag_book_info_view      as c1
                      where c1.tag_id in (select d1.id
                                            from dim.dim_tag_config_view        as d1
                                           where d1.is_delete = 0
                                             and (d1.tag like '%18%' or d1.tag like '%19%')
                                             and d1.site_id not in (409, 410, 418, 433, 414, 0, 446, 450)
                                         )
                        and c1.is_delete = 0
                    )                               as b2
            on b1.book_id = b2.book_id
         where b1.build_time >= '${bf_1_dt}'
           and b1.build_time < '${dt}'
           and b1.sexy2 = 0
           and b1.newc_id in (20002, 20011, 20007, 20008, 20014, 21001, 10002, 10001, 10008)
           and b1.product_id = 3333
           and b2.book_id is null
       )                                              as a1
  left join (select b1.product_id
                   ,b1.tag_id
                   ,b1.book_id
               from dim.dim_tag_book_info_view        as b1
              where b1.is_delete = 0
            )                                         as a2
    on a1.product_id = a2.product_id
   and a1.book_id = a2.book_id
  left join (select b1.product_id
                   ,b1.id
                   ,b1.tag
               from dim.dim_tag_config_view           as b1
              where b1.is_delete = 0
            )                                         as a3
    on a2.product_id = a3.product_id
   and a2.tag_id = a3.id
 where a1.ranks <= 20
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

 union all

-- ------------history---------------------------------
select '${bf_1_dt}'                                   as dt
      ,2                                              as time_types
      ,a1.language_id
      ,a1.book_id
      ,a1.book_name
      ,a1.introduce
      ,a1.newc_id
      ,a1.newc_name
      ,a1.sign_type
      ,now()                                          as etl_time
      ,a1.build_time
      ,a1.author_name
      ,group_concat(tag order by tag separator ', ')  as tag
  from (select product_id
              ,language_id
              ,b1.book_id
              ,book_name
              ,introduce
              ,newc_id
              ,newc_name
              ,sign_type
              ,build_time
              ,author_name
              ,row_number() over (partition by language_id, newc_id order by date(build_time) desc, if(sign_type = -1, 4, sign_type)) as ranks
          from dim.dim_novel_book_info_new_view       as b1
          left join (select distinct c1.book_id
                       from dim.dim_tag_book_info_view      as c1
                      where c1.tag_id in (select d1.id
                                            from dim.dim_tag_config_view        as d1
                                           where d1.is_delete = 0
                                             and (d1.tag like '%18%' or d1.tag like '%19%')
                                             and d1.site_id not in (409, 410, 418, 433, 414, 0, 446, 450)
                                         )
                        and c1.is_delete = 0
                    )                               as b2
            on b1.book_id = b2.book_id
         where b1.build_time >= date_sub('${dt}', interval 1 year)
           and b1.build_time < '${dt}'
           and b1.sign_type in (0, 1, 2, -1)
           and b1.sexy2 = 0
           and b1.newc_id in (20007, 20008, 20005, 20010, 20011, 20012, 10005, 10003, 10001)
           and b1.product_id != 3333
           and b2.book_id is null
       )                                              as a1
  left join (select b1.product_id
                   ,b1.tag_id
                   ,b1.book_id
               from dim.dim_tag_book_info_view        as b1
              where b1.is_delete = 0
            )                                         as a2
    on a1.product_id = a2.product_id
   and a1.book_id = a2.book_id
  left join (select b1.product_id
                   ,b1.id
                   ,b1.tag
               from dim.dim_tag_config_view           as b1
              where b1.is_delete = 0
            )                                         as a3
    on a2.product_id = a3.product_id
   and a2.tag_id = a3.id
 where a1.ranks <= 20
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

 union all

-- -------3333-----history---------------------------------
select '${bf_1_dt}'                                   as dt
      ,2                                              as time_types
      ,a1.language_id
      ,a1.book_id
      ,a1.book_name
      ,a1.introduce
      ,a1.newc_id
      ,a1.newc_name
      ,a1.sign_type
      ,now()                                          as etl_time
      ,a1.build_time
      ,a1.author_name
      ,group_concat(tag order by tag separator ', ')  as tag
  from (select product_id
              ,language_id
              ,b1.book_id
              ,book_name
              ,introduce
              ,newc_id
              ,newc_name
              ,if(sign_type is null, 9999, sign_type) as sign_type
              ,build_time
              ,author_name
              ,row_number() over (partition by language_id, newc_id order by build_time desc) as ranks
          from dim.dim_novel_book_info_new_view       as b1
          left join (select distinct c1.book_id
                       from dim.dim_tag_book_info_view      as c1
                      where c1.tag_id in (select d1.id
                                            from dim.dim_tag_config_view        as d1
                                           where d1.is_delete = 0
                                             and (d1.tag like '%18%' or d1.tag like '%19%')
                                             and d1.site_id not in (409, 410, 418, 433, 414, 0, 446, 450)
                                         )
                        and c1.is_delete = 0
                    )                               as b2
            on b1.book_id = b2.book_id
         where b1.build_time >= date_sub('${dt}', interval 1 year)
           and b1.build_time < '${dt}'
           and b1.sexy2 = 0
           and b1.newc_id in (20002, 20011, 20007, 20008, 20014, 21001, 10002, 10001, 10008)
           and b1.product_id = 3333
           and b2.book_id is null
       )                                              as a1
  left join (select b1.product_id
                   ,b1.tag_id
                   ,b1.book_id
               from dim.dim_tag_book_info_view        as b1
              where b1.is_delete = 0
            )                                         as a2
    on a1.product_id = a2.product_id
   and a1.book_id = a2.book_id
  left join (select b1.product_id
                   ,b1.id
                   ,b1.tag
               from dim.dim_tag_config_view           as b1
              where b1.is_delete = 0
            )                                         as a3
    on a2.product_id = a3.product_id
   and a2.tag_id = a3.id
 where a1.ranks <= 20
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
;