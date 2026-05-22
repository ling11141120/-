----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_video_center_series_bill_info
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : dim_short_video_center_series_bill_info
-- task_version     : 1
-- update_time      : 2024-01-02 16:59:06
-- sql_path         : \starrocks\tbl_dim_short_video_center_series_bill_info\dim_short_video_center_series_bill_info
----------------------------------------------------------------
-- SQL语句
insert overwrite dim.dim_short_video_center_series_bill_info
select  6833 as product_id,a.billid as bill_id,a.weight,a.begintime as  begin_time,
a.endtime as end_time,a.langid as lang_id ,a.delstatus as del_status,a.createtime as create_time ,a.updatetime as update_time,a.seriesid as series_id, b.name,b.billtype as bill_type,now() as etl_tm
from ods.ods_tidb_short_video_center_series_bill_info a
left join
ods.ods_tidb_short_video_center_series_bill b
on a.billid =b.id;
