----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_SyncBi_ads_sv_user_subscription
-- workflow_version : 17
-- create_user      : hufengju
-- task_name        : ads_sv_user_cancel_subscription
-- task_version     : 5
-- update_time      : 2025-05-15 16:14:17
-- sql_path         : \starrocks\tbl_SyncBi_ads_sv_user_subscription\ads_sv_user_cancel_subscription
----------------------------------------------------------------
-- SQL语句
insert into  ads.`ads_sv_user_cancel_subscription`
SELECT
	`user_id`,
	CASE
		WHEN `shop_item_id` IN (810) THEN 'VIP'
		WHEN `shop_item_id` IN (840) THEN '签到卡'
		else shop_item_id
	END AS `shop_item_type`,
	`cancel_time`,now()
FROM
	`dwd`.`dwd_pay_order_notify`
WHERE
	`product_id` = 6833
	and shop_item_id IN (810,840)
    and notify_type=3
	AND `user_id` > 0
and date(cancel_time)='${bf_1_dt}';
