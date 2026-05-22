----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : das_table_wave_detection
-- workflow_version : 3
-- create_user      : admin
-- task_name        : das_table_rows_ed
-- task_version     : 3
-- update_time      : 2024-01-16 16:02:47
-- sql_path         : \data_quality\das_table_wave_detection\das_table_rows_ed
----------------------------------------------------------------
-- SQL语句
insert into das.das_table_rows_ed
select
 DATE_FORMAT(DATE_SUB(CURRENT_DATE(),1),'%Y-%m-%d') dt
,concat(a.table_schema,'.',a.TABLE_NAME) tbl_nm
,a.table_rows
,case when length(b.PARTITION_KEY)>0  then true else false end is_partition_tbl
,regexp_extract(get_json_string(b.PROPERTIES,'$.dynamic_partition'),'dynamic_partition.start:-([0-9]+)',1) start_partition
,CURRENT_TIME() etl_tm
from information_schema.tables a left join information_schema.tables_config b on a.table_schema=b.table_schema and a.table_name=b.table_name;
