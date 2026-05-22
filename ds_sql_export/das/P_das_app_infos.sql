----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : sch_fine_db
-- workflow_version : 19
-- create_user      : zhugl
-- task_name        : SR_zhilian
-- task_version     : 3
-- update_time      : 2023-11-24 15:48:04
-- sql_path         : \data_quality\sch_fine_db\SR_zhilian
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_app_infos where app_tp='直连' ;

-- SQL语句
insert into das.das_app_infos
with sql_dml as (select table_nm,db_nm ,operator
from das.das_dict_table_dml where dt = date(DATE_SUB(now(),interval 1 day)) and status !='ERR')
select
'直连' as app_nm ,
'直连' as app_type ,
table_nm as table_nm ,
'直连' as comment ,
db_nm as db_nm ,
null script,
null script_tp,
now()
from sql_dml
left JOIN  das.das_sr_app_mapping mapping on sql_dml.operator = mapping.sr_user
where mapping.app_name ='直连'
group  by 1,2,3,4,5;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : sch_fine_db
-- workflow_version : 19
-- create_user      : zhugl
-- task_name        : fineBi_table_info
-- task_version     : 6
-- update_time      : 2023-11-24 15:52:59
-- sql_path         : \data_quality\sch_fine_db\fineBi_table_info
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_app_infos where  app_tp='FineBi';

-- SQL语句
insert into das.das_app_infos
with object as (
select displayName,path from das.das_mysql_finedb_fine_authority_object where path is not  null),
subject as (
select entity_key,
get_json_string(entity_value,'$.name')displayName,
entity_value
from das.das_mysql_finedb_finebi_subject_en  where get_json_string(entity_value,'$.name') is not  null),
subjectsubitem as (
select
entity_key,
entity_value,
get_json_string(entity_value,'$.subItems')subItems,
concat('"',get_json_string(subItems_array.unnest,'$.itemId'),'"') id
from das.das_mysql_finedb_finebi_subjectsubitem_en ,
unnest (
split(
replace(
regexp_replace(
replace(get_json_string(entity_value,'$.subItems'),
' ',''),
'\\[|\\]',''),
'},{','},,{'),
',,')) as subItems_array
where value_class="SubjectSubItemListPO" and get_json_string(entity_value,'$.subItems') is not  null),
entrysnapshot as (
select  entity_key,entity_value,concat('"',parentTableNames.unnest,'"') as id  FROM  das.das_mysql_finedb_finebi_d_entrysnapshot_en,
unnest (cast(get_json_string(entity_value,'$.parentTableNames')as array<string>)) as parentTableNames
where  entity_value is not null),
entryconfig as (
select entity_key,
 db,
dbTableName dbTableName_tmp,
sql,
 paramSetting,
entity_value_json,
entity_value2,
sql2,
connectionName2,tb_name.unnest as dbTableName
from (
select entity_key,
SUBSTR( COALESCE (get_json_string(entity_value,'$.connectionName'),connectionName2),12,3) as db,
COALESCE(get_json_string(entity_value,'$.dbTableName'),get_json_string(udf.parsesql2tablename(COALESCE(sql2,'')),'$.fromTableName')) dbTableName,
COALESCE(get_json_string(entity_value,'$.sql'),sql2) sql,
get_json_string(entity_value,'$.paramSetting') paramSetting,
entity_value_json,entity_value2,sql2,connectionName2 from (
select entity_key,
get_json_string(entity_value,'$.info') as entity_value,
get_json_string(entity_value,'$.info.originSource') as entity_value2,
get_json_string(entity_value,'$.info.originSource.sql') as sql2,
get_json_string(entity_value,'$.info.originSource.connectionName') as connectionName2,
entity_value entity_value_json from das.das_mysql_finedb_finebi_d_entryconfig_en
) a     where get_json_string(entity_value,'$.connectionName')like 'sr%' or connectionName2 like 'sr%'
)a ,
unnest (
split(
replace(
regexp_replace(
replace(dbTableName,
' ',''),
'\\[|\\]|"',''),
',',',,'),
',,')) as tb_name)
select
subject.displayName app_nm,
'FineBi' app_tp,
replace(dbTableName,CONCAT(substr(dbTableName,1,3),'\\.'),'') table_nm,
path comment,
substr(dbTableName,1,3) db_nm,
null,null,NOW()
from object
 join subject on  object.displayName = subject.displayName
 JOIN  subjectsubitem on  subject.entity_key = subjectsubitem.entity_key
 join entrysnapshot on subjectsubitem.id = entrysnapshot.entity_key
 join  entryconfig on entrysnapshot.id = entryconfig.entity_key
 group by 1,2,3,4,5,6;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : sch_fine_db
-- workflow_version : 19
-- create_user      : zhugl
-- task_name        : fineReport_table_info
-- task_version     : 4
-- update_time      : 2023-11-24 15:48:04
-- sql_path         : \data_quality\sch_fine_db\fineReport_table_info
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_app_infos where app_tp='report';

-- SQL语句
insert into das.das_app_infos
with finereoprt as(
select database_name,file_short_name,file_name,
sql,cast(get_json_string(udf.parsesql2tablename(sql),'$.fromTableName') as Array<string>) table_array ,
dt,tables.unnest as table_name
from  das.das_mysql_finerepodb_from_file_execute_sql,
unnest(cast(get_json_string(udf.parsesql2tablename(sql),'$.fromTableName') as array<string>)) as tables
where dt=(select max(dt) from das.das_mysql_finerepodb_from_file_execute_sql)),
fine_info as (
select displayName,path from
(select displayName,path from  das.das_mysql_finerepodb_fine_authority_object
union all
select "首页" ,pcHomePage
from das.das_mysql_finerepodb_fine_homepage_expand
)a where path is not null
)
select
displayName as  app_nm ,
"report" as app_tp,
replace(table_name,CONCAT(substr(table_name,1,3),'\\.'),'')  as table_nm,
file_short_name as comment,
SUBSTR(table_name,1,3) as db_name,
null as script,
null as script_tp,
now()  as etl_tm
from finereoprt join fine_info
on  finereoprt.file_short_name = fine_info.path  group by 1,2,3,4,5;

----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : sch_fine_db
-- workflow_version : 19
-- create_user      : zhugl
-- task_name        : import_export
-- task_version     : 8
-- update_time      : 2024-01-23 18:08:11
-- sql_path         : \data_quality\sch_fine_db\import_export
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_app_infos where app_tp='import' ;

-- 前置SQL语句
delete from das.das_app_infos where  app_tp='export';

-- SQL语句
insert into das.das_app_infos
select
get_json_string(description,'$.app_nm') app_nm,
get_json_string(description,'$.app_type') app_type,
get_json_string(description,'$.table_nm') table_nm ,
get_json_string(description,'$.table_nm') table_nm ,
get_json_string(description,'$.db_nm') as db_nm,
get_json_string(task_params,'$.rawScript')as script,
task_type as script_tp,
NOW()
from das.das_mysql_dolphinscheduler_t_ds_task_definition where flag =1 and get_json_string(description,'$.app_nm') is not  null
group by 1,2,3,4,5,6,7;
