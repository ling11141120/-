----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_firstday_readtime_mid
-- task_version     : 2
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_firstday_readtime_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_firstday_readtime_mid
select  product_id,user_id,start_day_read_time,now() as etl_time
from
(   select  product_id,user_id,start_day_read_time,
            row_number() over (partition by product_id,user_id order by dt) as rn
    from
        (   select product_id,user_id,start_day_read_time,'${bf_2_dt}' as dt
            from ads.ads_offline_label_user_firstday_readtime_mid
            union all
            select  product_id,user_id,sum(read_times) as start_day_read_time,dt
            from dws.dws_read_user_book_readtime_ed
            where dt = '${bf_1_dt}' and book_id != 0 and product_id != -1
            group by 1,2,4
        ) a
    ) b
where rn = 1;
