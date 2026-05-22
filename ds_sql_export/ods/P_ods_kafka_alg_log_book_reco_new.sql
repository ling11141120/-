----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ods_kafka_alg_log_book_reco_new_by_history
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : ods_kafka_alg_log_book_reco_new_by_history
-- task_version     : 1
-- update_time      : 2024-02-01 19:11:53
-- sql_path         : \starrocks\ods_kafka_alg_log_book_reco_new_by_history\ods_kafka_alg_log_book_reco_new_by_history
----------------------------------------------------------------
-- SQL语句
-- 时间从  dt='2023-10-01'  写到  dt='2024-01-29'
insert into  ods_log.ods_kafka_alg_log_book_reco_new
select dt, userId, traceId, bookId, event_name, metadata, beat, source, message, `host`,event_time, `index`, reqstr, extendMap, rankFeature, pageId, timestamp_c
from  ods_log.ods_kafka_alg_log_book_reco
where  dt>='${bf_1_dt}' and dt<'${dt}';
