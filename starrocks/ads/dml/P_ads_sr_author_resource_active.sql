----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_author_resource_active
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sr_author_resource_active
-- task_version     : 4
-- update_time      : 2026-01-27 14:56:43
-- sql_path         : \starrocks\tbl_ads_sr_author_resource_active\ads_sr_author_resource_active
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_author_resource_active
select
    date(a.create_time) as dt,
    a.product_id,
    a.book_id * 1000 + site_id as book_id,
    a.site_id,
    a.book_nature,
    a.author_id,
    b.AuthorName,
    c.UserId,
    d.UserId,
    d.InUse,
    b.CheckStatus,
    b.ApplyTime,
    b.ContractStartTime as contract_start_time,
    b.ContractEndTime as contract_end_time,
    b.IsSign,
    b.SignType,
    a.is_putdown,
    e.public_time,
    now() as etl_time
from dim.dim_edit_book_view a
left join ods.ods_tidb_shuangwen_xx_authorapply b
on a.product_id = b.ProductId and a.book_id = b.BookId
left join (
    select
        ProductId,
        BookId,
        UserId
    from ods.ods_tidb_shuangwen_xx_bookeditorright
    where EditorType = 0 and InUse = 1
) c
on a.product_id = c.ProductId and a.book_id = c.BookId
left join (
    select
        ProductId,
        BookId,
        UserId,
        InUse
    from ods.ods_tidb_shuangwen_xx_bookeditorright
    where EditorType = 1 and InUse = 1
) d
on a.product_id = d.ProductId and a.book_id = d.BookId
left join (
    select
        book_id,
        min(public_time) as public_time
    from dim.dim_book_chapter_info
    where serial_number = 1
    group by book_id
) e on a.book_id * 1000 + site_id = e.book_id;
