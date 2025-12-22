----------------------------------------------------------------
-- 目标表： ods_log.ods_book_log_usermoneylog
-- 来源实例： old_tidb_source
-- 来源表：
--        readerlog_fr.UserMoneyLog
--        readerlog_pt.UserMoneyLog
--        readerlog_ft.UserMoneyLog
--        readerlog_en.UserMoneyLog
--        readerlog_ru.UserMoneyLog
--        readerlog_sp.UserMoneyLog
--        readerlog_jp.UserMoneyLog
--        readerlog_id.UserMoneyLog
--        readerlog_th.UserMoneyLog
--        readerlog_and2_sync.UserMoneyLog
--        readerlog_cd2_sync.UserMoneyLog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-01
----------------------------------------------------------------

drop table if exists ods_log.ods_book_log_usermoneylog;
create table ods_log.ods_book_log_usermoneylog (
     dt            date          not null                  comment "createtime 分区"
    ,ProductId     int(11)       not null                  comment "产品id"
    ,Id            bigint(20)    not null                  comment "自增id"
    ,UserId        bigint(20)                              comment "用户ID"
    ,CreateTime    datetime                                comment "记录时间"
    ,Amount        int(11)                                 comment "消费数额"
    ,RemainAmount  int(11)                                 comment "剩余数额"
    ,BookId        bigint(20)                              comment "书籍ID"
    ,ChapterIds    string                                  comment "章节id，存在多个ID，以【逗号】分割"
    ,ChapterName   varchar(1024)                           comment "章节名称"
    ,PayType       int(11)                                 comment "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,MT            int(11)                                 comment "平台"
    ,Seq           bigint(20)                              comment "记录序号可与createtime一起用，提取用户首次消费时间"
    ,VipType       int(11)                                 comment "vip类型"
    ,OriginCoin    int(11)                                 comment "原始金额"
    ,VipDisPrice   int(11)                                 comment "打折金额"
    ,AppId         int(11)                                 comment "项目id，core，语言"
    ,PositionId    varchar(50)                             comment "埋点id"
    ,AppGameId     bigint(20)                              comment "游戏id"
    ,SendId        varchar(255)                            comment "发送id"
    ,sr_createtime datetime      default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime      default current_timestamp comment "starrocks数据更新时间"
    ,index index_ProductId(ProductId) using bitmap         comment 'index_ProductId'
)
primary key(dt, ProductId, Id)
comment "阅币消耗表"
partition by range(dt)
(partition p20251201 values less than ('2025-12-02'))
distributed by hash(ProductId, Id) buckets 1 
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;