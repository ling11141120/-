----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sr_user_subscribe_expire_time
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dwd_sr_user_subscribe_expire_time
-- task_version     : 2
-- update_time      : 2025-05-14 14:54:22
-- sql_path         : \starrocks\tbl_dwd_sr_user_subscribe_expire_time\dwd_sr_user_subscribe_expire_time
----------------------------------------------------------------
-- SQL语句
insert into dwd.`dwd_sr_user_subscribe_expire_time`
select product_id,user_id,max(vip_expire_time) as vip_expire_time,max(svip_expire_time) as svip_expire_time,max(sign_expire_time) as sign_expire_time,now() as etl_tm
from (
	select product_id,Id as user_id,
		date(date_add(greatest(VipExpireTime,VipSecondsStartTime),interval VipExpireTimeSeconds Second)) as svip_expire_time,
		date(date_add(greatest(LowVipExpireTime,LowVipSecondsStartTime),interval LowVipExpireTimeSeconds Second)) as vip_expire_time,
		date('1970-01-01 00:00:00') as sign_expire_time
	from ods.ods_tidb_readernovel_tidb_userdata
	-- where VipExpireTime>'1970-01-01 00:00:00'
	-- and id=124379649

	union all

	select productid as product_id,Id as user_id,date('1970-01-01 00:00:00') as svip_expire_time,date('1970-01-01 00:00:00') as vip_expire_time,max(sign_expire_time) as sign_expire_time
	from (
		SELECT *,date(get_json_string(value,"$.BonusSignCardTime")) as sign_expire_time
		FROM ods.ods_tidb_readernovel_tidb_xx_usersigncarddata,lateral json_each(SignCards)
		 --where id=113040365
	) a
	where sign_expire_time<'${bf_1_dt}'
	group by 1,2
) a
where vip_expire_time>'1970-01-01' or svip_expire_time>'1970-01-01' or sign_expire_time>'1970-01-01'
group by 1,2;
