DROP TABLE IF EXISTS dwd.dwd_center_push_position_message_di;
CREATE TABLE dwd.dwd_center_push_position_message_di (
     dt                DATE           NOT NULL            COMMENT "分区日期"
    ,id                BIGINT         NOT NULL            COMMENT "主键id"
    ,push_position_id  BIGINT                             COMMENT "push资源位id。center_push_position表id"
    ,generate_day      VARCHAR(255)                       COMMENT "记录生成日期（西五区），格式：yyyyMMdd,20240724"
    ,account_id        BIGINT                             COMMENT "用户id。如果是多个用户信息组合一起发送，则填充0，表示该条推送发送发送给多个用户"
    ,app_id            INT                                COMMENT "app_id"
    ,msg_body          VARCHAR(30000)                     COMMENT "发送的消息体"
    ,utc_offset        INT                                COMMENT "UTC偏移量,用户所在时区相对于0时区的秒级偏移量"
    ,need_to_send_time DATETIME                           COMMENT "消息应该发送的时间。保存的时任意时区用户应该推送的时间转化为东八区时间保存"
    ,send_status       INT                                COMMENT "消息发送状态：1-已经发送，2-未发送，3-消息往Kafka发送失败，4-重复发送（对于资源位的用户消息已经发送过），5-频控发送失败"
    ,send_success_time DATETIME                           COMMENT "消息成功发送时间。东八区时间"
    ,token             VARCHAR(1000)                      COMMENT "推送的Token"
    ,error_message     VARCHAR(1000)                      COMMENT "失败消息"
    ,title_id          BIGINT                             COMMENT "标题id"
    ,content_id        BIGINT                             COMMENT "内容id"
    ,create_time       DATETIME                           COMMENT "创建时间"
    ,update_time       DATETIME                           COMMENT "更新时间"
    ,etl_tm            DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) PRIMARY KEY(dt, id)
COMMENT "push资源位需要推送的消息表"
PARTITION BY RANGE(dt)
(PARTITION p20251021 VALUES LESS THAN ("2025-10-22"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 3
PROPERTIES (
    "replication_num" = "2"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-3650"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "3"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"storage_medium" = "SSD"
    ,"compression" = "ZSTD"
)
;