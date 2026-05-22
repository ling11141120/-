----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_base_read_mid
-- task_version     : 17
-- update_time      : 2025-03-31 18:30:46
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_base_read_mid
----------------------------------------------------------------
-- SQL语句
-- 数据别删，上游表只保留了10天的数据
insert into ads.ads_report_AB_experiment_mul_base_read_mid
with read_event as (
    select dt, app_product_id as product_id,distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,is_first_read_book
    from dwd.dwd_sensors_production_startreadingchapter_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}'
    union all
    select dt, app_product_id as product_id,distinct_id as user_id, book_id,chapter_id, event_tm,read_chapter_sort,-99 as is_first_read_book
    from dwd.dwd_sensors_production_endreadingchapter_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}'
),x1 as (
   select dt, product_id,user_id, book_id, min(unix_timestamp(event_tm)) tt2
   from read_event
   where read_chapter_sort='1' and is_first_read_book='true'
   group by 1,2,3,4
)
select dt,source_types,product_id,user_id,book_id,now() as etl_time
from
(
    select x1.dt, source_types,x1.product_id,x1.user_id,x1.book_id
    from x1
    join(
        -- 榜单-猜你喜欢
        select dt, 1 as source_types,app_product_id as product_id,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and page_name='频道分页' and cast(distinct_id as bigint)>0
          and list_id in('1290005', '2010001', '1290007', '1290006', '1230018', '1230017', '1230016', '1200014', '1200016')
        group by 1,2,3,4,5,6
        union all
        -- 频道-猜你喜欢
        select dt, 2 as source_types,app_product_id as product_id ,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and module_channel_id=1440003 and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 退出弹窗
        select dt, 3 as source_types,app_product_id as product_id,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and list_id=1950006 and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 串书
        select dt, 4 as source_types,app_product_id as product_id,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and split(send_id,'_')[5]='8430227' and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 章末推
        select dt, 5 as source_types,app_product_id as product_id,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and activity_id=8651895  and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 末页推
        select dt, 6 as source_types,app_product_id as product_id,distinct_id as user_id, book_id, unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and list_id=2070005 and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 书架顶部 2024-03-21后取数逻辑有变(书架顶部取数有两部分)
        select dt,7 as source_types,app_product_id as product_id,distinct_id as user_id,book_id,unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and element_id=100366 and activity_id=8562191 and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
        union all
        -- 返回推
        select dt,8 as source_types,app_product_id as product_id,distinct_id as user_id,book_id,unix_timestamp(event_tm) tt1
        from dwd.dwd_sensors_production_itemexposure_view
        where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and element_id=100358 and cast(distinct_id as bigint)>0
        group by 1,2,3,4,5,6
    )x2 on x1.dt=x2.dt and x1.product_id=x2.product_id and x1.user_id=x2.user_id and x1.book_id=x2.book_id and tt2-tt1<20 and tt2-tt1>=0
    group by 1,2,3,4,5
)r;
