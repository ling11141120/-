----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : slow_query_info
-- workflow_version : 10
-- create_user      : zhengtt
-- task_name        : das_dict_sql_resource_consume_stat
-- task_version     : 3
-- update_time      : 2024-01-10 15:35:36
-- sql_path         : \data_quality\slow_query_info\das_dict_sql_resource_consume_stat
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_resource_consume_stat
with dol as (
    select  dt,db_nm,table_nm,operator,query_time,cpu_cost_ns,mem_cost_bytes,stmt,operation_time
    from das.das_dict_table_dml
    where dt = '${bf_1_dt}' and  operator = 'dolphin_writer'
      and instr(lower(stmt),'insert ') != 0  and operator_type = 1
      and mem_cost_bytes > 0 and cpu_cost_ns > 0 and query_time > 0
      and lower(substr(table_nm,1,3)) = lower(substr(db_nm,1,3))
),
     chk_re as (
         select  dt,id,db_nm,table_nm,operator,query_time,cpu_cost_ns,mem_cost_bytes,stmt,operation_time
         from das.das_dict_table_dml
         where dt = '${bf_1_dt}' and operator_type = 2 and  operator in ('report_user')
           and instr(lower(stmt),'insert ') = 0
           and mem_cost_bytes > 0 and cpu_cost_ns > 0 and query_time > 0
           and lower(substr(table_nm,1,3)) = lower(substr(db_nm,1,3))
     ),
     chk_bi as (
         select  dt,id,db_nm,table_nm,operator,query_time,cpu_cost_ns,mem_cost_bytes,stmt,operation_time
         from das.das_dict_table_dml
         where dt = '${bf_1_dt}' and operator_type = 2 and  operator in ('finebi_user')
           and instr(lower(stmt),'insert ') = 0
           and mem_cost_bytes > 0 and cpu_cost_ns > 0 and query_time > 0
           and lower(substr(table_nm,1,3)) = lower(substr(db_nm,1,3))
     ),
     tw as
         (   select  table_nm,concat(wf_nm,'.',task_nms) as route
             from
                 (   select  table_nm,wf_nm,group_concat(task_nm,'/') as task_nms
                     from
                         (   select  table_nm,wf_nm,task_nm
                             from
                                 (   select  table_nm,sch_time,project_nm,wf_nm,
                                             wf_instance,task_nm,sqls,prev_sql,next_sql,
                                             row_number() over (partition by task_nm order by sch_time desc) as rn
                                     from
                                         (   select  substr(table_nm,5) as table_nm,sch_time,project_nm,wf_nm,
                                                     wf_instance,task_nm,`sql` as sqls,prev_sql,next_sql
                                             from das.das_dict_table_sch_sql_mid
                                             where dt = '${bf_1_dt}' and substr(table_nm,1,3) in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log')
                                         )t
                                 )b
                             where rn = 1
                         ) a
                     group by 1,2
                 ) a
         )
select  dt, md5(concat(use_type, judge_tp, rn, table_nm)) as md5_key,use_type, judge_tp, rn, table_nm, route,
        consume_value, sqls,
        now() as etl_time
