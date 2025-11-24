----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_admobconfig
-- 来源实例： hk-mysql_slave / th-mysql_slave
-- 来源表： 
--        readernovel_tidb_fr.admobconfig(hk-mysql_slave)
--        readernovel_tidb_jp.admobconfig(hk-mysql_slave)
--        readernovel_tidb_th.admobconfig(th-mysql_slave)
-- 来源负责： 
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-11-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_admobconfig;
create table ods.ods_tidb_readernovel_tidb_admobconfig (
     Id                int      not null                  comment "自增id"
    ,product_id        int      not null                  comment "产品id"
    ,Mode              int      not null                  comment ""
    ,BeginTime         datetime not null                  comment ""
    ,EndTime           datetime not null                  comment ""
    ,MaxShow           int      not null                  comment ""
    ,NewUserByDays     int      not null                  comment ""
    ,CoverImg          string   not null                  comment ""
    ,UnitID            string   not null                  comment ""
    ,GiftNum           int                                comment ""
    ,Position          int      not null                  comment ""
    ,MT                int      not null                  comment ""
    ,AdType            int      not null default "1"      comment ""
    ,AdProId           string                             comment ""
    ,GiftExpireDays    int      default "2"               comment ""
    ,AdShowType        int                                comment ""
    ,BanAdProdId       string                             comment ""
    ,CoreVer           int      not null default "-1"     comment ""
    ,Ver               int      not null default "0"      comment ""
    ,MaxVer            int      not null default "0"      comment ""
    ,UserFreeMinDays   int                                comment ""
    ,UserFreeMaxDays   int                                comment ""
    ,UserType          int                                comment ""
    ,AccountBlacklist  string                             comment ""
    ,BookBlacklist     string                             comment ""
    ,IsShieldAuthor    tinyint  not null default "0"      comment ""
    ,DeviceBlacklist   string                             comment ""
    ,DeviceWhitelist   string                             comment ""   
    ,EveryNum          int                                comment ""
    ,PositionIndex     int                                comment ""
    ,IsShieldWhite     tinyint                            comment ""
    ,IsShieldBlack     tinyint                            comment ""
    ,IsTop             tinyint                            comment ""
    ,ChapterType       int                                comment ""
    ,RuleKey           string                             comment ""
    ,BookWhitelist     string                             comment ""
    ,EveryWatchUnclock int                                comment ""
    ,ExtraAdNum        int      not null default "0"      comment "每日任务领取奖励次数"
    ,ExtraAdRewards    string   not null default ""       comment "每日任务领取奖励积分数"
    ,IsBooksWhite      tinyint  not null default "0"      comment "是否开启书籍白名单"
    ,IsBooksBlack      tinyint  not null default "0"      comment "是否开启书籍黑名单"
    ,IsInitData        tinyint  not null default "0"      comment "是否同步待确认0否1是"
    ,sr_createtime     datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime     datetime default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id, product_id)
comment "广告位置配置信息表"
distributed by hash(Id, product_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;