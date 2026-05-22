----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_edm_automated_recommend
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : dwd_sr_tag_center_action_log
-- task_version     : 2
-- update_time      : 2025-12-05 14:23:29
-- sql_path         : \starrocks\tbl_ads_sr_edm_automated_recommend\dwd_sr_tag_center_action_log
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_sr_tag_center_action_log
select
    date(CreateTime) as dt,
    Id,
    BatchId,
    UserId,
    CreateTime,
    Status,
    ActionType,
    BookId,
    ActionId,
    TitleId,
    ContentId,
    LangId,
    ChapterId,
    SecondLangId,
    SendTime,
    now() as etl_time
from ods.ods_tidb_readernovel_tidb_tag_center_action_log
where CreateTime >= '${bf_1_dt}' and BookId > 0;
