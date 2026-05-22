----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table
-- task_version     : 14
-- update_time      : 2025-05-24 11:28:54
-- sql_path         : \data_quality\data_map\das_dict_table
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table
select  ifnull(a.id,b.id) as id,
        ifnull(a.table_id,b.table_id) as table_id,
        ifnull(a.db_nm,b.db_nm) as db_nm,
        ifnull(a.db_tp,b.db_tp) as db_tp,
        ifnull(a.table_nm,b.table_nm) as table_nm,
        ifnull(a.table_tp,b.table_tp) as table_tp,
        ifnull(a.comment,b.comment) as comment,
        ifnull(a.creator,b.creator) as creator,
        ifnull(a.status,b.status) as status,
        if(a.table_nm is null,1,0) as is_delete,
        ifnull(b.ctime,a.ctime) as ctime,
        ifnull(a.utime,b.utime) as utime,
        now() as etl_time
from
    (   select  id,table_id,a.table_nm,db_nm,db_tp,table_tp,comment,creator,status,ctime,
                if(b.operation_time is null or b.operation_time <= utime,utime,b.operation_time) as utime
        from
            (   select  1 as id,md5(concat(TABLE_NAME,TABLE_SCHEMA)) as table_id,TABLE_NAME as table_nm,TABLE_SCHEMA as db_nm,'starrocks' as db_tp,
                        case when TABLE_TYPE = 'VIEW' then 1
                             else   0  end as table_tp,
                        TABLE_COMMENT as comment,null as creator,0 as status,
                        CREATE_TIME as ctime,
                        ifnull(UPDATE_TIME,CREATE_TIME) as utime
                from information_schema.tables
            ) a
                left join
            (   select table_nm,operation_time,stmt
                from
                    (   select table_nm,operation_time,stmt,
                               row_number() over (partition by table_nm order by operation_time desc) as rn
                        from das.das_dict_table_ddl
                        where stmt like '%alter %' and table_nm not like '%\_bck%' and date(operation_time) = '${bf_1_dt}'
            ) a
        where rn = 1
    ) b
    on a.table_nm = b.table_nm
where db_nm in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log')
    ) a
    full join das.das_dict_table b
on a.table_nm = b.table_nm and a.db_nm = b.db_nm;
