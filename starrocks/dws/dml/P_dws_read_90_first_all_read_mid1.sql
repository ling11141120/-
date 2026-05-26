----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_book_read_consume_inte3
-- workflow_version : 22
-- create_user      : linq
-- task_name        : dws_read_90_first_all_read_mid
-- task_version     : 11
-- update_time      : 2024-10-24 21:14:24
-- sql_path         : \starrocks\tbl_ads_book_read_consume_inte3\dws_read_90_first_all_read_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_read_90_first_all_read_mid1 where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_read_90_first_all_read_mid1
select dt, site_id,book_id, user_id,now() as etl_time
from(
    select a.dt,a.user_id,a.book_id,a.site_id,max(if(b.user_id is null,1,0)) as is_first
    from dws.dws_read_user_readbook_ed a
    left join (
        select dt,user_id,book_id,site_id
        from dws.dws_read_user_readbook_ed
        where dt>=date_sub('${bf_1_dt}',interval 90 day) and dt<='${dt}'
        group by 1,2,3,4
    )b on a.user_id=b.user_id and a.book_id=b.book_id and a.site_id=b.site_id
              -- 90天内首次
              and datediff(a.dt,b.dt)>0 and datediff(a.dt,b.dt)<=90
    where a.dt>='${bf_1_dt}' and a.dt<='${dt}'
    group by 1,2,3,4
)t1
where is_first=1;
