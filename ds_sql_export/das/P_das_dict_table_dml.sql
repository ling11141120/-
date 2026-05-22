----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_dml_type1
-- task_version     : 5
-- update_time      : 2023-12-23 16:59:30
-- sql_path         : \data_quality\data_map\das_dict_table_dml_type1
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_dml
select  dt,id,
        (case when instr(table_nm,'.') = 0 then table_nm
              when instr(table_nm,'.') != 0 then substr(table_nm,5) end) as table_nm,
        operator,opreate_type,operation_time,client_ip,resource_group,
        (case when instr(table_nm,'.') = 0 then substr(table_nm,1,3)
              when instr(table_nm,'.') != 0 then substr(table_nm,1,3) end) as db_nm,
        status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
        mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs,
        now() as etl_time
from
    (   select  dt,id,unnest as table_nm,
                operator,opreate_type,operation_time,client_ip,resource_group,
                status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
                mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs
        from
            (   select  dt,id,split(replace(replace(table_nms,'\"',''),' ',''),',') as table_nms,
                        operator,opreate_type,operation_time,client_ip,resource_group,
                        status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
                        mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs
                from
                    (   select dt,id,
                               substr(table_nm,3,length(table_nm)-4)  as table_nms,
                               operator,opreate_type,operation_time,client_ip,resource_group,
                               status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
                               mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs
                        from  das.das_dict_sql_prase_mid
                        where dt >= '${bf_1_dt}' and opreate_type = 2
                    )s
            )o,
            unnest(table_nms) as t1
    )p
where (case when instr(table_nm,'.') = 0 then substr(table_nm,1,3)
            when instr(table_nm,'.') != 0 then substr(table_nm,1,3) end) in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log');

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_dml_type2
-- task_version     : 5
-- update_time      : 2023-12-23 16:59:30
-- sql_path         : \data_quality\data_map\das_dict_table_dml_type2
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_dml
select  dt,id,
        (case when instr(table_nm,'.') = 0 then table_nm
              when instr(table_nm,'.') != 0 then substr(table_nm,5) end) as table_nm,
        operator,opreate_type,operation_time,client_ip,resource_group,
        (case when instr(table_nm,'.') = 0 then substr(table_nm,1,3)
              when instr(table_nm,'.') != 0 then substr(table_nm,1,3) end) as db_nm,
        status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
        mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs,
        now() as etl_time
from
    (     select dt,id,
                 table_nm,
                 operator,opreate_type,operation_time,client_ip,resource_group,
                 status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,
                 mem_cost_bytes,stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs
          from   das.das_dict_sql_prase_mid
          where dt >= '${bf_1_dt}' and opreate_type = 1
    )p
where (case when instr(table_nm,'.') = 0 then substr(table_nm,1,3)
            when instr(table_nm,'.') != 0 then substr(table_nm,1,3) end) in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log');