from
    (   select '${bf_1_dt}' as dt,'dolphin_writer' as use_type,'执行时长(s)' as judge_tp,a.rn,a.table_nm,tw.route,a.avg_query_time/1000 as consume_value,sqls
        from
            (   select  a.table_nm,a.avg_query_time,a.rn,b.sqls as sqls
                from
                    (   select  table_nm,avg_query_time,rn
                        from
                            (   select  table_nm,avg_query_time,
                                        row_number() over (order by avg_query_time desc) as rn
                                from
                                    (   select table_nm,avg(query_time) as avg_query_time
                                        from dol
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                        ) a
                        left join
                    (   select  table_nm,stmt as sqls
                            from
                            (   select table_nm,stmt,
                                       row_number() over (partition by table_nm order by query_time desc,mem_cost_bytes desc,cpu_cost_ns desc) as rn
                                from dol
                                ) a
                            where rn = 1
                        ) b
                    on a.table_nm = b.table_nm
            ) a
                left join tw
                          on a.table_nm = tw.table_nm
        union all
        select '${bf_1_dt}' as dt,'dolphin_writer' as use_type,'cpu执行时长（s）' as judge_tp,a.rn,a.table_nm,tw.route,a.avg_cpu_cost_ns/1000000000  as consume_value,sqls
        from
            (   select  a.table_nm,avg_cpu_cost_ns,rn,sqls
                from
                    (   select  table_nm,avg_cpu_cost_ns,rn
                        from
                            (   select  table_nm,avg_cpu_cost_ns,
                                        row_number() over (order by avg_cpu_cost_ns desc) as rn
                                from
                                    (   select table_nm,avg(cpu_cost_ns) as avg_cpu_cost_ns
                                        from dol
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select  table_nm,stmt as sqls
                        from
                            (   select table_nm,stmt,
                                       row_number() over (partition by table_nm order by query_time desc,mem_cost_bytes desc,cpu_cost_ns desc) as rn
                                from dol
                            ) a
                        where rn = 1
                    ) b
                    on a.table_nm = b.table_nm
            ) a
                left join tw
                          on a.table_nm = tw.table_nm
        union all
        select '${bf_1_dt}' as dt,'dolphin_writer' as use_type,'内存消耗量(MB)' as judge_tp,a.rn,a.table_nm,tw.route,a.avg_mem_cost_bytes/(1024*1024)  as consume_value,sqls
        from
            (   select  a.table_nm,avg_mem_cost_bytes,rn,sqls
                from
                    (   select  table_nm,avg_mem_cost_bytes,rn
                        from
                            (   select  table_nm,avg_mem_cost_bytes,
                                        row_number() over (order by avg_mem_cost_bytes desc) as rn
                                from
                                    (   select table_nm,avg(mem_cost_bytes) as avg_mem_cost_bytes
                                        from dol
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select  table_nm,stmt as sqls
                        from
                            (   select table_nm,stmt,
                                       row_number() over (partition by table_nm order by query_time desc,mem_cost_bytes desc,cpu_cost_ns desc) as rn
                                from dol
                            ) a
                        where rn = 1
                    ) b
                    on a.table_nm = b.table_nm
            ) a
                left join tw
                          on a.table_nm = tw.table_nm
        union all
        select  '${bf_1_dt}' as dt,'report_user' as use_type,'执行时长(s)' as judge_tp,a.rn,a.tables,'report' as route,avg_query_time/1000  as consume_value,sqls
        from
            (   select  a.tables,a.avg_query_time,rn,stmt as sqls
                from
                    (   select  tables,avg_query_time,rn
                        from
                            (   select  tables,avg_query_time,
                                        row_number() over (order by avg_query_time desc) as rn
                                from
                                    (   select  tables,avg(query_time) as avg_query_time
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_re
                                                group by 1,2,3,4,5
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                        ) a
                        left join
                    (   select tables,stmt
                        from
                        (   select  tables,stmt,
                                    row_number() over (partition by tables order by stmt) as rn
                            from
                                (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                    from
                                        (   select stmt,table_nm
                                            from chk_re
                                            group by 1,2
                                        ) a
                                    group by 1
                                    ) b
                            ) a
                        where rn = 1

                    ) b
                    on a.tables = b.tables
            ) a
        union all
        select  '${bf_1_dt}' as dt,'report_user' as use_type,'cpu执行时长（s）' as judge_tp,a.rn,a.tables,'report' as route,avg_cpu_cost_ns/1000000000  as consume_value,sqls
        from
            (   select  a.tables,a.avg_cpu_cost_ns,rn,stmt as sqls
                from
                    (   select  tables,avg_cpu_cost_ns,rn
                        from
                            (   select  tables,avg_cpu_cost_ns,
                                        row_number() over (order by avg_cpu_cost_ns desc) as rn
                                from
                                    (   select  tables,avg(cpu_cost_ns) as avg_cpu_cost_ns
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_re
                                                group by 1,2,3,4
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select tables,stmt
                        from
                            (   select  tables,stmt,
                                        row_number() over (partition by tables order by stmt) as rn
                                from
                                    (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                        from
                                            (   select stmt,table_nm
                                                from chk_re
                                                group by 1,2
                                            ) a
                                        group by 1
                                    ) b
                            ) a
                        where rn = 1
                    ) b
                    on a.tables = b.tables
            ) a
        union all
        select  '${bf_1_dt}' as dt,'report_user' as use_type,'内存消耗量(MB)' as judge_tp,a.rn,a.tables,'report' as route,avg_mem_cost_bytes/(1024*1024)  as consume_value,sqls
        from
            (   select  a.tables,a.avg_mem_cost_bytes,rn,stmt as sqls
                from
                    (   select  tables,avg_mem_cost_bytes,rn
                        from
                            (   select  tables,avg_mem_cost_bytes,
                                        row_number() over (order by avg_mem_cost_bytes desc) as rn
                                from
                                    (   select  tables,avg(mem_cost_bytes) as avg_mem_cost_bytes
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_re
                                                group by 1,2,3,4
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select tables,stmt
                        from
                            (   select  tables,stmt,
                                        row_number() over (partition by tables order by stmt) as rn
                                from
                                    (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                        from
                                            (   select stmt,table_nm
                                                from chk_re
                                                group by 1,2
                                            ) a
                                        group by 1
                                    ) b
                            ) a
                        where rn = 1
                    ) b
                    on a.tables = b.tables
            ) a
        union all
        select  '${bf_1_dt}' as dt,'finebi_user' as use_type,'执行时长(s)' as judge_tp,a.rn,a.tables,'finebi' as route,avg_query_time/1000  as consume_value,sqls
        from
            (   select  a.tables,a.avg_query_time,rn,stmt as sqls
                from
                    (   select  tables,avg_query_time,rn
                        from
                            (   select  tables,avg_query_time,
                                        row_number() over (order by avg_query_time desc) as rn
                                from
                                    (   select  tables,avg(query_time) as avg_query_time
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_bi
                                                group by 1,2,3,4,5
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select tables,stmt
                        from
                            (   select  tables,stmt,
                                        row_number() over (partition by tables order by stmt) as rn
                                from
                                    (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                        from
                                            (   select stmt,table_nm
                                                from chk_bi
                                                group by 1,2
                                            ) a
                                        group by 1
                                    ) b
                            ) a
                        where rn = 1
                    ) b
                    on a.tables = b.tables
            ) a
        union all
        select  '${bf_1_dt}' as dt,'finebi_user' as use_type,'cpu执行时长（s）' as judge_tp,a.rn,a.tables,'finebi' as route,avg_cpu_cost_ns/1000000000  as consume_value,sqls
        from
            (   select  a.tables,a.avg_cpu_cost_ns,rn,stmt as sqls
                from
                    (   select  tables,avg_cpu_cost_ns,rn
                        from
                            (   select  tables,avg_cpu_cost_ns,
                                        row_number() over (order by avg_cpu_cost_ns desc) as rn
                                from
                                    (   select  tables,avg(cpu_cost_ns) as avg_cpu_cost_ns
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_bi
                                                group by 1,2,3,4
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select tables,stmt
                        from
                            (   select  tables,stmt,
                                        row_number() over (partition by tables order by stmt) as rn
                                from
                                    (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                        from
                                            (   select stmt,table_nm
                                                from chk_bi
                                                group by 1,2
                                            ) a
                                        group by 1
                                    ) b
                            ) a
                        where rn = 1
                    ) b
                    on a.tables = b.tables
            ) a
        union all
        select  '${bf_1_dt}' as dt,'finebi_user' as use_type,'内存消耗量(MB)' as judge_tp,a.rn,a.tables,'finebi' as route,avg_mem_cost_bytes/(1024*1024)  as consume_value,sqls
        from
            (   select  a.tables,a.avg_mem_cost_bytes,rn,stmt as sqls
                from
                    (   select  tables,avg_mem_cost_bytes,rn
                        from
                            (   select  tables,avg_mem_cost_bytes,
                                        row_number() over (order by avg_mem_cost_bytes desc) as rn
                                from
                                    (   select  tables,avg(mem_cost_bytes) as avg_mem_cost_bytes
                                        from
                                            (   select  id,query_time,cpu_cost_ns,mem_cost_bytes,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                                from chk_bi
                                                group by 1,2,3,4
                                            ) a
                                        group by 1
                                    ) a
                            ) a
                        where rn <= 5
                    ) a
                        left join
                    (   select tables,stmt
                        from
                            (   select  tables,stmt,
                                        row_number() over (partition by tables order by stmt) as rn
                                from
                                    (   select  stmt,array_join(ARRAY_SORT(array_agg(table_nm)),'/') as tables
                                        from
                                            (   select stmt,table_nm
                                                from chk_bi
                                                group by 1,2
                                            ) a
                                        group by 1
                                    ) b
                            ) a
                        where rn = 1
                    ) b
                    on a.tables = b.tables
            ) a
    ) a
;
