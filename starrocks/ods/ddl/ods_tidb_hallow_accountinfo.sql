----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_courses
-- 来源实例： old_tidb_source
-- 来源表： hallow.accountinfo
-- 来源负责： chh
-- 采集工具： SeaTunnel
-- 开发人：qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_accountinfo;
create table ods.ods_tidb_hallow_accountinfo (
     Id                   bigint        not null                  comment "用户Id"
    ,Account              varchar(200)                            comment "用户账号"
    ,Nick                 varchar(200)                            comment "昵称"
    ,Sex                  int                                     comment "性别"
    ,CreateTime           datetime                                comment "创建时间"
    ,LastLoginTime        datetime                                comment "最后登录时间"
    ,LastActiveTime       datetime                                comment "最近活跃时间"
    ,Chl                  varchar(200)                            comment "最新渠道id"
    ,Chl2                 varchar(200)                            comment "初始渠道Id"
    ,Mt                   int                                     comment "最新平台号,1为iOS 4为安卓"
    ,Mt2                  int                                     comment "初始平台号,1为iOS 4为安卓"
    ,CurrentLanguage      int                                     comment "最新用户使用语言"
    ,CurrentLanguage2     int                                     comment "包初始语言"
    ,CoreVer              int                                     comment "最新的Core"
    ,CoreVer2             int                                     comment "初始Core"
    ,UniqueCdReaderId     varchar(500)                            comment "畅读唯一设备号"
    ,Country              varchar(200)                            comment "当前国家"
    ,RegCountry           varchar(200)                            comment "注册国家"
    ,Ver                  int                                     comment "当前服务端版本"
    ,Avatar               varchar(2000)                           comment "头像"
    ,Appver               varchar(200)                            comment "版本号"
    ,Ip                   varchar(200)                            comment "当前ip地址"
    ,RegIp                varchar(200)                            comment "注册Ip"
    ,UtcOffset            int                                     comment "用户时区偏移"
    ,CurrentBookId        int                                     comment "正在读的书籍ID"
    ,EMail                varchar(255)                            comment "邮箱"
    ,IsDeleted            int                                     comment "是否删号"
    ,VipExpireTime        datetime                                comment "Vip过期时间"
    ,row_update_time      datetime                                comment "行更新时间"
    ,FirstOpenResId       bigint                                  comment "第一次打开的id"
    ,IMSI                 varchar(1000)                           comment "存放afuid"
    ,SourceChl            varchar(1000)                           comment "渠道值"
    ,ADID                 varchar(1000)                           comment "ADID"
    ,LastInstallTime      datetime                                comment "上一次客户端上报的安装时间"
    ,LastDayActiveTime    datetime                                comment "除了今天之外的最后活跃时间"
    ,BeforeLastActiveTime datetime                                comment "上上次活跃时间"
    ,sr_createtime        datetime      default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime        datetime      default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id)
comment "圣经-账号信息表"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;