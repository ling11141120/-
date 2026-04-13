
 insert into dws.dws_flow_reader_event_page_browse_di
-- --------阅读器进入事件 不同来源次数  分子。。-------
select dt,app_product_id as product_id,event,mt,app_version as appver,app_core_ver as corever,read_source_page_id as page_id,read_source_page_name as page_name,count(distinct rid) as page_view_cnt,now() as etl_tm
from  dwd.dwd_sensors_production_readerExposure_view
where dt>='${bf_3_dt}' and read_source_page_id in (10005,100656,100655,10006)
group by 1,2,3,4,5,6,7,8
union all
-- ----------书架首页分母-----------------------
select dt,app_product_id as product_id,event,mt, app_version as appver,app_core_ver as corever,page_id,page_name,count(distinct rid) as page_view_cnt,now() as etl_tm
from  dwd.dwd_sensors_production_itemclick_view
where dt>='${bf_3_dt}'
and page_id =10005
and element_id=100321
group by 1,2,3,4,5,6,7 ,8
union all
-- ----------书籍详情页分母-----------------------
select dt,app_product_id as product_id,event,mt, appver, app_core_ver as corever,page_id,page_name,count(distinct rid) as page_view_cnt,now() as etl_tm
from  dwd.dwd_sensors_production_element_click_view
where dt>='${bf_3_dt}'
and page_id =10006
and element_id= 100143
group by 1,2,3,4,5,6,7 ,8
union all

-- ----------deeplink深度链接-----------------------
select dt, product_id,event,mt, appver, corever,element_id as page_id ,element_name as page_name,count(distinct rid) as page_view_cnt,now() as etl_tm
from  dwd.dwd_sensors_production_deeplink_view
where dt>='${bf_3_dt}'
and element_id in (100655,100656)
group by 1,2,3,4,5,6,7 ,8

;