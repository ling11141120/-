----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_sql_prase_mid_type1
-- task_version     : 5
-- update_time      : 2025-01-21 16:35:51
-- sql_path         : \data_quality\data_map\das_dict_sql_prase_mid_type1
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_prase_mid
select dt,id,
       md5(get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName')) as md5_table_nm,
       get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName') as table_nm,
       operator,
       2 as operator_type,
       operation_time,client_ip,resource_group,status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,mem_cost_bytes,
       stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs,
       now() as etl_time
from das.das_dict_sql_mid
where  dt >= '${bf_1_dt}' and opreate_type = 3 and get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName') is not null;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_sql_prase_mid_type2
-- task_version     : 6
-- update_time      : 2025-01-21 16:35:51
-- sql_path         : \data_quality\data_map\das_dict_sql_prase_mid_type2
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_prase_mid
select dt,id,
       md5(get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName')) as md5_table_nm,
       get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName') as table_nm,
       operator,
       1 as operator_type,
       operation_time,client_ip,resource_group,status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,mem_cost_bytes,
       stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs,
       now() as etl_time
from das.das_dict_sql_mid
where  dt >= '${bf_1_dt}'  and opreate_type = 2 and get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName') is not null
union all
select dt,id,
       md5(get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName')) as md5_table_nm,
       get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName') as table_nm,
       operator,
       2 as operator_type,
       operation_time,client_ip,resource_group,status,query_time,scan_bytes,scan_rows,return_rows,cpu_cost_ns,mem_cost_bytes,
       stmt_id,fe_ip,stmt,digest,plan_cpu_costs,plan_mem_costs,
       now() as etl_time
from das.das_dict_sql_mid
where  dt >= '${bf_1_dt}'  and opreate_type = 2
  and  (instr(lower(stmt),'insert ') != 0 and  instr(lower(stmt),'values') = 0
  and (case when instr(lower(stmt),'select ') != 0 then instr(lower(stmt),' from ') != 0  else 1=1 end))
  and  get_json_string(udf.parsesql2tablename(stmt),'$.fromTableName') is not null;
