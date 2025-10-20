insert into ads.ads_bi_book_coin_consume_stat
select
    dt,site_id,book_id,
    mt,if(corever is null,-99,corever) as corever,book_name,
    book_nature,book_code,book_dept,
    CASE
        /* id尾数='449' */
        WHEN RIGHT(book_id, 3) = '449' AND book_dept = '凤鸣轩' AND LEFT(book_code, 1) = 'A' THEN 'A系列'
        WHEN RIGHT(book_id, 3) = '449' AND book_dept = '内容编辑部' AND LEFT(book_code, 1) = 'P' THEN 'P系列'
        WHEN RIGHT(book_id, 3) = '449' AND LEFT(book_code, 1) = 'S' THEN 'S系列'
        /* id尾数='446' */
        WHEN RIGHT(book_id, 3) = '446' AND LEFT(book_code, 1) = 'J' THEN 'J系列'
        WHEN RIGHT(book_id, 3) = '446' AND LEFT(book_code, 1) = 'P' THEN 'P系列'
        WHEN RIGHT(book_id, 3) = '446' AND LEFT(book_code, 1) IN ('R', 'L') THEN 'R/L系列'
        WHEN RIGHT(book_id, 3) = '446' AND LEFT(book_code, 1) = 'A' THEN 'A系列'
        WHEN RIGHT(book_id, 3) = '446' AND LEFT(book_code, 1) = 'N' THEN 'N系列'
        /* 其余情况 */
        WHEN LEFT(book_code, 1) = 'J' THEN 'J系列'
        WHEN LEFT(book_code, 1) = 'P' THEN 'P系列'
        WHEN LEFT(book_code, 1) IN ('R', 'L') THEN 'R/L系列'
        WHEN LEFT(book_code, 1) = 'A' THEN 'A系列'
        WHEN LEFT(book_code, 1) = 'N' THEN 'N系列'
        WHEN LEFT(book_code, 1) = 'Y' THEN 'Y系列'
        WHEN book_nature IN (3, 5, 7) THEN 'Y系列'
        ELSE '其他'
    END AS book_series,
    date(build_time) as build_time,date(sign_time) as sign_time,
    sum(amount) as coin_amount,
    now() as etl_time
  from (select a.dt
              ,a.book_id,a.site_id,a.user_id,b.book_nature,b.book_name,b.build_time,a.mt,a.corever
              ,CASE WHEN e.DepartmentType = 0 THEN '内容编辑部'
                    WHEN e.DepartmentType = 1 THEN '凤鸣轩'
                    ELSE ''
                END AS book_dept
              ,if(a.product_id != 3333 or c.sign_time = '1970-01-01 00:00:00',null,c.sign_time) as sign_time,
              case when d.book_code is not null and d.book_code != '-' then d.book_code
              when d.copy_book_code is not null and d.copy_book_code != '-' then d.copy_book_code
              end as book_code,a.amount
          from dws.dws_consume_user_consume_ed a
          left join dim.dim_shuangwen_book_read_consume_info b
            on a.book_id = b.book_id
          left join (select a.book_id,b.create_time as sign_time
                       from dim.dim_shuangwen_book_read_consume_info a
                       left join (select book_id,site_id,create_time
                                    from dim.dim_edit_book_view
                                   where product_id = 3311
                                 ) b
                         on a.book_id = (b.book_id*1000+b.site_id)
                      where a.product_id = 3333 and a.site_id = 446
                      union all
                     select a.book_id,b.signtime as sign_time
                       from dim.dim_shuangwen_book_read_consume_info a
                       left join dim.dim_zhangzhong_xzz_book_view b
                         on a.book_id = b.book_id
                      where a.product_id = 3333 and a.site_id = 449 and  b.book_id is not null
                      union all
                     select a.book_id,b.create_time as sign_time
                       from dim.dim_shuangwen_book_read_consume_info a
                       left join dwd.dwd_trade_fmx_book_view b
                         on a.book_id = (b.book_id*1000+90)
                      where a.product_id = 3333 and a.site_id = 90 and  (b.book_id*1000+90) is not null
                    ) c
            on a.book_id = c.book_id
          left join (select a.book_id,a.book_code,a.copy_book_id,b.book_code as copy_book_code
                       from (select  a.book_id,a.book_code,b.copy_book_id,a.languageid
                               from dim.dim_shuangwen_book_read_consume_info a
                               left join dim.dim_book_separate_info_view b
                                 on  round(a.book_id/1000) = b.book_id and a.languageid = b.language
                            ) a
                       left join dim.dim_shuangwen_book_read_consume_info b
                         on a.copy_book_id = round(b.book_id/1000) and a.languageid = b.languageid
                    ) d
            on a.book_id = d.book_id
          LEFT JOIN ods.ods_mysql_zhangzhong_xzz_Book e
            on a.book_id = (e.BookId*1000 + e.SiteId)
         where a.dt = '${bf_1_dt}' and types = 1 and a.mt in (1,4,7,9)
       ) a
 group by 1,2,3,4,5,6,7,8,9,10,11,12;