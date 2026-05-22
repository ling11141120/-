----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_SyncBi_ads_sv_user_subscription
-- workflow_version : 17
-- create_user      : hufengju
-- task_name        : ads_sv_user_subscription
-- task_version     : 6
-- update_time      : 2025-05-13 15:20:52
-- sql_path         : \starrocks\tbl_SyncBi_ads_sv_user_subscription\ads_sv_user_subscription
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sv_user_subscription`
SELECT
	`dwd`.`dwd_trade_short_video_payorder`.`user_id`,
	CASE
		WHEN (`dwd`.`dwd_trade_short_video_payorder`.`shop_item` IN (810)) THEN 'VIP'
		WHEN (`dwd`.`dwd_trade_short_video_payorder`.`shop_item` IN (840)) THEN '签到卡'
	END AS `shop_item_type`,
	`dwd`.`dwd_trade_short_video_payorder`.`create_time`,
	`dwd`.`dwd_trade_short_video_payorder`.`vip_expire_time`,
	SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'com.changdu.mobovideo.',-1),'com.changdu.moboshort.',-1),'com.changjian.moboshortcj.',-1),'third.',-1) as item_id,
	order_id,
	now()
FROM
	`dwd`.`dwd_trade_short_video_payorder`
WHERE
	`dwd`.`dwd_trade_short_video_payorder`.`shop_item` IN (810, 840)
and date(create_time)='${bf_1_dt}'
	;
