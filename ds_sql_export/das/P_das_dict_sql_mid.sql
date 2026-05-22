----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_sql_mid_type1
-- task_version     : 6
-- update_time      : 2024-05-24 22:39:48
-- sql_path         : \data_quality\data_map\das_dict_sql_mid_type1
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_mid
select date(timestamp) as dt,queryId,1 as opreate_type,user,timestamp,
       clientIp,resourceGroup,state,
       queryTime,scanBytes,scanRows,returnRows,cpuCostNs,memCostBytes,
       stmtId,feIp,if(length(stmt)<=65533,stmt,substr(stmt,1,65533)) as stmt,
       digest,planCpuCosts,planMemCosts,
       now() as etl_time
from starrocks_audit_db__.starrocks_audit_tbl__
where timestamp >= '${bf_1_dt}' and db != 'shenglong' and state != 'ERR'
  and ((lower(stmt) rlike 'truncate |drop |alter ' and (case when instr(lower(stmt),'select ') != 0 then instr(lower(stmt),' from ') != 0  else 1=1 end))
    or (lower(stmt) like '%create %' and lower(stmt) like '% table %' and
        case when instr(lower(stmt),'select ') != 0 then instr(lower(stmt),' from ') != 0 else 1=1 end)
    or (lower(stmt) like '%create %' and lower(stmt) like '% view %') and
       case when instr(lower(stmt),'select ') != 0 then instr(lower(stmt),' from ') != 0 else 1=1 end)
  and instr(lower(stmt),'set') != 1  and instr(lower(stmt),'elect  @@') =0 and instr(lower(stmt),'use ') != 1
  and instr(lower(stmt),'show ') !=1;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_sql_mid_type2
-- task_version     : 4
-- update_time      : 2024-06-03 20:24:29
-- sql_path         : \data_quality\data_map\das_dict_sql_mid_type2
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_mid
select date(timestamp) as dt,queryId,2 as opreate_type,user,timestamp,
       clientIp,resourceGroup,state,
       queryTime,scanBytes,scanRows,returnRows,cpuCostNs,memCostBytes,
       stmtId,feIp,if(length(stmt)<=65533,stmt,substr(stmt,1,65533)) as stmt,
       digest,planCpuCosts,planMemCosts,
       now() as etl_time
from starrocks_audit_db__.starrocks_audit_tbl__
where timestamp >= '${bf_1_dt}'  and db != 'shenglong' and state != 'ERR'
  and lower(stmt) rlike 'delete |insert |update '
  and instr(lower(stmt),'set ') != 1  and instr(lower(stmt),'elect  @@') =0 and instr(lower(stmt),'use ') !=1
  and instr(lower(stmt),'show ') !=1 and  (case when instr(lower(stmt),'insert ') != 0 then instr(lower(stmt),'values') = 0 else 1=1 end);

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_sql_mid_type3
-- task_version     : 5
-- update_time      : 2024-06-03 20:37:15
-- sql_path         : \data_quality\data_map\das_dict_sql_mid_type3
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_sql_mid
select date(timestamp) as dt,queryId,3 as opreate_type,user,timestamp,
       clientIp,resourceGroup,state,
       queryTime,scanBytes,scanRows,returnRows,cpuCostNs,memCostBytes,
       stmtId,feIp,if(length(stmt)<=60000,stmt,substr(stmt,1,60000)) as stmt,
       digest,planCpuCosts,planMemCosts,
       now() as etl_time
from starrocks_audit_db__.starrocks_audit_tbl__
where timestamp >= '${bf_1_dt}'  and db != 'shenglong' and state != 'ERR'
  and instr(lower(stmt),'insert ') = 0 and instr(lower(stmt),'create ') = 0 and (lower(stmt) like '%select %' and lower(stmt) like '% from %')
  and instr(lower(stmt),'set ') != 1  and instr(lower(stmt),'elect  @@') =0 and instr(lower(stmt),'use ') !=1
  and instr(lower(stmt),'show ') !=1;
