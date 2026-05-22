----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_creator_mid
-- task_version     : 7
-- update_time      : 2025-05-24 01:22:32
-- sql_path         : \data_quality\data_map\das_dict_table_creator_mid
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_creator_mid
WITH tmp_table_name AS (
    select
            case
                when d.user_name = 'doupz' then 'dpz'
                when d.user_name = 'yanxh' then 'yxh'
                when d.user_name = 'zhengtt' then 'ztt'
                when d.user_name = 'linq' then 'lq'
                when d.user_name = 'zhugl' then 'zgl'
                when d.user_name = 'yaoqx' then 'yaoqx'
                else ''
            end as creator,
            case
                when a.task_params like '%udfs%' then regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","udfs',1)
                else  regexp_extract(replace(replace(a.task_params,'\\\\"','"'),'\\\\\\\\','\\\\'),'"sql":"(.*?)","sqlType',1)
            end as table_nm
    from das.das_mysql_dolphinscheduler_t_ds_task_instance a
             left join das.das_mysql_dolphinscheduler_t_ds_process_instance b on a.process_instance_id =b.id
             left join das.das_mysql_dolphinscheduler_t_ds_process_definition c on b.process_definition_code =c.code
             left join das.das_mysql_dolphinscheduler_t_ds_user d on c.user_id = d.id
    where   a.dt >=  date_sub(curdate(),interval 1 day)
      and c.project_code ='10857427255392' and a.task_type ='SQL' and a.state = 7

)
select  table_nm,creator,now() as etl_time
from
    (   select  table_nm,creator,
                row_number() over (partition by table_nm order by ranks) as rn
        from
            (   select  substr(table_nm,5) as table_nm,creator,2 as ranks
                from
                    (   select creator,
                               get_json_string(
                                   udf.parsesql2tablename(
                                   case
                                       when table_nm = '' then 'NULL'
                                       when table_nm is null then 'NULL'
                                       ELSE table_nm
                                    END)
                                   ,'$.insertTableName')
                                AS table_nm from tmp_table_name
                    ) a
                union all
                select table_nm,
                       case when operator in ('yxh','ztt','lq','zgl','yaoqx')  then operator
                            when operator in ('dpz','root','lsl') then 'dpz'
                            else '' end as creator,1 as ranks
                from das.das_dict_table_ddl
                where  dt >=  date_sub(curdate(),interval 1 day)  and lower(stmt) like '%create %'
            ) b
    ) c
where rn = 1 and table_nm is not null;
