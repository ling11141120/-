----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_short_video_login_a
-- workflow_version : 7
-- create_user      : linq
-- task_name        : dws_user_short_video_login_a
-- task_version     : 4
-- update_time      : 2024-04-29 10:28:27
-- sql_path         : \starrocks\tbl_dws_user_short_video_login_a\dws_user_short_video_login_a
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_user_short_video_login_a where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_user_short_video_login_a
select '${bf_1_dt}' as dt,
       ifnull(a.product_id,b.product_id) as product_id,
       ifnull(a.user_id,b.user_id) as user_id,
       ifnull(a.fst_login_tm,b.fst_login_tm) as fst_login_tm,
       case when b.lst_login_tm is not null then b.lst_login_tm
            when b.new_login_tm is not null and b.lst_login_tm is null then a.new_login_tm
            else a.lst_login_tm end as lst_login_tm,
       ifnull(b.new_login_tm,a.new_login_tm) as new_login_tm,
       ifnull(a.login_days_td,0)+ifnull(b.login_days_td,0) as login_days_td,
       ifnull(a.login_cnt_td,0)+ifnull(b.login_cnt_td,0) as login_cnt_td,
       ifnull(b.remain_day,a.remain_day) as remain_day,
       now() as etl_time
from(
    select '${bf_1_dt}' as dt,product_id,user_id,fst_login_tm,lst_login_tm,new_login_tm,login_days_td,login_cnt_td,remain_day
    from dws.dws_user_short_video_login_a
    where dt='${bf_2_dt}'
)a
full join(
    select dt,product_id,user_id,fst_login_tm,lst_login_tm,new_login_tm,login_days_td,login_cnt_td,remain_day
    from dws.dws_user_short_video_login_a_tmp
    where dt='${bf_1_dt}'
)b on a.product_id=b.product_id and a.user_id=b.user_id;
