----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map_prase
-- workflow_version : 13
-- create_user      : zhengtt
-- task_name        : das_dict_table_sch_sql
-- task_version     : 2
-- update_time      : 2024-01-17 11:19:12
-- sql_path         : \data_quality\data_map_prase\das_dict_table_sch_sql
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_sch_sql
select  table_nm,sch_time,'starrocks' as project_nm,wf_nm,
        wf_instance,task_nm,sqls,
        split(if(prev_sql = '',null,prev_sql),'\",\"') as prev_sql,
        split(if(next_sql = '',null,next_sql),'\",\"') as next_sql,
        now() as etl_time
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
union all
select  TABLE_NAME as table_nm,date_sub(curdate(),interval 1 day) as sch_time,null as project_nm,null as wf_nm,
        null as wf_instance,null as task_nm,
        concat('create view',' ',TABLE_SCHEMA,'.',TABLE_NAME,' as ',VIEW_DEFINITION) as sqls,
        split(null,',') as prev_sql,split(null,',') as next_sql,now() as etl_time
from information_schema.views
where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log');

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map_prase_bak_20260331144230153
-- workflow_version : 2
-- create_user      : luojie
-- task_name        : das_dict_table_sch_sql
-- task_version     : 1
-- update_time      : 2026-03-31 14:42:30
-- sql_path         : \data_quality\data_map_prase_bak_20260331144230153\das_dict_table_sch_sql
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_sch_sql
select  table_nm,sch_time,'starrocks' as project_nm,wf_nm,
        wf_instance,task_nm,sqls,
        split(if(prev_sql = '',null,prev_sql),'\",\"') as prev_sql,
        split(if(next_sql = '',null,next_sql),'\",\"') as next_sql,
        now() as etl_time
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
union all
select  TABLE_NAME as table_nm,date_sub(curdate(),interval 1 day) as sch_time,null as project_nm,null as wf_nm,
        null as wf_instance,null as task_nm,
        concat('create view',' ',TABLE_SCHEMA,'.',TABLE_NAME,' as ',VIEW_DEFINITION) as sqls,
        split(null,',') as prev_sql,split(null,',') as next_sql,now() as etl_time
from information_schema.views
where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log');
