----------------------------------------------------------------
-- 目标表：ods.ods_tidb_hallow_device
-- 来源实例：old_tidb_source
-- 来源表：hallow.device
-- 来源负责：chh
-- 采集工具：SeaTunnel
-- 开发人：qhr
-- 开发日期：2025-12-02
----------------------------------------------------------------
drop table if exists ods.ods_tidb_hallow_device;
create table ods.ods_tidb_hallow_device (
     id                  bigint        not null comment '设备Id'
    ,DeviceSecret        varchar(96)   not null comment '设备秘钥'
    ,AppVer              varchar(96)   not null comment '应用版本号'
    ,Core                smallint      not null comment 'Core'
    ,MT                  smallint      not null comment 'MT'
    ,UserId              bigint        not null comment '当前登录的用户Id'
    ,UniqueCdReaderId    varchar(192)  not null comment '设备唯一Id，安卓：安卓Id:Core'
    ,Lang                smallint      not null comment '语言Id'
    ,Chl                 varchar(192)  not null comment '渠道'
    ,AppId               int           not null comment 'AppId'
    ,X                   smallint               comment 'x值'
    ,OsVer               varchar(96)            comment 'Os版本号'
    ,IDFA                varchar(192)           comment 'IDFA'
    ,IDFV                varchar(192)           comment 'IDFV'
    ,AndroidId           varchar(192)           comment 'AndroidId'
    ,Device              varchar(192)           comment '设备'
    ,Locale              varchar(96)            comment '区域语言信息'
    ,Ver                 int                    comment '服务端版本号'
    ,UtcOffset           int                    comment '时区信息'
    ,SH                  smallint               comment '屏幕高度'
    ,SW                  smallint               comment '屏幕宽度'
    ,PushToken           varchar(768)           comment '推送Token'
    ,Scale               smallint               comment 'ios图片缩放参数'
    ,Device2             varchar(192)           comment 'Device2'
    ,CreateTime          datetime               comment '创建时间'
    ,DynamicIslandSwitch int                    comment '灵动岛开关，1：开，0关'
    ,sr_createtime       datetime               comment "starrocks入库时间"
    ,sr_updatetime       datetime               comment "starrocks数据更新时间"
)
primary key (id)
comment "圣经账号信息"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;
