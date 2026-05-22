----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_optimizergroups
-- workflow_version : 7
-- create_user      : zhengtt
-- task_name        : dim_optimizergroups
-- task_version     : 7
-- update_time      : 2024-03-27 10:35:44
-- sql_path         : \starrocks\tbl_dim_optimizergroups\dim_optimizergroups
----------------------------------------------------------------
-- 前置SQL语句
delete  from dim.dim_optimizergroups where dt = '${bf_1_dt}';

-- SQL语句
insert into dim.dim_optimizergroups
select '${bf_1_dt}' as dt,
       case when a.ProjectCode = 1 and a.Code not like '%测试%' then 0
            when a.ProjectCode = 2 and a.Code not like '%测试%' then 1
            else 3 end as optimizer_group_type,
       a.Code as ads_optimizer_group,
       b.Code as ads_optimizer,
       now() as etl_time
from ods.ods_tidb_sharpengine_ads_global_optimizergroupsnew a
         inner join ods.ods_tidb_sharpengine_ads_global_optimizergroupsnew b
                    on a.Id = b.ParentId
where a.GroupType = 1 and a.Enable = 1 and  a.subGroupType =1;
