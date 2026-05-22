----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_read_book_read_book_readtime
-- workflow_version : 7
-- create_user      : zhengtt
-- task_name        : dwd_read_book_read_book_readtime
-- task_version     : 6
-- update_time      : 2024-01-06 17:39:26
-- sql_path         : \starrocks\tbl_dwd_read_book_read_book_readtime\dwd_read_book_read_book_readtime
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_read_book_read_book_readtime where dt  <= '${bf_1_dt}' and  dt  >= '${bf_15_dt}';

-- SQL语句
insert into dwd.dwd_read_book_read_book_readtime
select  dt, product_id, UserId,BookId,1 as data_type, MT, AppId,CreateTime, Time,now() as etl_time
from ods_log.ods_tidb_readerlog_log_readtimelog
where dt >= '${bf_15_dt}' and dt <= '${bf_1_dt}'
and bookid is not null and ifnull(userid+0,null) is not null  and ifnull(bookid+0,null) is not null  and length(userid) <= 9 and Time >= 0
union all
select dt,product_id,user_id,book_id,0 as data_type,
       case when mt = 'iOS' or mt = 'macOS' then 1
          when mt = 'Android' or mt = 'HarmonyOS' then 4
          else  0  end as mt,
       null as appid,create_time,read_time,now() as etl_time
from
    (   select  dt,product_id,user_id,book_id,mt,create_time,
                row_number() over (partition by dt,product_id,user_id,book_id,mt order by create_time) as rn,
                sum(read_time) over (partition by dt,product_id,user_id,book_id,mt) as read_time
        from dwd.dwd_read_book_read_chapter_readtime where dt >= '${bf_15_dt}' and dt <= '${bf_1_dt}'
    ) a
where rn = 1;
