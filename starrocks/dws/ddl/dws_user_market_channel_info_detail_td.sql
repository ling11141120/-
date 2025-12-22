drop table if exists dws.dws_user_market_channel_info_detail_td;
create table dws.dws_user_market_channel_info_detail_td (
     dt           date         not null comment "数据统计时间-分区"
    ,product_id   int(11)      not null comment "产品id"
    ,user_id      bigint(20)   not null comment "用户id"
    ,mt           int(11)      not null comment "mt"
    ,corever      int(11)      not null comment "core"
    ,lang2        int(11)      not null comment "投放时语言"
    ,first_bookid bigint(20)            comment "首次引流书籍"
    ,last_bookid  bigint(20)            comment "最新引流书籍"
    ,last_source  varchar(100)          comment "最新媒体值"
    ,isremarket   int(11)      not null comment "是否再营销用户 1：再营销用户  0 非再营销用户"
    ,install_date datetime     not null comment "安装激活时间"
    ,updatetime   datetime     not null comment "数据更新变化时间"
)
primary key(dt, product_id, user_id, mt, corever, lang2)
comment "投放渠道引流书籍，媒体等数据"
partition by range(dt)
(partition p20251202 values less than ("2025-12-03")),
distributed by hash(product_id, user_id) buckets 30
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "updatetime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-15",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "30",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;