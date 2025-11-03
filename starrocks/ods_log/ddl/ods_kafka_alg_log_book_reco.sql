----------------------------------------------------------------
-- 目标表： ods_log.ods_kafka_alg_log_book_reco
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-22
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_kafka_alg_log_book_reco;
CREATE TABLE ods_log.ods_kafka_alg_log_book_reco (
     dt                 DATE     NOT NULL COMMENT "分区时间"
    ,userId             STRING   NOT NULL COMMENT "用户id"
    ,traceId            STRING   NOT NULL COMMENT "traceId"
    ,bookId             STRING   NOT NULL COMMENT "推荐书籍id"
    ,event_name         STRING            COMMENT "算法名称"
    ,metadata           STRING            COMMENT "metadata"
    ,beat               STRING            COMMENT "类型"
    ,source             STRING            COMMENT "路径"
    ,message            STRING            COMMENT "请求消息"
    ,host               STRING            COMMENT "请求机器host"
    ,event_time         DATETIME          COMMENT "请求算法时间"
    ,index              STRING            COMMENT "推荐书籍位序"
    ,reqstr             STRING            COMMENT "请求串"
    ,extendMap          STRING            COMMENT "扩展埋点"
    ,rankFeature        STRING            COMMENT "排序特征"
    ,pageId             STRING            COMMENT "推荐场景"
    ,timestamp_c        DATETIME          COMMENT "写入时间"
    ,project_id         STRING            COMMENT "项目ID"
    ,exp_id             STRING            COMMENT "实验ID"
    ,exp_grp_id         STRING            COMMENT "实验组ID"
    ,exp_grp_type       STRING            COMMENT "实验组类型"
    ,exp_type_id        STRING            COMMENT "实验类型ID"
    ,vip_type           STRING            COMMENT "VIP类型ID"
    ,traffic_allocation STRING            COMMENT "实验流量"
    ,project_name       STRING            COMMENT "项目名称"
    ,exp_name           STRING            COMMENT "实验名称"
    ,exp_create_time    STRING            COMMENT "实验创建时间"
    ,exp_update_time    STRING            COMMENT "实验更新时间"
    ,exp_grp_name       STRING            COMMENT "实验组名称"
) 
PRIMARY KEY(dt, userId, traceId, bookId)
COMMENT "event=book_reco 用户ltv预测"
PARTITION BY RANGE(dt)
(PARTITION p20251030 VALUES LESS THAN ("2025-10-31"))
DISTRIBUTED BY HASH(dt, userId, traceId, bookId) BUCKETS 3
PROPERTIES (
    "replication_num" = "2"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-15"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "210"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;