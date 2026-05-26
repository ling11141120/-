----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tal_dim_tag_center_activity_da
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : dim_tag_center_activity_da
-- task_version     : 2
-- update_time      : 2025-02-21 19:59:50
-- sql_path         : \starrocks\tal_dim_tag_center_activity_da\dim_tag_center_activity_da
----------------------------------------------------------------
-- SQL语句
insert into dim.`dim_tag_center_activity_da`
select date(now()) as dt,
activity_id,
activity_type,
tactics_id,
activity_name,
tactics_name,
j_group_ids,
exclude_j_group_ids,
begin_time,
end_time,
create_id,
create_time,
update_time,
now() as etl_tm
from ods.`ods_tidb_tag_center_activity`;
