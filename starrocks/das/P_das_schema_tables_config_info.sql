----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_fluctuations
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : das_schema_tables_config_info
-- task_version     : 1
-- update_time      : 2024-01-17 19:01:06
-- sql_path         : \data_quality\data_fluctuations\das_schema_tables_config_info
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_schema_tables_config_info where dt=CURRENT_DATE();

-- SQL语句
insert  into das.das_schema_tables_config_info
select
CURRENT_DATE() dt ,
a.TABLE_SCHEMA,
a.TABLE_NAME,
a.TABLE_TYPE,
a.`ENGINE`,
c.table_rows,
a.AVG_ROW_LENGTH,
a.DATA_LENGTH,
a.CREATE_TIME,
a.UPDATE_TIME,
a.CHECK_TIME,
b.TABLE_ENGINE,
b.TABLE_MODEL,
b.PRIMARY_KEY,
b.PARTITION_KEY,
b.TABLE_ID,
NOW() etl_tm
from
(select
TABLE_SCHEMA,
TABLE_NAME,
TABLE_TYPE,
`ENGINE`,
TABLE_ROWS,
AVG_ROW_LENGTH,
DATA_LENGTH,
CREATE_TIME,
UPDATE_TIME,
CHECK_TIME
from information_schema.tables where TABLE_TYPE !='VIEW' and TABLE_SCHEMA in ('ods_log','ods','dws','dwm','dwd','dim','das','alg','ads') and ENGINE ='StarRocks')a
left join information_schema.tables_config b on a.TABLE_NAME = b.TABLE_NAME and a.TABLE_SCHEMA = b.TABLE_SCHEMA
left JOIN das.das_schema_tables_rows c on a.TABLE_SCHEMA = c.table_schema and a.TABLE_NAME = c.table_name and c.dt= CURRENT_DATE()  ;
