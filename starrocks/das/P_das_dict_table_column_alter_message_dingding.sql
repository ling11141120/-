----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : table_column_change_message
-- workflow_version : 8
-- create_user      : zhengtt
-- task_name        : das_dict_table_column_alter_message_dingding
-- task_version     : 4
-- update_time      : 2023-12-23 17:14:38
-- sql_path         : \data_quality\table_column_change_message\das_dict_table_column_alter_message_dingding
----------------------------------------------------------------
-- 前置SQL语句
delete from das.das_dict_table_column_alter_message_dingding where dt = '${dt}';

-- SQL语句
insert into das.das_dict_table_column_alter_message_dingding
select  dt,md5(concat(type,operate,comment)) as md5_pri,type,operate,comment,now() as etl_time
from
(   select  curdate() as dt,case when message_type = 0 then '表' else '字段' end as type,
            concat(case when alter_status = 0 then '新增'
                        when alter_status = 1 then '删除' end ,
                   case when message_type = 0 then '表'
                        when message_type = 1 then '字段' end,
                   db_nm,'.',table_nm,
                   case when message_type = 0 then ''
                        when message_type = 1 then concat('.',massage_nm) end) as operate,
            comment
    from
        (   select  a.db_nm as db_nm,a.table_nm as table_nm,a.message_type as message_type,
                    a.alter_status as alter_status,a.massage_nm as massage_nm,a.comment as comment
            from
                (   select db_nm,table_nm,message_type,alter_status,massage_nm,comment
                    from das.das_dict_table_column_alter_message
                    where alter_status in (0,1) and dt = '${dt}' and message_type = 1 and db_nm in ('dim','dws','ads')
                ) a
                    left join
                (   select db_nm,table_nm,alter_status
                    from das.das_dict_table_column_alter_message
                    where alter_status in (0,1) and dt = '${dt}' and message_type = 0 and db_nm in ('dim','dws','ads')
                ) b
                on a.db_nm = b.db_nm and a.table_nm = b.table_nm and a.alter_status = b.alter_status
            where b.table_nm is null
            union all
            select db_nm,table_nm,message_type,alter_status,massage_nm,comment
            from das.das_dict_table_column_alter_message
            where alter_status in (0,1) and dt = '${dt}' and message_type = 0 and db_nm in ('dim','dws','ads')
        ) a
    ) fin;
