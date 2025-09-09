----------------------------------------------------------------
-- 目标表： ods.ods_short_video_commandtask
-- 来源实例： idc-tidb-查询
-- 来源表： short_video.commandtask
-- 采集工具： 极光-定时批量
-- 负责人： qhr
-- 开发日期： 2023-12-26
-- 备注： ClassType='user_refund'
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_short_video_commandtask;
CREATE TABLE ods.ods_short_video_commandtask (
     id             INT(11)        NOT NULL                  COMMENT ""
    ,classtype      VARCHAR(512)                             COMMENT ""
    ,args           VARCHAR(65533)                           COMMENT ""
    ,scheduletime   DATETIME                                 COMMENT ""
    ,status         INT(11)                                  COMMENT ""
    ,execcount      INT(11)                                  COMMENT ""
    ,exectime       DATETIME                                 COMMENT ""
    ,sr_createtime  DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT ""
    ,sr_updatetime  DATETIME                                 COMMENT ""
)
PRIMARY KEY (id)
COMMENT "短剧--订单退款记录"
DISTRIBUTED BY HASH (id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;