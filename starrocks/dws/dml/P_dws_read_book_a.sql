----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_book_a
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dws_read_book_a
-- task_version     : 1
-- update_time      : 2023-11-15 16:37:33
-- sql_path         : \starrocks\tbl_dws_read_book_a\dws_read_book_a
----------------------------------------------------------------
-- SQL语句
insert overwrite  dws.dws_read_book_a  partition(p'${pname}')
 select '${dt}' as dt,
        book_id,site_id,
        bitmap_union(user_id) userid,  -- -----------------
        now() as etl_time
 from (
 -- -------------2020-06-01-2023-06-06 ---- ---p20230607
 select book_id,site_id,user_id from dws.dws_read_book_a where dt=date_sub('${dt}',interval 1 day) -- where book_id= 18528322
 union all
 -- ---2023-06-06-----
 select
         book_id,
          site_id,
      bitmap_union(to_bitmap(user_id))  user_id
 from
(  select  dt,
        IF(site_id = 775 or site_id=885, 777, site_id) as site_id,
        book_id,
        user_id
from dws.dws_read_user_readbook_ed
where dt=date_sub('${dt}',interval 1 day)  -- and dt<'2023-06-08' -- and book_id= 18528322
 ) a  group by 1,2
 ) a  group by 1,2,3;
