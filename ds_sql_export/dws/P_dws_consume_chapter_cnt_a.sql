----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_chapter_cnt_a
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_dws_consume_chapter_cnt_a
-- task_version     : 3
-- update_time      : 2023-12-16 11:11:02
-- sql_path         : \starrocks\tbl_dws_consume_chapter_cnt_a\tbl_dws_consume_chapter_cnt_a
----------------------------------------------------------------
-- SQL语句
insert  into dws.dws_consume_chapter_cnt_a
select '${bf_1_dt}' dt ,product_id,user_id , sum(cnt) cnt ,max(max_create_tm) max_create_tm, min(min_create_tm) min_create_tm,NOW()
from (select product_id,user_id , cnt , max_create_tm,min_create_tm
from dws.dws_consume_chapter_cnt_a where dt='${bf_2_dt}'
union all
select product_id,user_id , count(1) cnt ,max(createtime) max_create_tm,min(createtime)min_create_tm
from( select product_id,user_id ,chapter_ids,createtime  from dwd.dwd_consume_user_consume
where  types in (1,2,3)  and   dt='${bf_1_dt}'
group by 1,2,3,4 )a group  by 1,2 )a where product_id  is not  null  and user_id is not  null  group  by 2,3;
