----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : dws_user_market_channel_info_detail_td_1
-- workflow_version : 1
-- create_user      : chenmo
-- task_name        : dws_user_market_channel_info_detail_td_1
-- task_version     : 1
-- update_time      : 2025-03-02 19:55:26
-- sql_path         : \starrocks\dws_user_market_channel_info_detail_td_1\dws_user_market_channel_info_detail_td_1
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_market_channel_info_detail_td_1
SELECT  * from dws.dws_user_market_channel_info_detail_td where dt = '${dt}';
