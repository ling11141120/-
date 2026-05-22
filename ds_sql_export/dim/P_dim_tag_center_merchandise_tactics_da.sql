----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tal_dim_tag_center_merchandise_tactics_da
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dim_tag_center_merchandise_tactics_da
-- task_version     : 3
-- update_time      : 2025-02-24 11:52:43
-- sql_path         : \starrocks\tal_dim_tag_center_merchandise_tactics_da\dim_tag_center_merchandise_tactics_da
----------------------------------------------------------------
-- SQL语句
insert into dim.`dim_tag_center_merchandise_tactics_da`
select date(now()) as dt,
scene_type,
tactics_id,
tactics_name,
data_type,
begin_time,
end_time,
j_group_ids,
exclude_j_group_ids,
pattern_type,
merchandise_type,
status,
audit_status,
create_id,
create_time,
update_time,
now() as etl_tm
from ods.`ods_tidb_tag_center_merchandise_tactics`;
