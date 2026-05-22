----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map_prase
-- workflow_version : 13
-- create_user      : zhengtt
-- task_name        : das_dict_table_sch_sql_mid
-- task_version     : 5
-- update_time      : 2025-05-24 11:44:38
-- sql_path         : \data_quality\data_map_prase\das_dict_table_sch_sql_mid
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_sch_sql_mid
with tmp_data AS (
    select  a.dt,
            a.id,
            case
                when a.task_params like '%udfs%' then  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","udfs',1)
                else  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","sqlType',1)
            end as table_nm,
            a.submit_time AS sch_time,
            'starrocks' as project_nm,
            c.name  AS  wf_nm,
            b.name as wf_instance,
            a.name task_nm,
            case
                when a.task_params like '%udfs%' then regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","udfs',1)
                else  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","sqlType',1)
            end   as sqls,
            regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"preStatements":\\\["(.*?)"\\\],"postStatements',1)  as prev_sql,
            case
                when a.task_params like '%segmentSeparator%' then regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"postStatements":\\\["(.*?)"\\\],"segmentSeparator',1)
                else regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"postStatements":\\\["(.*?)"\\\],"conditionResult',1)
            end as next_sql,
            now() as etl_time
    from das.das_mysql_dolphinscheduler_t_ds_task_instance a
             left join das.das_mysql_dolphinscheduler_t_ds_process_instance b on a.process_instance_id =b.id
             left join das.das_mysql_dolphinscheduler_t_ds_process_definition c on b.process_definition_code =c.code
    where   a.dt = date_sub(curdate(),interval 1 day)
      and c.project_code ='10857427255392' and a.task_type ='SQL' and a.state = 7
)

SELECT
        dt,
        id,
        get_json_string(
                udf.parsesql2tablename(
                        case
                            when table_nm = '' then 'NULL'
                            when table_nm is null then 'NULL'
                            ELSE table_nm
                            END)
            ,'$.insertTableName')
        AS table_nm,
        sch_time,
        project_nm,
        wf_nm,
        wf_instance,
        task_nm,
        sqls,
        prev_sql,
        next_sql,
        etl_time
FROM tmp_data;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map_prase_bak_20260331144230153
-- workflow_version : 2
-- create_user      : luojie
-- task_name        : das_dict_table_sch_sql_mid
-- task_version     : 1
-- update_time      : 2026-03-31 14:42:30
-- sql_path         : \data_quality\data_map_prase_bak_20260331144230153\das_dict_table_sch_sql_mid
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_sch_sql_mid
with tmp_data AS (
    select  a.dt,
            a.id,
            case
                when a.task_params like '%udfs%' then  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","udfs',1)
                else  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","sqlType',1)
            end as table_nm,
            a.submit_time AS sch_time,
            'starrocks' as project_nm,
            c.name  AS  wf_nm,
            b.name as wf_instance,
            a.name task_nm,
            case
                when a.task_params like '%udfs%' then regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","udfs',1)
                else  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","sqlType',1)
            end   as sqls,
            regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"preStatements":\\\["(.*?)"\\\],"postStatements',1)  as prev_sql,
            case
                when a.task_params like '%segmentSeparator%' then regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"postStatements":\\\["(.*?)"\\\],"segmentSeparator',1)
                else regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"postStatements":\\\["(.*?)"\\\],"conditionResult',1)
            end as next_sql,
            now() as etl_time
    from das.das_mysql_dolphinscheduler_t_ds_task_instance a
             left join das.das_mysql_dolphinscheduler_t_ds_process_instance b on a.process_instance_id =b.id
             left join das.das_mysql_dolphinscheduler_t_ds_process_definition c on b.process_definition_code =c.code
    where   a.dt = date_sub(curdate(),interval 1 day)
      and c.project_code ='10857427255392' and a.task_type ='SQL' and a.state = 7
)

SELECT
        dt,
        id,
        get_json_string(
                udf.parsesql2tablename(
                        case
                            when table_nm = '' then 'NULL'
                            when table_nm is null then 'NULL'
                            ELSE table_nm
                            END)
            ,'$.insertTableName')
        AS table_nm,
        sch_time,
        project_nm,
        wf_nm,
        wf_instance,
        task_nm,
        sqls,
        prev_sql,
        next_sql,
        etl_time
FROM tmp_data;
