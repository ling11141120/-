----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_readerlog_xx_usermoneylog
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.readerlog_xx_usermoneylog
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_readerlog_xx_usermoneylog;
create table ods.ods_tidb_finance_snapshot_readerlog_xx_usermoneylog (
     dt            date          not null                     comment "createtime 分区"
    ,productid     int           not null                     comment "产品id"
    ,Id            bigint        not null                     comment "自增id"
    ,UserId        bigint                                     comment "用户ID"
    ,CreateTime    datetime                                   comment "记录时间"
    ,Amount        int                                        comment "消费数额"
    ,RemainAmount  int                                        comment "剩余数额"
    ,BookId        bigint                                     comment "书籍ID"
    ,ChapterIds    string                                     comment "章节id，存在多个ID，以【逗号】分割"
    ,ChapterName   varchar(1024)                              comment "章节名称"
    ,PayType       int                                        comment "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,MT            int                                        comment "平台"
    ,Seq           bigint                                     comment "记录序号可与createtime一起用，提取用户首次消费时间"
    ,VipType       int                                        comment "vip类型"
    ,OriginCoin    int                                        comment "原始金额"
    ,VipDisPrice   int                                        comment "打折金额"
    ,AppId         int                                        comment "项目id，core，语言"
    ,PositionId    varchar(50)                                comment "埋点id"
    ,AppGameId     bigint                                     comment "游戏id"
    ,SendId        varchar(255)                               comment "发送id"
    ,ChapterNos    string                                     comment "章节序号列表"
    ,ModuleSendId  varchar(255)                               comment "模块sendid"
    ,snapshot_time datetime                                   comment "快照时间"
    ,sr_createtime datetime      default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime datetime      default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, productid, Id)
comment "财务专用-阅币消耗表"
partition by date_trunc("month", dt)
distributed by hash(productid, Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;