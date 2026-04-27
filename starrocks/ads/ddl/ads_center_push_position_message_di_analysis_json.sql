DROP TABLE IF EXISTS ads_center_push_position_message_di_analysis_json;
CREATE TABLE ads_center_push_position_message_di_analysis_json (
     dt               DATE         NOT NULL            COMMENT "分区日期"
    ,id               BIGINT       NOT NULL            COMMENT "主键id"
    ,push_position_id BIGINT                           COMMENT "push资源位id。center_push_position表id"
    ,generate_day     VARCHAR(255)                     COMMENT "记录生成日期（西五区），格式：yyyyMMdd,20240724"
    ,account_id       BIGINT                           COMMENT "用户id。如果是多个用户信息组合一起发送，则填充0，表示该条推送发送发送给多个用户"
    ,active_user_id   BIGINT                           COMMENT "是否活跃用户，用户id"
    ,push_type        VARCHAR(20000)                   COMMENT "发送的消息体 $.custom.pushType"
    ,group_id         VARCHAR(20000)                   COMMENT "发送的消息体 $.custom.groupId"
    ,push_jump_page   VARCHAR(20000)                   COMMENT "发送的消息体 $.custom.pushJumpPage"
    ,title            VARCHAR(20000)                   COMMENT "发送的消息体 $.custom.title"
    ,act              VARCHAR(2000)                    COMMENT "发送的消息体 $.custom.act.activityLink"
    ,utc_offset       INT                              COMMENT "UTC偏移量,用户所在时区相对于0时区的秒级偏移量"
    ,need_to_send_time DATETIME                        COMMENT "消息应该发送的时间。保存的时任意时区用户应该推送的时间转化为东八区时间保存"
    ,send_status      INT                              COMMENT "消息发送状态：1-已经发送，2-未发送，3-消息往Kafka发送失败，4-重复发送（对于资源位的用户消息已经发送过），5-频控发送失败"
    ,send_success_time DATETIME                        COMMENT "消息成功发送时间。东八区时间"
    ,token            VARCHAR(1000)                    COMMENT "推送的Token"
    ,error_message    VARCHAR(1000)                    COMMENT "失败消息"
    ,title_id         BIGINT                           COMMENT "标题id"
    ,content_id       BIGINT                           COMMENT "内容id"
    ,create_time      DATETIME                         COMMENT "创建时间"
    ,update_time      DATETIME                         COMMENT "更新时间"
    ,etl_tm           DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
)
PRIMARY KEY(dt, id)
COMMENT "push资源位需要推送的消息表-json解析后"
PARTITION BY RANGE(dt)
(PARTITION p20251024 VALUES ["2025-10-24", "2025-10-25"),
PARTITION p20251025 VALUES ["2025-10-25", "2025-10-26"),
PARTITION p20251026 VALUES ["2025-10-26", "2025-10-27"),
PARTITION p20251027 VALUES ["2025-10-27", "2025-10-28"),
PARTITION p20251028 VALUES ["2025-10-28", "2025-10-29"),
PARTITION p20251029 VALUES ["2025-10-29", "2025-10-30"),
PARTITION p20251030 VALUES ["2025-10-30", "2025-10-31"),
PARTITION p20251031 VALUES ["2025-10-31", "2025-11-01"),
PARTITION p20251101 VALUES ["2025-11-01", "2025-11-02"),
PARTITION p20251102 VALUES ["2025-11-02", "2025-11-03"),
PARTITION p20251103 VALUES ["2025-11-03", "2025-11-04"),
PARTITION p20251104 VALUES ["2025-11-04", "2025-11-05"),
PARTITION p20251105 VALUES ["2025-11-05", "2025-11-06"),
PARTITION p20251106 VALUES ["2025-11-06", "2025-11-07"),
PARTITION p20251107 VALUES ["2025-11-07", "2025-11-08"),
PARTITION p20251108 VALUES ["2025-11-08", "2025-11-09"),
PARTITION p20251109 VALUES ["2025-11-09", "2025-11-10"),
PARTITION p20251110 VALUES ["2025-11-10", "2025-11-11"),
PARTITION p20251111 VALUES ["2025-11-11", "2025-11-12"),
PARTITION p20251112 VALUES ["2025-11-12", "2025-11-13"),
PARTITION p20251113 VALUES ["2025-11-13", "2025-11-14"),
PARTITION p20251114 VALUES ["2025-11-14", "2025-11-15"),
PARTITION p20251115 VALUES ["2025-11-15", "2025-11-16"),
PARTITION p20251116 VALUES ["2025-11-16", "2025-11-17"),
PARTITION p20251117 VALUES ["2025-11-17", "2025-11-18"),
PARTITION p20251118 VALUES ["2025-11-18", "2025-11-19"),
PARTITION p20251119 VALUES ["2025-11-19", "2025-11-20"),
PARTITION p20251120 VALUES ["2025-11-20", "2025-11-21"),
PARTITION p20251121 VALUES ["2025-11-21", "2025-11-22"),
PARTITION p20251122 VALUES ["2025-11-22", "2025-11-23"),
PARTITION p20251123 VALUES ["2025-11-23", "2025-11-24"),
PARTITION p20251124 VALUES ["2025-11-24", "2025-11-25"),
PARTITION p20251125 VALUES ["2025-11-25", "2025-11-26"),
PARTITION p20251126 VALUES ["2025-11-26", "2025-11-27"),
PARTITION p20251127 VALUES ["2025-11-27", "2025-11-28"),
PARTITION p20251128 VALUES ["2025-11-28", "2025-11-29"),
PARTITION p20251129 VALUES ["2025-11-29", "2025-11-30"),
PARTITION p20251130 VALUES ["2025-11-30", "2025-12-01"),
PARTITION p20251201 VALUES ["2025-12-01", "2025-12-02"),
PARTITION p20251202 VALUES ["2025-12-02", "2025-12-03"),
PARTITION p20251203 VALUES ["2025-12-03", "2025-12-04"),
PARTITION p20251204 VALUES ["2025-12-04", "2025-12-05"),
PARTITION p20251205 VALUES ["2025-12-05", "2025-12-06"),
PARTITION p20251206 VALUES ["2025-12-06", "2025-12-07"),
PARTITION p20251207 VALUES ["2025-12-07", "2025-12-08"),
PARTITION p20251208 VALUES ["2025-12-08", "2025-12-09"),
PARTITION p20251209 VALUES ["2025-12-09", "2025-12-10"),
PARTITION p20251210 VALUES ["2025-12-10", "2025-12-11"),
PARTITION p20251211 VALUES ["2025-12-11", "2025-12-12"),
PARTITION p20251212 VALUES ["2025-12-12", "2025-12-13"),
PARTITION p20251213 VALUES ["2025-12-13", "2025-12-14"),
PARTITION p20251214 VALUES ["2025-12-14", "2025-12-15"),
PARTITION p20251215 VALUES ["2025-12-15", "2025-12-16"),
PARTITION p20251216 VALUES ["2025-12-16", "2025-12-17"),
PARTITION p20251217 VALUES ["2025-12-17", "2025-12-18"),
PARTITION p20260425 VALUES ["2025-12-18", "2025-12-19"])
DISTRIBUTED BY HASH(dt, id) BUCKETS 5
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-180",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "5",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;