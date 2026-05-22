----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_starrocks_monitor_alarm
-- workflow_version : 25
-- create_user      : xixg
-- task_name        : ads_starrocks_monitor_alarm
-- task_version     : 18
-- update_time      : 2024-12-09 14:12:02
-- sql_path         : \starrocks\sch_starrocks_monitor_alarm\ads_starrocks_monitor_alarm
----------------------------------------------------------------
-- SQL语句
INSERT INTO  ads.ads_starrocks_monitor_alarm
 SELECT
         DATE_FORMAT (NOW(), '%Y-%m-%d %H:%i'),
         user,
         db,
         queryTime,                                                         -- 执行时间审计日志表中中存储的是毫秒
         timestamp,                                                         -- SQL的具体执行时间
         cpuCostNs,                                                         -- CPU耗时审计日志中存储的是纳秒
         memCostBytes,
         state,
         stmt,
         NOW()
 FROM starrocks_audit_db__.starrocks_audit_tbl__ a
 WHERE  minutes_diff(NOW(),a.timestamp) <= 6        -- 前N分钟前的大查询，默认为3分钟
   AND a.user in ('finebi_user','report_user')                             -- 过滤出用户为finebi与report_user用户的SQL
  -- AND a.user in ('finebi_user','report_user','xixg')                             -- 过滤出用户为finebi与report_user用户的SQL
 AND  a.queryTime/1000 >= ${time_out_seconds}                                  --过滤出执行时间超过多长时间的查询语句，目前默认为1分钟;
