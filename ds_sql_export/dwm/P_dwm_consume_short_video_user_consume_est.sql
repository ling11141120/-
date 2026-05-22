----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_consume_short_video_user_consume_est
-- workflow_version : 12
-- create_user      : zhengtt
-- task_name        : tbl_dwm_consume_short_video_user_consume_est
-- task_version     : 11
-- update_time      : 2025-01-27 14:59:04
-- sql_path         : \starrocks\tbl_dwm_consume_short_video_user_consume_est\tbl_dwm_consume_short_video_user_consume_est
----------------------------------------------------------------
-- SQL语句
insert into dwm.dwm_consume_short_video_user_consume_est
select  date(hours_add(a.create_time,-13)) as dt,a.account_id as user_id,b.series_id,a.epis_num,
        hours_add(a.create_time,-13) as create_time,consume_type,sum(a.consume_value) as consume_value,
        now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_epis_view b
    on a.epis_id = b.epis_id
-- 改为实时，等于改为大于等于
where date(hours_add(a.create_time,-13)) >= '${bf_1_dt}' and  b.epis_id is not null
group by 1,2,3,4,5,6;
