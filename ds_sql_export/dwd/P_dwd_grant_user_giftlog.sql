----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_grant_user_giftlog
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : tbl_dwd_grant_user_giftlog
-- task_version     : 4
-- update_time      : 2024-11-16 17:33:48
-- sql_path         : \starrocks\tbl_dwd_grant_user_giftlog\tbl_dwd_grant_user_giftlog
----------------------------------------------------------------
-- SQL语句
INSERT into dwd.dwd_grant_user_giftlog
SELECT
    dt,
    product_id,
    id,
    optype as op_type,
    userid as user_id,
    giftnum as gift_num,
    expiretime as expire_time,
    source,
    sendnum as send_num,
    sendtime as send_time,
    gifttype as gift_type,
    createtime as create_time,
    appid,
    positionid as position_id,
    appgameid as app_game_id,
    sourcekey as source_key,
    sourceargs as source_args,
    ModuleSendId as ModuleSendId,
    now() as etl_time
from
    ods_log.ods_tidb_readerlog_log_giftlog
where
    dt >= '${bf_1_dt}'
  and dt < date(date_add('${bf_1_dt}', interval 1 day));
