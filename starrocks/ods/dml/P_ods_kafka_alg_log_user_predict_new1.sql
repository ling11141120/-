----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ods_kafka_alg_log_user_predict_new1_by_history
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : ods_kafka_alg_log_user_predict_new1
-- task_version     : 1
-- update_time      : 2024-02-01 19:38:29
-- sql_path         : \starrocks\ods_kafka_alg_log_user_predict_new1_by_history\ods_kafka_alg_log_user_predict_new1
----------------------------------------------------------------
-- SQL语句
-- 2023-08-07   2024-02-01
   insert into ods_log.`ods_kafka_alg_log_user_predict_new1`
  select dt, userId, event_time, reqstr, bookId, traceId, event_name, metadata, beat, source, message, `host`, `index`, extendMap, rankFeature, pageId, timestamp_c
  from ods_log.`ods_kafka_alg_log_user_predict`
  where  dt>='${bf_1_dt}' and dt<'${dt}';
