----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_bill_info
-- workflow_version : 1
-- create_user      : admin
-- task_name        : dim_book_bill_info
-- task_version     : 1
-- update_time      : 2023-07-14 16:22:58
-- sql_path         : \starrocks\tbl_dim_book_bill_info\dim_book_bill_info
----------------------------------------------------------------
-- SQL语句
insert overwrite dim.dim_book_bill_info
select bbi.Id,
       bbi.dt,
       bbi.bill_id,
       bbi.weight,
       ifnull(bbi.begin_time, '1970-01-01') as begin_time,
       ifnull(bbi.end_time, '9999-12-31')   as begin_time,
       bbi.free_chapter,
       bbi.lang_id,
       bbi.del_status,
       bbi.CreateTime                       as create_time,
       bbi.UpdateTime                       as update_time,
       bbi.book_id,
       bb.name,
       bb.BillType                          as bill_type,
       bb.CreateTime                        as book_bill_create_time,
       bb.UpdateTime                        as book_bill_update_time,
       current_timestamp                    as etl_time
from (
         select Id,
                dt,
                BillId      as bill_id,
                Weight      as weight,
                BeginTime   as begin_time,
                EndTime     as end_time,
                FreeChapter as free_chapter,
                LangId      as lang_id,
                DelStatus   as del_status,
                CreateTime  as CreateTime,
                UpdateTime  as UpdateTime,
                BookId      as book_id
         from ods.ods_tidb_readernovel_tidb_tag_center_book_bill_info
         where DelStatus=0
     ) bbi
         left join (
    select id, Name, BillType, CreateTime, UpdateTime
    from ods.ods_tidb_readernovel_tidb_tag_center_book_bill
) bb on bbi.bill_id = bb.id;
