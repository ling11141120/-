----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_version_device_issue
-- 来源实例： old_tidb_source
-- 来源表： qadata.gp_app_version_device_issue
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2023-08-20
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_qadata_gp_app_version_device_issue;
CREATE TABLE ods.ods_tidb_qadata_gp_app_version_device_issue (
     Id               BIGINT        NOT NULL                  COMMENT 'Id'
    ,InitTime         DATETIME      NOT NULL                  COMMENT '数据写入时间'
    ,DeviceGuid       VARCHAR(150)                            COMMENT 'Guid'
    ,IssueId          VARCHAR(150)                            COMMENT '问题Id'
    ,IssueInfo        STRING                                  COMMENT '问题'
    ,IssueUserCount   INT                                     COMMENT '受影响用户数'
    ,IssueActiveCount INT                                     COMMENT '活动数'
    ,IssueActiveRate  DECIMAL(15,5)                           COMMENT '活动率'
    ,AndroidVersion   VARCHAR(300)                            COMMENT '安卓版本'
    ,FrontCount       INT                                     COMMENT '前台问题数量'
    ,BackCount        INT                                     COMMENT '后台问题数量'
    ,RamSize          INT                                     COMMENT '内存大小'
    ,RamTotalSize     INT                                     COMMENT '总内存大小'
    ,UpdateTime       DATETIME                                COMMENT '数据更新时间'
    ,sr_createtime    DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime    DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
PRIMARY KEY (Id, InitTime)
COMMENT '谷歌Play机型问题和机型属性'
DISTRIBUTED BY HASH (Id)
PROPERTIES("replication_num" = "3",
           "in_memory" = "false",
           "storage_format" = "DEFAULT",
           "enable_persistent_index" = "true",
           "compression" = "LZ4"
)
;