drop table if exists ads.ads_srsv_sdk_recharge_summary;
create table ads.ads_srsv_sdk_recharge_summary (
     dt             date           not null comment "日期"
    ,product_id     bigint         not null comment "产品id"
    ,country        varchar(200)   not null comment "国家"
    ,pay_channel    varchar(200)   not null comment "支付渠道"
    ,if_exist       varchar(200)   not null comment "支付类型（普通充值、会员充值）"
    ,test_flag      varchar(200)   not null comment "是否测试（1 测试）"
    ,amount         decimal(20, 2)          comment "充值流水"
    ,base_amount    decimal(20, 2)          comment "充值金额"
    ,service_charge decimal(20, 2)          comment "手续费"
    ,etl_time       datetime                comment "etl处理时间"
    ,recharge_cnt   bigint                  comment "充值笔数"
)
primary key (dt, product_id, country, pay_channel, if_exist, test_flag)
comment "海剧-SDK充值汇总表"
distributed by hash(dt, product_id, country, pay_channel, if_exist, test_flag) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
