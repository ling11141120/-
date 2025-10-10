----------------------------------------------------------------
-- 目标表： ods_tidb_readernovel_tidb_tag_center_third_payment_global
-- 来源实例： idc-tidb
-- 来源表： readernovel_tidb_tag.center_third_payment_global
-- 采集工具： 极光-定时批量
-- 开发人： xjc
-- 开发日期： 2025-10-10
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_tag_center_third_payment_global;
CREATE TABLE ods.ods_tidb_readernovel_tidb_tag_center_third_payment_global (
     id                  bigint           not null                              comment "主键"
    ,applangid           int(11)          not null                              comment "app语言"
    ,jgroupids           varchar(3000)                                          comment "极光选中人群包"
    ,excludejgroupids    varchar(300)                                           comment "极光剔除人群包"
    ,status              int(11)          not null                              comment "状态（0关闭，1开启）"
    ,createtime          datetime         not null                              comment "创建时间"
    ,updatetime          datetime         not null                              comment "修改时间"
    ,sr_createtime       datetime         default current_timestamp             comment "starrocks数据注入时间"
    ,sr_updatetime       datetime         default current_timestamp             comment "starrocks数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "第三方支付全局配置表 author:195666"
DISTRIBUTED BY HASH (Id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;