----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_consume_bookuserrewardlog
-- workflow_version : 4
-- create_user      : zhugl
-- task_name        : tbl_dwd_consume_bookuserrewardlog
-- task_version     : 4
-- update_time      : 2025-03-28 17:50:34
-- sql_path         : \starrocks\tbl_dwd_consume_bookuserrewardlog\tbl_dwd_consume_bookuserrewardlog
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_consume_bookuserrewardlog
select
a.dt,
a.product_id,
a.Id,
a.UserId,
a.BookId,
a.TotalMoney,
a.Money,
a.AwardMoney,
a.`Type`,
a.CreateTime,
a.AppId,
a.`Point`,
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
from ods_log.ods_tidb_readerlog_Log_BookUserRewardLog a
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
)b on a.product_id = b.product_id and a.userid = b.user_id and a.dt ='${bf_1_dt}';
