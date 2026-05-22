----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_alg_recomment_exp_ed
-- workflow_version : 4
-- create_user      : linq
-- task_name        : dws_alg_recomment_exp_ed
-- task_version     : 4
-- update_time      : 2024-03-20 10:27:22
-- sql_path         : \starrocks\tbl_dws_alg_recomment_exp_ed\dws_alg_recomment_exp_ed
----------------------------------------------------------------
-- SQL语句
-- 2024-03-20之后的数据不需要做数据修正
insert into dws.dws_alg_recomment_exp_ed
-- 2024-03-20 之前的数据
select date(date_add(event_time,interval 8 hour )) as dt,
       ifnull(pageId,-99) as pageId,
       ifnull(get_json_string(extendMap, '$.rankExpName'),-99) exp_name,
       ifnull(userid,-99) as userid,
       now() as etl_time
from alg.dwd_reco_book_log
where dt >='${bf_2_dt}' and dt<'${dt}' and dt<'2024-03-20' and date(date_add(event_time,interval 8 hour ))<'2024-03-20'
  and event_time >= date_add('${bf_1_dt}', interval -8 hour)
  and event_time < date_add('${dt}', interval -8 hour)
group by 1, 2, 3, 4
union all
-- 2024-03-20 之后的数据
select dt,
       ifnull(pageId,-99) as pageId,
       ifnull(get_json_string(extendMap, '$.rankExpName'),-99) exp_name,
       ifnull(userid,-99) as userid,
       now() as etl_time
from alg.dwd_reco_book_log
where dt >='${bf_1_dt}' and dt<'${dt}' and dt>='2024-03-20'
group by 1, 2, 3, 4;
