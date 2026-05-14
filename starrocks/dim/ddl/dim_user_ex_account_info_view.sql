CREATE VIEW `dim_user_ex_account_info_view` (`ex_type` COMMENT "第三方账号绑定类型：
1：qq
2：新浪
3：微信
4：facebook
5：line
6：google
7：twitter
8：华为
9：百度小程序
10：支付宝小程序
11：手q小程序
12：头条小程序
13：appleid", `ex_id` COMMENT "第三方账号id", `user_id` COMMENT "用户id", `ex_nick` COMMENT "第三方账号昵称", `bind_time` COMMENT "绑定时间")
COMMENT "阅读-有第三方账号的用户信息" AS SELECT `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`.`extype` AS `ex_type`, `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`.`exid` AS `ex_id`, `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`.`id` AS `user_id`, `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`.`exnick` AS `ex_nick`, `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`.`bindtime` AS `bind_time`
FROM `ods`.`ods_tidb_accountdb_tidb_hk_exaccount_exaccount`;
utf8
utf8_general_ci