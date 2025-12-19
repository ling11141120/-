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