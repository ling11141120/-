----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_version_device_anr
-- 来源表： qadata.gp_app_version_device_anr
-- 开发人： qhr
-- 开发日期： 2023-08-20
----------------------------------------------------------------

create table if not exists ods.ods_tidb_qadata_gp_app_version_device_anr (
     Id            bigint        not null                  comment 'Id'
    ,InitTime      datetime      not null                  comment '数据写入时间'
    ,StartTime     datetime                                comment '抓取日期'
    ,ProductId     int                                     comment '产品Id'
    ,Core          int                                     comment 'Core'
    ,Lang          varchar(20)                             comment '语言'
    ,VersionCode   bigint                                  comment '版本号'
    ,DeviceName    varchar(100)                            comment '机型'
    ,AnrCount      int                                     comment 'ANR个数'
    ,AnrRate       decimal(15,5)                           comment 'ANR率'
    ,AnrGlobalRate decimal(15,5)                           comment '全局ANR率'
    ,SessionCount  int                                     comment '会话数'
    ,DeviceGuid    varchar(50)                             comment 'Guid'
    ,UpdateTime    datetime                                comment '数据更新时间'
    ,AnrTime       datetime                                comment 'ANR日期'
    ,sr_createtime datetime      default current_timestamp comment 'starrocks数据注入时间'
    ,sr_updatetime datetime      default current_timestamp comment 'starrocks数据更新时间'
)
duplicate key (Id, InitTime)
comment '谷歌Play机型维度ANR率'
partition by date_trunc('month', InitTime)
distributed by hash (Id)
properties("replication_num" = "3",
           "in_memory" = "false",
           "storage_format" = "DEFAULT",
           "enable_persistent_index" = "true",
           "compression" = "LZ4"
)
;