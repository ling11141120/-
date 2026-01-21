drop table if exists dws.dws_consume_short_video_consume_a;
create table dws.dws_consume_short_video_consume_a (
     dt                   date           not null comment "日期"
    ,product_id           bigint(20)     not null comment "产品id"
    ,user_id              bigint(20)     not null comment "用户id"
    ,consume_amt_td       decimal(24, 8)          comment "累计消耗(代币、赠币)"
    ,fst_consume_tm       datetime                comment "首次消费时间"
    ,lst_consume_tm       datetime                comment "最近一次消费时间"
    ,consume_cnt_td       bigint(20)              comment "累积消费次数"
    ,consume_tv_td        bitmap                  comment "消费剧集bitmap(剧id+集序号)"
    ,consume_money_amt_td decimal(24, 8)          comment "累计消耗代币数"
    ,fst_consume_money_tm datetime                comment "首次消费代币时间"
    ,lst_consume_money_tm datetime                comment "最近一次消费代币时间"
    ,consume_money_cnt_td bigint(20)              comment "累积消费代币次数"
    ,consume_money_tv_td  bitmap                  comment "代币消费剧集bitmap(剧id+集序号)"
    ,consume_cert_amt_td  decimal(24, 8)          comment "累计消耗赠币"
    ,fst_consume_cert_tm  datetime                comment "首次消费赠币时间"
    ,lst_consume_cert_tm  datetime                comment "最近一次消费赠币时间"
    ,consume_cert_cnt_td  bigint(20)              comment "累积消费赠币次数"
    ,consume_cert_tv_td   bitmap                  comment "赠币消费剧集bitmap(剧id+集序号)"
    ,etl_time             datetime                comment "数据清洗时间"
)
primary key(dt, product_id, user_id)
comment "消耗域用户消耗累计指标表"
partition by range(dt)
(partition p202512 values less than ("2026-01-01"))
distributed by hash(product_id, user_id) buckets 1
properties (
    "replication_num" = "2",
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