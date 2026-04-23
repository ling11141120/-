----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_paywall_strategy_log
-- 来源实例： video-en-log-mysql-slave
-- 来源表： short_video_log.paywall_strategy_log
-- 来源负责： fjw
-- 开发人： qhr/xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_log_paywall_strategy_log;
create table ods.ods_tidb_short_video_log_paywall_strategy_log (
     dt               date        not null                     comment "日期，根据CreateTime转换而来"
    ,Id               bigint      not null                     comment "唯一ID"
    ,user_id          bigint                                   comment "用户账户ID"
    ,corever          int                                      comment "应用版本号"
    ,strategy_type    int                                      comment "策略类型"
    ,code             int                                      comment "业务状态码，10000 表示成功"
    ,strategy_id      bigint                                   comment "命中的策略 Id；无策略配置时为 0"
    ,template_id      bigint                                   comment "命中的模板 Id；无策略配置时为 0"
    ,node_path        string                                   comment "命中的节点名称路径"
    ,node_id_path     string                                   comment "命中的节点 Id 路径；兜底时为空字符串"
    ,is_default       int                                      comment "是否走了兜底逻辑"
    ,message          string                                   comment "响应消息"
    ,create_time      datetime                                 comment "创建时间"
    ,sr_createtime    datetime    default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime    datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, Id)
comment "短剧-付费墙策略日志表"
partition by date_trunc("month", dt)
distributed by hash(Id)
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
    ,"partition_live_number" = "24"
)
;