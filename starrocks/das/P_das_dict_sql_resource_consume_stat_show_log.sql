----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : slow_query_info
-- workflow_version : 10
-- create_user      : zhengtt
-- task_name        : das_dict_sql_resource_consume_stat_show_log
-- task_version     : 1
-- update_time      : 2024-01-26 18:39:04
-- sql_path         : \data_quality\slow_query_info\das_dict_sql_resource_consume_stat_show_log
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_resource_consume_stat_show_log
select dt, md5_key, use_type, judge_tp, rn, table_nm, route, consume_value, sqls, etl_time
from das.das_dict_sql_resource_consume_stat_show
where dt = '${bf_1_dt}';
