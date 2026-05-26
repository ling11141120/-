----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_subscribe_expire_time
-- workflow_version : 1
-- create_user      : hufengju
-- task_name        : ads_sr_user_subscribe_expire_time
-- task_version     : 1
-- update_time      : 2025-05-12 18:25:11
-- sql_path         : \starrocks\tbl_ads_sr_user_subscribe_expire_time\ads_sr_user_subscribe_expire_time
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_user_subscribe_expire_time`
select product_id,user_id,max(vip_expire_time) as vip_expire_time,max(svip_expire_time) as svip_expire_time,max(sign_expire_time) as sign_expire_time,now() as etl_tm
from (
	select product_id,Id as user_id,
		date(date_add(greatest(VipExpireTime,VipSecondsStartTime),interval VipExpireTimeSeconds Second)) as vip_expire_time,
		date(date_add(greatest(LowVipExpireTime,LowVipSecondsStartTime),interval LowVipExpireTimeSeconds Second)) as svip_expire_time,
		date('1970-01-01 00:00:00') as sign_expire_time
	from ods.ods_tidb_readernovel_tidb_userdata
	-- where VipExpireTime>'1970-01-01 00:00:00'
	-- and id=124379649

	union all

	select productid as product_id,Id as user_id,date('1970-01-01 00:00:00') as vip_expire_time,date('1970-01-01 00:00:00') as svip_expire_time,max(date(get_json_string(value,"$.BonusSignCardTime"))) as expire_time
	from (
		SELECT *
		FROM ods.ods_tidb_readernovel_tidb_xx_usersigncarddata,lateral json_each(SignCards)
		-- where id=113040365
	) a
	group by 1,2
) a
where vip_expire_time>'1970-01-01' or svip_expire_time>'1970-01-01' or sign_expire_time>'1970-01-01'
group by 1,2;
