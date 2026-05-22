----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : table_column_change_message
-- workflow_version : 8
-- create_user      : zhengtt
-- task_name        : das_dict_table_column_snap
-- task_version     : 1
-- update_time      : 2023-12-23 16:34:03
-- sql_path         : \data_quality\table_column_change_message\das_dict_table_column_snap
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_column_snap
select  curdate() as dt,md5(concat(db_nm,table_nm,'0',table_nm)) as md5_pri,db_nm,
        table_nm,0 as message_type,table_nm as massage_nm,comment,ctime,utime,is_delete,
        now() as etl_time
from das.das_dict_table
where table_nm not like '%\_bck%'
union all
select  curdate() as dt,md5(concat(b.db_nm,a.table_name,'1',col_nm)) as md5_pri,b.db_nm,
        a.table_name,1 as message_type,col_nm as massage_nm,a.comment,a.ctime,a.utime,a.is_delete,
        now() as etl_time
from das.das_dict_table_col a
inner join das.das_dict_table b
on a.table_name = b.table_nm
where table_name not like '%\_bck%';
