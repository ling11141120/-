----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_short_video_login_a
-- workflow_version : 7
-- create_user      : linq
-- task_name        : dws_user_short_video_login_a_tmp
-- task_version     : 4
-- update_time      : 2025-02-06 01:16:09
-- sql_path         : \starrocks\tbl_dws_user_short_video_login_a\dws_user_short_video_login_a_tmp
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_user_short_video_login_a_tmp
select '${bf_1_dt}' as dt,
       fst_lst.product_id,
       fst_lst.user_id,
       fst_lst.fst_login_time,
       fst_lst.lst_login_time,
       fst_lst.new_login_time,
       login.login_days,
       login.login_cnt,
       datediff(new_login_time,acc.create_time) as remain_day,
       now() as etl_time
from(
    select product_id,user_id,
           max(case when rank_asc=1 then create_time end) as fst_login_time,
           max(case when rank_desc=2 then create_time end ) as lst_login_time,
           max(case when rank_desc=1 then create_time end) as new_login_time
    from(
        select product_id,user_id,create_time,
               ROW_NUMBER()over(partition by product_id,user_id order by create_time) rank_asc,
               ROW_NUMBER()over(partition by product_id,user_id order by create_time desc) rank_desc
        from dwd.dwd_user_short_video_user_login_view where dt='${bf_1_dt}'and product_id in (6833) and user_id is not null
        ) a
    where rank_asc=1 or rank_desc in (1,2)
    group by 1,2
)fst_lst
left join (
    select product_id,user_id,count(distinct dt) as login_days,count(1) as login_cnt
    from  dwd.dwd_user_short_video_user_login_view
    where dt='${bf_1_dt}' and product_id in (6833)
    group by 1,2
)login on fst_lst.product_id=login.product_id and fst_lst.user_id=login.user_id
left join dim.dim_short_video_user_accountinfo acc on fst_lst.product_id=acc.product_id and fst_lst.user_id=acc.user_id;
