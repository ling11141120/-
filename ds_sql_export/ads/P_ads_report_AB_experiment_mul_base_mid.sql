----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_base_mid
-- task_version     : 25
-- update_time      : 2025-03-11 16:58:24
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_base_mid
----------------------------------------------------------------
-- SQL语句
-- 数据别删，上游表只保留了10天的数据
insert into ads.ads_report_AB_experiment_mul_base_mid
select dt,source_types,app_product_id as product_id,ifnull(app_lang_id,-99) as lang_id,user_id,book_id,
   array_filter(array_distinct(array_agg(page_name)),x->x is not null) as page_name,
   array_filter(array_distinct(array_agg(list_id)),x->x is not null) as list_id,
   array_filter(array_distinct(array_agg(module_channel_id)),x->x is not null) as module_channel_id,
   array_filter(array_distinct(array_agg(send_id)),x->x is not null and x !='') as send_id,
   array_filter(array_distinct(array_agg(active_point_id)),x->x is not null) as active_point_id,
   array_filter(array_distinct(array_agg(element_id)),x->x is not null) as element_id,
   array_filter(array_distinct(array_agg(element_type)),x->x is not null) as element_type,
   array_filter(array_distinct(array_agg(activity_id)),x->x is not null) as activity_id,
   now() as etl_time
from(
    -- 榜单-猜你喜欢
    select dt, 1 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and page_name='频道分页' and cast(distinct_id as bigint)>0
      and list_id in('1290005', '2010001', '1290007', '1290006', '1230018', '1230017', '1230016', '1200014', '1200016')
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14,12,13,14
    union all
    -- 频道-猜你喜欢
    select dt, 2 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and module_channel_id=1440003 and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    union all
    -- 退出弹窗
    select dt, 3 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and list_id=1950006 and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    union all
    -- 串书
    select dt, 4 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and split(send_id,'_')[5]='8430227'  and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    union all
    -- 章末推
    select dt, 5 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and activity_id=8651895  and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    -- 末页推
    union all
    select dt, 6 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and list_id=2070005 and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    -- 书架顶部 2024-03-21后取数逻辑有变(书架顶部取数有两部分)
    union all
    select dt, 7 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and element_id=100366 and activity_id=8562191 and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
    -- 返回推
    union all
    select dt, 8 as source_types,app_product_id,app_lang_id, distinct_id as user_id, page_name,list_id,module_channel_id,
           send_id,split(send_id,'_')[5] as active_point_id,element_id,element_type,activity_id,book_id
    from dwd.dwd_sensors_production_itemexposure_view
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}' and element_id=100358 and cast(distinct_id as bigint)>0
    group by 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14
)t1
where app_product_id is not null
group by 1,2,3,4,5,6;
