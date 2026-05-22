----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : ads_user_read_bookshelftouser_last
-- task_version     : 16
-- update_time      : 2025-03-26 16:12:48
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\ads_user_read_bookshelftouser_last
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_read_bookshelftouser_last
with tmp1 as (
    select
        book_id,
        site_id2
    from dim.dim_shuangwen_book_read_consume_info
    where site_id2 != 777
    and sexy2 = 0
    and latest_update_time >= date_sub('${dt}', interval 30 day)
),

tmp2 as (
select
    a.product_id,
    a.user_id,
    a.book_id,
    b.book_id as b_book_id,
    b.site_id2
from  ads.ads_edm_user_info_ed_bookshelftouser_tmp a
left join tmp1 b
on  a.book_id = b.book_id
),
tmp3 as (
select
    product_id,
    user_id,
    Book_Id,
    site_id2,
    -- if(site_id2 = 333, 2,langid) as langid
    case when site_id2 = 333 then 2 else langid end as langid
from tmp2 c
left join dim.DIM_ProductType d
 on c.site_id2 = d.book_langid
where  b_book_id is not null
),

tmp4 as (
select
    a.product_id as product_id,
    user_id,
    a.Book_Id,
    site_id2,
    langid,
    acc.current_language as current_language
from tmp3 a
    inner join (
                    select
                    product_id,
                    id,
                    current_language
                    from
                    dim.dim_user_account_info_view
                ) acc
    on  a.product_id = acc.product_id
    and a.user_id = acc.id
),

bs as ( -- -------------------id-----
select
    product_id,
    user_id,
    Book_Id,
    site_id2,
    langid,
    current_language
from  tmp4 b
)
select date_sub('${dt}',interval 1 day ) as dt,
       Product_id,
       User_Id,
       Book_Id,
       last_read_time,current_timestamp() as etl_time
from (
         select Product_id,
                User_Id,
                Book_Id,
                last_read_time,
                row_number() over (partition by product_id,user_id order by last_read_time desc) rk
         from (
                  select bs.Product_id, bs.User_Id, bs.Book_Id, last_read_time
                  from bs
                  left join (
                                  select product_id, user_id, book_id, last_read_time
                                   from ads.ads_user_read_roll_mid
                              ) ls
                    on bs.product_id = ls.product_id
                    and bs.user_id = ls.user_id
                    and bs.book_id = ls.book_id
              ) a
         where last_read_time is not null
     )b
where rk=1;
