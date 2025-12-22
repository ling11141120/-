drop table if exists dwd.dwd_consume_user_consume;
create table dwd.dwd_consume_user_consume (
     dt            date           not null                 comment "createtime 分区"
    ,product_id    int(11)        not null                 comment "产品id"
    ,auto_id       bigint(20)     not null                 comment "自增id"
    ,types         int(11)        not null                 comment "1：阅币，2：礼券,3：赠送币,4:vip"
    ,user_id       bigint(20)                              comment "用户ID"
    ,amount        int(11)                                 comment "消费数额"
    ,remain_amount int(11)                                 comment "剩余数额(阅币、礼券、赠送币、vip)"
    ,book_id       bigint(20)                              comment "书籍ID"
    ,chapter_ids   varchar(65533)                          comment "章节id组，存在多个ID，以【逗号】分割"
    ,chapter_num   int(11)                                 comment "章节数"
    ,createtime    datetime                                comment "创建时间"
    ,pay_type      int(11)                                 comment "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,mt            int(11)                                 comment "平台 0未知 1iphone 4安卓 9书城"
    ,seq           bigint(20)                              comment "序号id"
    ,app_id        int(11)                                 comment "项目id，core，语言"
    ,position_id   varchar(50)                             comment "埋点id"
    ,app_game_id   bigint(20)                              comment "游戏id"
    ,send_id       varchar(255)                            comment "发送id"
    ,isFirst       int(11)                                 comment "是否首次购买"
    ,etl_time      datetime      default current_timestamp comment "etl清洗时间"
)
primary key (dt, product_id, auto_id, types)
comment "消耗域用户消费事实表"
partition by range (dt)
(partition p20251201 values less than ('2025-12-02'))
distributed by hash (product_id, auto_id) buckets 5
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "createtime, user_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-120",
    "dynamic_partition.end" = "2",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;