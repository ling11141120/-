----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_shuangwen_book_channel_income_config
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dim_shuangwen_book_channel_income_config
-- task_version     : 1
-- update_time      : 2023-09-09 16:46:40
-- sql_path         : \starrocks\tbl_dim_shuangwen_book_channel_income_config\dim_shuangwen_book_channel_income_config
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_shuangwen_book_channel_income_config
select product_id,Id,(ChannelBookId*1000+SiteId) as bookid,SiteId,Language,DelFlag,StartTime,ChannelBookId,AuthorId,Rate,CreateTime,now() as etl_time from ods.ods_tidb_shuangwen_book_channel_income_config;
