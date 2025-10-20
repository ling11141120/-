----------------------------------------------------------------
-- 目标表： ods.ods_center_push_position_message
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 
-- 开发人： qhr
-- 开发日期： 2025-10-15
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_center_push_position_message;
CREATE TABLE ods.ods_center_push_position_message (
     id                BIGINT       NOT NULL                  COMMENT "主键id"
    ,push_position_id  BIGINT                                 COMMENT "push资源位id。center_push_position表id"
    ,generate_day      VARCHAR(255)                           COMMENT "记录生成日期（西五区），格式：yyyyMMdd,20240724"
    ,account_id        BIGINT                                 COMMENT "用户id。如果是多个用户信息组合一起发送，则填充0，表示该条推送发送发送给多个用户"
    ,msg_body          JSON                                   COMMENT "发送的消息体"
    ,utc_offset        INT                                    COMMENT "UTC偏移量,用户所在时区相对于0时区的秒级偏移量"
    ,need_to_send_time DATETIME                               COMMENT "消息应该发送的时间。保存的时任意时区用户应该推送的时间转化为东八区时间保存"
    ,send_status       INT                                    COMMENT "消息发送状态：1-已经发送，2-未发送，3-消息往Kafka发送失败，4-重复发送（对于资源位的用户消息已经发送过），5-频控发送失败"
    ,send_success_time DATETIME                               COMMENT "消息成功发送时间。东八区时间"
    ,create_time       DATETIME                               COMMENT "创建时间"
    ,update_time       DATETIME                               COMMENT "更新时间"
    ,sr_createtime     DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
    ,sr_updatetime     DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "数据更新时间"
)
PRIMARY KEY(id)
COMMENT "push资源位需要推送的消息表"
DISTRIBUTED BY HASH(id) BUCKETS 500
PROPERTIES (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "false"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;