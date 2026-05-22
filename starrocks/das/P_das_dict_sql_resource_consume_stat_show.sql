----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : slow_query_info
-- workflow_version : 10
-- create_user      : zhengtt
-- task_name        : das_dict_sql_resource_consume_stat_show
-- task_version     : 3
-- update_time      : 2024-01-26 18:39:04
-- sql_path         : \data_quality\slow_query_info\das_dict_sql_resource_consume_stat_show
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_resource_consume_stat_show
with shows as
         (select dt, md5_key, use_type, judge_tp, rn, table_nm, route, consume_value, sqls-- now() as etl_time
          from
              (   select dt, md5_key, use_type, judge_tp, rn, table_nm, route, consume_value, sqls,
                         row_number() over (partition by dt,use_type,table_nm order by judge_tp) as rns
                  from das.das_dict_sql_resource_consume_stat
                  where dt = '${bf_1_dt}'
              ) a
          where rns = 1),
     show2 as
         (   select  dt, md5_key, use_type, judge_tp, rn, table_nm, route, consume_value, sqls
             from shows
             where (case when use_type = 'dolphin_writer' and judge_tp = '执行时长(s)' then consume_value >= 200
                         when use_type = 'dolphin_writer' and judge_tp = '内存消耗量(MB)' then consume_value >= 5000
                         when use_type = 'dolphin_writer' and judge_tp = '执行时长(s)' then consume_value >= 30
                         when use_type in ('finebi_user','report_user') and judge_tp = '执行时长(s)' then consume_value >= 100
                         when use_type in ('finebi_user','report_user') and judge_tp = '内存消耗量(MB)' then consume_value >= 2500
                         when use_type in ('finebi_user','report_user') and judge_tp = '执行时长(s)' then consume_value >= 15 end)
         )
select  show2.dt,show2.md5_key, show2.use_type, show2.judge_tp, show2.rn, show2.table_nm, show2.route, show2.consume_value, show2.sqls,now() as etl_time
from show2
         left join
     (   select  md5_key, use_type, judge_tp, rn, table_nm, route, consume_value, sqls
         from das.das_dict_sql_resource_consume_stat_show_log) b
     on show2.table_nm = b.table_nm
where b.table_nm is null;
