----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_statistics
-- task_version     : 7
-- update_time      : 2024-03-12 20:38:56
-- sql_path         : \data_quality\data_map\das_dict_table_statistics
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_statistics
select  a.table_nm,b.last_qtime,b.last_mtime,c.sch_time as last_schtime,a.row_cnt,
        b.q_cnt_7d,b.m_cnt_7d,b.avg_time_costs_10d,a.bf_1_data_size,a.avg_data_size_7d,
        now() as etl_time
from
    (   select  table_nm,row_cnt,data_size-data_size_1_bf as bf_1_data_size,(data_size-data_size_7_bf)/7 as avg_data_size_7d
        from
            (   select  table_nm,
                        dt,
                        data_size,
                        row_cnt,
                        lag(data_size,1,0) over(partition by table_nm order by dt) as data_size_1_bf,
                        lag(data_size,7,0) over(partition by table_nm order by dt) as data_size_7_bf
                from das.das_dict_table_tablet where dt < '${dt}' and dt >= '${bf_7_dt}'
            )a
        where dt = '${bf_1_dt}'
    ) a
        left join
    (   select  table_nm,
                max(if(operator_type = 2,operation_time,null)) as last_qtime,
                max(if(operator_type = 1,operation_time,null)) as last_mtime,
                sum(if(dt >= date_sub('${dt}',interval 7 day) and operator_type = 2 ,1,0)) as q_cnt_7d,
                sum(if(dt >= date_sub('${dt}',interval 7 day) and operator_type = 1 and if_insert = 1 ,1,0)) as m_cnt_7d,
                sum(if(if_insert = 1 and rn <= 10,query_time,0))/if(max(rn) >= 10,10,max(rn)) as avg_time_costs_10d
        from
            (   select  table_nm,
                        dt,
                        operation_time,
                        operator_type,
                        query_time,
                        if(lower(stmt) like '%insert %' and operator_type = 1,1,0) as if_insert,
                        row_number() over (partition by table_nm,if(lower(stmt) like '%insert %' and operator_type = 1,1,0) order by operation_time desc) as rn
                from
                    (   select table_nm,dt,operation_time,operator_type,query_time,stmt
                        from das.das_dict_table_dml
                        )b
            )b
        group by 1
    ) b on a.table_nm = b.table_nm
        left join   das.das_dict_table_sch_sql c
                    on a.table_nm = c.table_nm;
