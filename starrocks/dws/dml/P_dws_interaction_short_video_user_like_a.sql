----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_interaction_short_video_user_like_a
-- workflow_version : 2
-- create_user      : linq
-- task_name        : dws_interaction_short_video_user_like_a
-- task_version     : 1
-- update_time      : 2024-01-25 15:08:56
-- sql_path         : \starrocks\tbl_dws_interaction_short_video_user_like_a\dws_interaction_short_video_user_like_a
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_interaction_short_video_user_like_a where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_interaction_short_video_user_like_a
select '${bf_1_dt}' as dt,
       6833 as product_id,
       a.user_id,
       min(create_time) as fst_like_time,
       max(create_time) as lst_like_time,
       bitmap_union(to_bitmap(a.series_id)) as like_series_td,
       bitmap_union(to_bitmap(concat(a.series_id,b.epis_num))) as like_epis_td,
       count(1) as like_cnt_td,
       now() as etl_time
from dwd.dwd_video_short_video_account_like_view a
left join dim.dim_short_video_epis_view b on a.epis_id=b.epis_id
where dt<='${bf_1_dt}'
group by 1,2,3;
