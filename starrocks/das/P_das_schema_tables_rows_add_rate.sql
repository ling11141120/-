----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_fluctuations
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : das_schema_tables_rows_add_rate
-- task_version     : 1
-- update_time      : 2024-01-17 19:01:06
-- sql_path         : \data_quality\data_fluctuations\das_schema_tables_rows_add_rate
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_schema_tables_rows_add_rate where dt=CURRENT_DATE();

-- SQL语句
insert into das.das_schema_tables_rows_add_rate
select
CURRENT_DATE() dt,
table_schema,
table_name,
if(partition_key= '`dt`',IFNULL( abs(1-avg_table_rows/table_rows)*100,0) ,IFNULL( abs(1-avg_add_rows/now_add_rows)*100,0))   add_rows_rate,
if(if(partition_key= '`dt`',IFNULL( abs(1-avg_table_rows/table_rows)*100,0) ,IFNULL( abs(1-avg_add_rows/now_add_rows)*100,0))  >20,1,0   )is_flag,
avg_add_rows, -- 7天新增数据均值
now_add_rows, -- 新增数据
avg_table_rows, -- 7天内 分区均值
table_rows, -- 分区数据
partition_key,
now()
from
(select
table_schema,
table_name,
partition_key,
avg(if(dt !=CURRENT_DATE(),add_rows,null) ) avg_add_rows,
max(if(dt=CURRENT_DATE(),add_rows,null ))now_add_rows,
max(if(dt=CURRENT_DATE(),table_rows,null ))table_rows,
avg(if(dt !=CURRENT_DATE(),table_rows,null) ) avg_table_rows,
NOW()
from (
select
dt,
table_schema,
table_name,
table_type,
`engine`,
table_rows,
Lag(table_rows,1,null) over(partition by table_schema,table_name order by dt asc )yesterday_rows,
abs(table_rows - Lag(table_rows,1,null) over(partition by table_schema,table_name order by dt asc))add_rows,
avg_row_length,
data_length,
create_time,
update_time,
check_time,
table_engine,
table_model,
primary_key,
partition_key,
table_id
from das.das_schema_tables_config_info where  dt >=DATE_SUB(CURRENT_DATE() ,interval 8 day) )a
group  by  1,2,3)a;
