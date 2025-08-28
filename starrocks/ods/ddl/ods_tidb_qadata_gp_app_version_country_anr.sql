----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_version_country_anr
-- 来源实例： old_tidb_source
-- 来源表： qadata.gp_app_version_country_anr
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2023-08-20
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_qadata_gp_app_version_country_anr;
CREATE TABLE ods.ods_tidb_qadata_gp_app_version_country_anr (
     Id            bigint        not null                  comment 'Id'
    ,InitTime      datetime      not null                  comment '数据写入时间'
    ,StartTime     datetime                                comment '抓取日期'
    ,ProductId     int                                     comment '产品Id'
    ,Core          int                                     comment 'Core'
    ,Lang          varchar(60)                             comment '语言'
    ,VersionCode   bigint                                  comment '版本号'
    ,CountryName   varchar(30)                             comment '国家'
    ,AnrCount      int                                     comment 'ANR个数'
    ,AnrRate       decimal(15,5)                           comment 'ANR率'
    ,SessionCount  varchar(60)                             comment '会话数'
    ,UpdateTime    datetime                                comment '数据更新时间'
    ,AnrTime       datetime                                comment 'ANR日期'
    ,sr_createtime datetime      default current_timestamp comment 'starrocks数据注入时间'
    ,sr_updatetime datetime      default current_timestamp comment 'starrocks数据更新时间'
)
DUPLICATE KEY (Id, InitTime)
COMMENT '谷歌Play国家维度ANR率'
PARTITION BY DATE_TRUNC('month', InitTime)
DISTRIBUTED BY HASH (Id)
PROPERTIES("replication_num" = "3",
           "in_memory" = "false",
           "storage_format" = "DEFAULT",
           "enable_persistent_index" = "true",
           "compression" = "LZ4"
)
;