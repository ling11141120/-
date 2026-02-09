insert into ads.ads_bi_book_coin_consume_stat
select dt
     , site_id
     , book_id
     , mt
     , if(corever is null, -99, corever) as corever
     , book_name
     , book_nature
     , book_code
     , book_dept
     , case
    /* id尾数='449' */
    when
    right (book_id
     , 3) = '449' and book_dept = '凤鸣轩' and left (book_code
     , 1) = 'A' then 'A系列'
    when right (book_id
     , 3) = '449' and book_dept = '内容编辑部' and left (book_code
     , 1) = 'P' then 'P系列'
    when right (book_id
     , 3) = '449' and left (book_code
     , 1) = 'S' then 'S系列'
    /* id尾数='446' */
    when right (book_id
     , 3) = '446' and left (book_code
     , 1) = 'J' then 'J系列'
    when right (book_id
     , 3) = '446' and left (book_code
     , 1) = 'P' then 'P系列'
    when right (book_id
     , 3) = '446' and left (book_code
     , 1) in ('R'
     , 'L') then 'R/L系列'
    when right (book_id
     , 3) = '446' and left (book_code
     , 1) = 'A' then 'A系列'
    when right (book_id
     , 3) = '446' and left (book_code
     , 1) = 'N' then 'N系列'
    /* 其余情况 */
    when left (book_code
     , 1) = 'J' then 'J系列'
    when left (book_code
     , 1) = 'P' then 'P系列'
    when left (book_code
     , 1) in ('R'
     , 'L') then 'R/L系列'
    when left (book_code
     , 1) = 'A' then 'A系列'
    when left (book_code
     , 1) = 'N' then 'N系列'
    when left (book_code
     , 1) = 'Y' then 'Y系列'
    when book_nature in (3
     , 5
     , 7) then 'Y系列'
    else '其他'
    end as book_series
     , date (build_time) as build_time
     , date (sign_time) as sign_time
     , sum(amount) as coin_amount
     , now() as etl_time
  from (select a.dt
             , a.book_id
             , a.site_id
             , a.user_id
             , b.book_nature
             , b.book_name
             , b.build_time
             , a.mt
             , a.corever
             , case
          when e.DepartmentType = 0 then '内容编辑部'
          when e.DepartmentType = 1 then '凤鸣轩'
          else ''
               end                                                                                as book_dept
             , if(a.product_id != 3333 or c.sign_time = '1970-01-01 00:00:00', null, c.sign_time) as sign_time
             , case when d.book_code is not null and d.book_code != '-' then d.book_code
                    when d.copy_book_code is not null and d.copy_book_code != '-' then d.copy_book_code
               end                                                                                as book_code
             , a.amount
          from dws.dws_consume_user_consume_ed               a
          left join dim.dim_shuangwen_book_read_consume_info b
          on a.book_id = b.book_id
          left join
          (select a.book_id, b.create_time as sign_time
             from dim.dim_shuangwen_book_read_consume_info a
             left join
             (select book_id, site_id, create_time
                from dim.dim_edit_book_view
               where product_id = 3311
              )                                            b
             on a.book_id = (b.book_id * 1000 + b.site_id)
            where a.product_id = 3333 and a.site_id = 446
            union all
           select a.book_id, b.signtime as sign_time
             from dim.dim_shuangwen_book_read_consume_info a
             left join dim.dim_zhangzhong_xzz_book_view    b
             on a.book_id = b.book_id
            where a.product_id = 3333 and a.site_id = 449 and b.book_id is not null
            union all
           select a.book_id, b.create_time as sign_time
             from dim.dim_shuangwen_book_read_consume_info a
             left join dwd.dwd_trade_fmx_book_view         b
             on a.book_id = (b.book_id * 1000 + 90)
            where a.product_id = 3333 and a.site_id = 90 and (b.book_id * 1000 + 90) is not null
           )                                                 c
          on a.book_id = c.book_id
          left join
          (select a.book_id, a.book_code, a.copy_book_id, b.book_code as copy_book_code
             from (select a.book_id, a.book_code, b.copy_book_id, a.languageid
                     from dim.dim_shuangwen_book_read_consume_info a
                     left join dim.dim_book_separate_info_view     b
                     on round(a.book_id / 1000) = b.book_id and a.languageid = b.language
                   )                                            a
             left join dim.dim_shuangwen_book_read_consume_info b
             on a.copy_book_id = round(b.book_id / 1000) and a.languageid = b.languageid
           )                                                 d
          on a.book_id = d.book_id
          left join ods.ods_mysql_zhangzhong_xzz_Book        e
          on a.book_id = (e.BookId * 1000 + e.SiteId)
         where a.dt = '${bf_1_dt}' and types = 1 and a.mt in (1, 4, 7, 9)
        ) a
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;