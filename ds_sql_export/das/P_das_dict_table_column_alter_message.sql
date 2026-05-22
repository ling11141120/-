----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : table_column_change_message
-- workflow_version : 8
-- create_user      : zhengtt
-- task_name        : das_dict_table_column_alter_message
-- task_version     : 4
-- update_time      : 2024-01-02 14:19:21
-- sql_path         : \data_quality\table_column_change_message\das_dict_table_column_alter_message
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_dict_table_column_alter_message where dt = '${dt}';

-- SQL语句
insert into das.das_dict_table_column_alter_message
select  a.dt,a.md5_pri,a.db_nm,a.table_nm,a.message_type,a.massage_nm,a.comment,
        case when date(a.ctime) = date_sub(curdate(),interval 1 day) and  a.is_delete = 0 then 0
            when  a.is_delete = 1 and b.is_delete = 0 then 1
            when date(a.utime) < date_sub(curdate(),interval 1 day) then 3
        else 2 end as alter_status,
        now() as etl_time
from
(   select  dt,md5_pri,db_nm,table_nm,message_type,massage_nm,comment,is_delete,ctime,utime
    from das.das_dict_table_column_snap
    where dt = '${dt}' and message_type = 0
    ) a
left join
(   select  dt,db_nm,table_nm,message_type,massage_nm,comment,is_delete,ctime,utime
    from das.das_dict_table_column_snap
    where dt = date_sub('${dt}',interval 1 day) and message_type = 0
    ) b
on a.massage_nm = b.massage_nm and a.db_nm = b.db_nm
union all
select  a.dt,a.md5_pri,a.db_nm,a.table_nm,a.message_type,a.massage_nm,a.comment,
        case when date(a.ctime) = date_sub(curdate(),interval 1 day)  and a.is_delete = 0 then 0
             when  a.is_delete = 1 and b.is_delete = 0 then 1
             when date(a.utime) < date_sub(curdate(),interval 1 day) then 3
             else 2 end as alter_status,
        now() as etl_time
from
(   select  dt,md5_pri,db_nm,table_nm,message_type,massage_nm,comment,is_delete,ctime,utime
    from das.das_dict_table_column_snap
    where dt = '${dt}' and message_type = 1
    ) a
left join
(   select  dt,db_nm,table_nm,message_type,massage_nm,comment,is_delete,ctime,utime
    from das.das_dict_table_column_snap
    where dt = date_sub('${dt}',interval 1 day) and message_type = 1
    ) b
on a.massage_nm = b.massage_nm and a.table_nm = b.table_nm and a.db_nm = b.db_nm;
