----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_col
-- task_version     : 9
-- update_time      : 2023-12-29 10:19:57
-- sql_path         : \data_quality\data_map\das_dict_table_col
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_col
select  ifnull(a.table_id,b.table_id) as table_id,ifnull(a.table_name,b.table_name) as table_name,
        ifnull(a.col_nm,b.col_nm) as col_nm,ifnull(a.col_type,b.col_type) as col_type,
        ifnull(a.ordinal_position,null),ifnull(a.comment,b.comment) as comment,
        ifnull(a.default_val,b.default_val) as default_val,ifnull(a.is_pri,b.is_pri) as is_pri,
        ifnull(a.is_dis,b.is_dis) as is_dis,ifnull(a.is_par,b.is_par) as is_par,
        if(a.col_nm is null,1,0) as is_delete,
        ifnull(b.ctime,a.ctime) as ctime,
        (case when b.col_nm is null then a.ctime
              when a.col_nm is null and b.is_delete = 0 then now()
              when b.col_nm is not null and a.col_nm is not null and
                   (a.comment != b.comment or ifnull(a.default_val,99) != ifnull(b.default_val,99)
                       or a.is_pri != b.is_pri or a.is_dis != b.is_dis
                       or a.is_par != b.is_par ) then now()
              else b.utime end
            ) as utime,
        now() as etl_time
from
    (   select  a.table_id as table_id,a.table_name as table_name,
                a.col_nm as col_nm,a.col_type as col_type,a.ordinal_position,a.comment as comment,a.default_val as default_val,
                if(b.PRIMARY_col is not null,1,0) as is_pri,
                if(d.DISTRIBUTE_col is not null,1,0) as is_dis,
                if(c.PARTITION_col is not null,1,0) as is_par,
                now() as ctime
        from
            (   select 1 as table_id,TABLE_NAME as table_name,COLUMN_NAME as col_nm,DATA_TYPE as col_type,
                       ORDINAL_POSITION as ordinal_position,COLUMN_COMMENT as comment,COLUMN_DEFAULT as default_val
                from information_schema.columns
                where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log')
                  and lower(substr(TABLE_NAME,1,3)) = lower(substr(TABLE_SCHEMA,1,3))
            )a
                left join
            (   select  TABLE_NAME as table_name,t1.unnest as PRIMARY_col
                from
                    (   select  TABLE_NAME,split(replace(PRIMARY_KEY,'`',''),', ') as PRIMARY_cols
                        from information_schema.tables_config
                        where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log') and PRIMARY_KEY is not null
                    )a,
                    unnest(PRIMARY_cols) as t1
            )b
            on a.table_name = b.table_name and a.col_nm = b.PRIMARY_col
                left join
            (   select  TABLE_NAME as table_name,t2.unnest as PARTITION_col
                from
                    (   select  TABLE_NAME,split(replace(PARTITION_KEY,'`',''),', ') as PARTITION_cols
                        from information_schema.tables_config
                        where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log') and PARTITION_KEY is not null
                    )a,
                    unnest(PARTITION_cols) as t2
            )c
            on a.table_name = c.table_name and a.col_nm = c.PARTITION_col
                left join
            (   select  TABLE_NAME as table_name,t2.unnest as DISTRIBUTE_col
                from
                    (   select  TABLE_NAME,split(replace(DISTRIBUTE_KEY,'`',''),', ') as DISTRIBUTE_cols
                        from information_schema.tables_config
                        where TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log') and DISTRIBUTE_KEY is not null
                    )a,
                    unnest(DISTRIBUTE_cols) as t2
            )d
            on a.table_name = d.table_name and a.col_nm = d.DISTRIBUTE_col
    )a
    full join das.das_dict_table_col b
on a.table_name = b.table_name and a.col_nm = b.col_nm;
