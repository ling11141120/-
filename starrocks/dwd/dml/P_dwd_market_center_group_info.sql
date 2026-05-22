----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_market_center_group_info
-- workflow_version : 2
-- create_user      : zhugl
-- task_name        : tbl_dwd_market_center_group_info
-- task_version     : 2
-- update_time      : 2025-03-29 01:24:56
-- sql_path         : \starrocks\tbl_dwd_market_center_group_info\tbl_dwd_market_center_group_info
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_market_center_group_info
select
a.dt,
a.Id,
a.UserId,
a.GroupId,
a.LangId,
a.CreateTime,
a.EndTime,
a.StartTime,
a.SecondLangId,
c.Id,
c.Name,
c.LangId,
c.Status,
c.CreateTime,
c.UpdateTime,
c.Code,
c.IsSync,
c.GroupType,
c.GroupSyncTime,
c.GroupExecutionTime,
c.SecondLangId,
b.app_id_account,
b.mt,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
NOW()
from (select *  from  ods.ods_tidb_readernovel_tidb_tag_center_group_info where dt ='${bf_1_dt}' ) a
left join ods.ods_tidb_readernovel_tidb_tag_center_group_tag c on a.groupid = c.id
left join
(
select
b.app_id app_id_account,
b.mt,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.create_tm_account as regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
b.product_id,
b.user_id
from dim.dim_user_all_info b
)b on a.LangId =
	(case b.product_id
    when 3311 then 6
	when 3322 then 5
	when 3333 then 2
	when 3366 then 3
	when 3371 then 7
	when 3388 then 4
	when 3399 then 9
	when 3501 then 11
	when 3511 then 12
	when 8858 then 1
	when 7757 then 1
end ) and a.userid = b.user_id ;
