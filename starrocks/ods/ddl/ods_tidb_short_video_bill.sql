----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_bill
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.bill
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期：2025-11-25
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_bill;
create table ods.ods_tidb_short_video_bill (
     dt           date        not null                  comment "日期"
    ,Id           bigint(20)  not null                  comment "主键"
    ,CreateTime   datetime    not null                  comment "创建时间"
    ,AccountId    bigint(20)                            comment "账号id"
    ,PayOrderId   int(11)                               comment "订单表主键"
    ,Coin         int(11)                               comment "当前代币数"
    ,Bonus        int(11)                               comment "当前赠币数"
    ,Price        int(11)                               comment "充值金额"
    ,PayType      int(11)                               comment "充值渠道"
    ,UpdateTime   datetime                              comment "更新时间"
    ,PreBonus     int(11)                               comment "充值前赠币"
    ,PreCoin      int(11)                               comment "充值前代币"
    ,SubPayType   string                                comment "第三方支付子类型"
    ,EpisId       bigint(20)                            comment "剧集id"
    ,EpisName     string                                comment "剧集名称"
    ,EpisNum      int(11)                               comment "集数"
    ,Platform     string                                comment "平台"
    ,GainBonus    int(11)                               comment "获得的bonus"
    ,GainCoin     int(11)                               comment "获得的coin"
    ,BillType     int(11)                               comment "充值类型"
    ,ConsumeType  int(11)                               comment "消费类型"
    ,ConsumeValue int(11)                               comment "消费数量"
    ,ShopItem     string                                comment "订单类型"
    ,Duration     int(11)                               comment "订单时长"
    ,regionId     smallint(6) default "1"               comment "归属区域 id，1：香港，2：北美;"
    ,sr_createtime datetime   default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime   default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, Id, CreateTime)
comment "海外短剧订单表"
partition by range(dt)
(partition p202511 values less than ("2025-12-01"))
distributed by hash(dt, Id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "AccountId, CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;