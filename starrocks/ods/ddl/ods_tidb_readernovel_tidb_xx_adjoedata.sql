----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_xx_adjoedata
-- 来源实例： tidb_source
-- 来源表： 
--         readernovel_tidb_fr.adjoedata
--         readernovel_tidb_pt.adjoedata
--         readernovel_tidb_ft.adjoedata
--         readernovel_tidb_en.adjoedata
--         readernovel_tidb_ru.adjoedata
--         readernovel_tidb_sp.adjoedata
--         readernovel_tidb_jp.adjoedata
--         readernovel_tidb_id.adjoedata
--         readernovel_tidb_th.adjoedata
--         readernovel_tidb_and2.adjoedata
--         readernovel_tidb_cd2.adjoedata
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-03-03
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_adjoedata;
create table ods.ods_tidb_readernovel_tidb_xx_adjoedata (
    dt                      date            not null                     comment "分区"
   ,id                      bigint          not null                     comment "自增Id"
   ,date                    datetime        not null                     comment "时间"
   ,sdkhash                 varchar(765)                                 comment "SDK 的唯一标识符。"
   ,platform                varchar(765)                                 comment "安卓或iOS系统。"
   ,country                 varchar(765)                                 comment "两位字母的国家代码。例如：de，，us。fr"
   ,useruuid                varchar(765)                                 comment "由 adjoe 用于识别用户。"
   ,ecpm                    double                                       comment "eCPM"
   ,revenue                 double                                       comment "该用户当日的收入（美元）。"
   ,currency                varchar(765)                                 comment "货币类型示例：美元或欧元。"
   ,offerwallshown          bigint                                       comment "向所有用户展示广告墙的次数。"
   ,storeid                 varchar(765)    not null                     comment "Android 应用包名或 iOS App Store ID。例如：com.king.candycrush."
   ,sdkbootups              bigint                                       comment "SDK 初始化次数。"
   ,coinsum                 bigint                                       comment "奖励总数之和。"
   ,createtime              datetime                                     comment "创建时间"
   ,projecttype             int                                          comment "项目类型 0:未知 1:阅读 2:短剧"
   ,offerwallimpressions    bigint                                       comment "展示广告墙的次数。"
   ,sr_createtime           datetime        default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime           datetime        default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, id)
comment "adjoe数据收集表"
partition by date_trunc("month", dt)
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;