----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_grant_medalitem
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_dwd_grant_medalitem
-- task_version     : 1
-- update_time      : 2023-09-21 17:12:31
-- sql_path         : \starrocks\tbl_dwd_grant_medalitem\tbl_dwd_grant_medalitem
----------------------------------------------------------------
-- SQL语句
delete from  dwd.dwd_grant_medalitem where 1=1;

-- SQL语句
insert into dwd.dwd_grant_medalitem
select
productid,
Id,
Pid,
MedalNum,
ExpireTime,
Source,
SendNum,
SendTime,
SourceKey,
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
from ods.ods_tidb_readernovel_tidb_xx_medalitem a
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
)b on a.productid = b.product_id and a.pid = b.user_id ;
