----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_ddl
-- task_version     : 7
-- update_time      : 2024-02-02 16:26:47
-- sql_path         : \data_quality\data_map\das_dict_table_ddl
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_ddl
select  dt, id,
        case when db_nm_2 = 'ods_log'
                 then substr(get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName'),9)
             else substr(get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName'),5)
            end as table_nm,
        operator, operation_time, stmt, etl_time
from
    (   select  dt,id,operator,db_nm_2,operation_time,stmt,now() as etl_time
        from
            (   select dt,id,
                       substr(get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName'),1,3) as db_nm,
                       substr(get_json_string(udf.parsesql2tablename(stmt),'$.insertTableName'),1,7) as db_nm_2,
                       operator,operation_time,stmt
                from das.das_dict_sql_mid
                where  opreate_type = 1 and dt >= '${bf_1_dt}'
            )a
        where db_nm in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log')
    ) a;
