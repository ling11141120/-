----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_book_last_read_time
-- workflow_version : 13
-- create_user      : chenmo
-- task_name        : ads_sr_user_book_last_read_time
-- task_version     : 6
-- update_time      : 2025-04-15 16:41:46
-- sql_path         : \starrocks\tbl_ads_sr_user_book_last_read_time\ads_sr_user_book_last_read_time
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_user_book_last_read_time
select
    a.product_id,
    a.user_id,
    b.BookId as book_id,
    f.language_id,
    c.chapter_id,
    e.serial_number,
    c.create_time as last_read_time,
    d.app_id,
    ifnull(g.chapter_id, 0) as next_chapter_id,
    ifnull(g.chapter_name, 0) as next_chapter_name,
    a.dt,
    now() as etl_time
from (
    select
        product_id,
        user_id,
        max(dt) as dt
    from dws.dws_user_wide_active_period_ed
    where dt >= '${bf_1_dt}'
    group by product_id,user_id
) a
left join (
    select
        Productid,
        UserId,
        BookId
    from ods.ods_tidb_readernovel_tidb_bookshelftouser
    group by 1,2,3
) b on a.product_id = b.Productid and a.user_id = b.UserId
left join (
    select
        product_id,
        user_id,
        book_id,
        chapter_id,
        create_time
    from (
        select
            product_id,
            user_id,
            book_id,
            chapter_id,
            create_time,
            row_number() over (partition by product_id, user_id, book_id order by create_time desc) as rn
        from dwd.dwd_read_user_chapter_view
    ) chapter where rn = 1
) c on a.product_id = c.product_id and a.user_id = c.user_id and b.BookId = c.book_id
left join dim.dim_user_account_info_view d
on a.product_id = d.product_id and a.user_id = d.id
left join dim.dim_book_chapter_info e
on b.BookId = e.book_id and c.chapter_id = e.chapter_id
left join dim.dim_novel_book_info_view f
on b.BookId = f.book_id
left join dim.dim_book_chapter_info g
on b.BookId = g.book_id and (e.serial_number + 1) = g.serial_number
where b.BookId is not null and c.chapter_id is not null;
