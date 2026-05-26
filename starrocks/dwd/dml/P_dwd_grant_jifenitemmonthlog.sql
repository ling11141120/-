----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_grant_jifenitemmonthlog
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dwd_grant_jifenitemmonthlog
-- task_version     : 3
-- update_time      : 2024-01-26 14:20:58
-- sql_path         : \starrocks\tbl_dwd_grant_jifenitemmonthlog\tbl_dwd_grant_jifenitemmonthlog
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_grant_jifenitemmonthlog where dt =  dt ='${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_grant_jifenitemmonthlog
select
a.dt,a.productid,a.Id,a.UserId,a.Op,a.Num,a.ExpireTime,a.SendNum,a.SendTime,a.Source,a.SourceKey,a.CreateTime,a.AppId,
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
from (select dt,productid,Id,UserId,Op,Num,ExpireTime,SendNum,SendTime,Source,SourceKey,CreateTime,AppId  from  ods_log.ods_tidb_readerlog_xx_log_jifenitemmonthlog where dt ='${bf_1_dt}' ) a
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
)b on a.productid = b.product_id and a.userid = b.user_id;
