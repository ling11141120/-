----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_countrylevel
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tbl_dim_countrylevel
-- task_version     : 5
-- update_time      : 2025-03-27 22:21:02
-- sql_path         : \starrocks\tbl_dim_countrylevel\tbl_dim_countrylevel
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_countrylevel
with base as (
    select product_id,id,level,shortname,remark,isdelete,row_update_time,synclanguage,language
    from (
             select id,
                    level,
                    tmp.unnest as                                                          shortname,
                    if(remark is null or remark = '', null, remark)                         remark,
                    isdelete,
                    row_update_time,
                    if(synclanguage is not null and synclanguage <> '', synclanguage, null) synclanguage,
                    language,
                    product_id
             from (select *
                   from (-- -----ods-----
                            select *,
                                   row_number() over (partition by id,product_id order by row_update_time desc) rk
                            from ods.ods_tidb_ReaderNovel_xx_mysql_countrylevel
                        ) t1
                   where rk = 1) t2,unnest(split(shortname, ',')) tmp
         ) t3
    -- -----------
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)
select product_id,id,level,shortname,remark,isdelete,row_update_time,synclanguage,language,now() as etl_time
from(
select product_id,id,level,shortname,remark,isdelete,row_update_time,synclanguage,language
from base
union all
select 6833 as product_id,id,level,shortname,remark,isdelete,row_update_time,synclanguage,language
from base
where product_id=3366 -- --海剧参考阅读的国家等级，参考的是product_id=3366--;
)t1;
