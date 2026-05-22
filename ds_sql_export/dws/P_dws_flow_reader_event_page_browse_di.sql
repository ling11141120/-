----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : dws_flow_reader_event_page_browse_di
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : dws_flow_reader_event_page_browse_di
-- task_version     : 8
-- update_time      : 2026-04-20 18:31:47
-- sql_path         : \starrocks\dws_flow_reader_event_page_browse_di\dws_flow_reader_event_page_browse_di
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_reader_event_page_browse_di where dt>='${bf_3_dt}' ;

-- SQL语句
insert into dws.dws_flow_reader_event_page_browse_di
-- --------阅读器进入事件 不同来源次数  分子。。-------
select dt
      ,COALESCE(app_product_id, 0) as product_id
      ,COALESCE(event, '') as event
      ,COALESCE(mt, '') as mt
      ,COALESCE(app_version, '') as appver
      ,COALESCE(app_core_ver, '') as corever
      ,COALESCE(read_source_page_id, 0) as page_id
      ,COALESCE(read_source_page_name, '') as page_name
      ,count(distinct rid) as page_view_cnt
      ,now() as etl_tm
from  dwd.dwd_sensors_production_readerExposure_view
where dt>='${bf_3_dt}' and read_source_page_id in (10005,100656,100655,10006)
group by 1,2,3,4,5,6,7,8
union all
-- ----------书架首页分母-----------------------
select dt
      ,COALESCE(app_product_id, 0) as product_id
      ,COALESCE(event, '') as event
      ,COALESCE(mt, '') as mt
      ,COALESCE(app_version, '') as appver
      ,COALESCE(app_core_ver, '') as corever
      ,COALESCE(page_id, 0) as page_id
      ,COALESCE(page_name, '') as page_name
      ,count(distinct rid) as page_view_cnt
      ,now() as etl_tm
from  dwd.dwd_sensors_production_itemclick_view
where dt>='${bf_3_dt}'
and page_id =10005
and element_id=100321
group by 1,2,3,4,5,6,7,8
union all
-- ----------书籍详情页分母-----------------------
select dt
      ,COALESCE(app_product_id, 0) as product_id
      ,COALESCE(event, '') as event
      ,COALESCE(mt, '') as mt
      ,COALESCE(appver, '') as appver
      ,COALESCE(app_core_ver, '') as corever
      ,COALESCE(page_id, 0) as page_id
      ,COALESCE(page_name, '') as page_name
      ,count(distinct rid) as page_view_cnt
      ,now() as etl_tm
from  dwd.dwd_sensors_production_element_click_view
where dt>='${bf_3_dt}'
and page_id =10006
and element_id= 100143
group by 1,2,3,4,5,6,7,8
union all
-- ----------deeplink深度链接-----------------------
select dt
      ,COALESCE(product_id, 0) as product_id
      ,COALESCE(event, '') as event
      ,COALESCE(mt, '') as mt
      ,COALESCE(appver, '') as appver
      ,COALESCE(corever, '') as corever
      ,COALESCE(element_id, 0) as page_id
      ,COALESCE(element_name, '') as page_name
      ,count(distinct rid) as page_view_cnt
      ,now() as etl_tm
from  dwd.dwd_sensors_production_deeplink_view
where dt>='${bf_3_dt}'
and element_id in (100655,100656)
group by 1,2,3,4,5,6,7,8
;
