----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : data_map
-- workflow_version : 88
-- create_user      : admin
-- task_name        : das_dict_table_tablet
-- task_version     : 10
-- update_time      : 2024-02-02 16:20:57
-- sql_path         : \data_quality\data_map\das_dict_table_tablet
----------------------------------------------------------------
-- SQL语句
insert into das.das_dict_table_tablet
select '${dt}' as dt,
       a.TABLE_NAME as table_nm,
       a.TABLE_ROWS as row_cnt,
       a.DATA_LENGTH as data_size,
       case
        when b.TABLE_MODEL ='PRIMARY_KEYS' then '主键'
        when b.TABLE_MODEL ='AGG_KEYS' then '聚合'
        when b.TABLE_MODEL ='DUP_KEYS' then '明细'
        when b.TABLE_MODEL ='UNIQUE_KEYS' then '更新'
        when b.TABLE_MODEL ='' and a.TABLE_TYPE ='VIEW' then '视图'
        else '外表'
       end table_md,
       b.DISTRIBUTE_BUCKET bucket_cnt,
       c.partition_cnt,
       c.tablet_cnt,
       now() as etl_time
from information_schema.tables a
left join information_schema.tables_config b on a.TABLE_NAME = b.TABLE_NAME
left join (
  select
  TABLE_ID table_id,
  count(distinct PARTITION_ID) partition_cnt,
  count(distinct TABLET_ID) tablet_cnt
  from information_schema.be_tablets
  group by 1
) c on b.TABLE_ID =c.table_id
where a.TABLE_SCHEMA in ('ods','dwd','dim','dws','ads','alg','dwm','ods_log');
