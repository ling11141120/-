----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_cd_user_tags_df
-- workflow_version : 1
-- create_user      : admin
-- task_name        : ads_cd_user_tags_df
-- task_version     : 1
-- update_time      : 2023-04-20 14:42:22
-- sql_path         : \starrocks\ads_cd_user_tags_df\ads_cd_user_tags_df
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_cd_user_tags_df partition (p'${pname}')
select *
from bd_user_group.cd_user_tags_df partition p'${pname}';
