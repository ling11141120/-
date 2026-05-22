----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_comsume_book_user_l90d
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : tbl_dws_comsume_book_user_l90d
-- task_version     : 3
-- update_time      : 2023-11-07 14:32:57
-- sql_path         : \starrocks\tbl_dws_comsume_book_user_l90d\tbl_dws_comsume_book_user_l90d
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_comsume_book_user_l90d
with csm_user_l90 as
(
select '${bf_1_dt}' as dt, site_id, book_id, bitmap_union(to_bitmap(user_id)) as csm_user_90d
from dwm.dwm_consume_user_consume_mild_ed
where dt >= date_sub('${bf_1_dt}', interval 90 day)
  and dt < '${bf_1_dt}'
group by 1,2,3
)

select dt, site_id, book_id, user_id,now() as etl_time
from (
         select read_1d.dt,
                read_1d.site_id,
                read_1d.book_id,
                if(bitmap_contains(csm_user_90d, read_1d.user_id), null, user_id) user_id
         from (
                  select dt, user_id, book_id, site_id
                  from  dwm.dwm_consume_user_consume_mild_ed
                  where dt = '${bf_1_dt}'
                  group by dt, user_id, book_id, site_id
              ) read_1d
                  left join (
             select dt, site_id, book_id, csm_user_90d
             from csm_user_l90
             where dt = '${bf_1_dt}'
         ) read_90d on read_1d.dt = read_90d.dt and read_1d.site_id = read_90d.site_id and
                       read_1d.book_id = read_90d.book_id
     ) read_1d_exclude
where user_id is not null;
