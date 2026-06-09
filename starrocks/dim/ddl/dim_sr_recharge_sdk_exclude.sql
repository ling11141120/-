drop table if exists dim.dim_sr_recharge_sdk_exclude;
create table dim.dim_sr_recharge_sdk_exclude (
     main_company         varchar(255)                            comment "主体公司"
    ,language             varchar(255)                            comment "语言"
    ,country              varchar(255)                            comment "国家"
    ,order_number         varchar(255)                            comment "订单号"
    ,payment_number       varchar(255)                            comment "付款单号"
    ,recharge_user        varchar(255)                            comment "充值用户"
    ,business_type        varchar(255)                            comment "业务类型"
    ,core                 varchar(255)                            comment "Core"
    ,recharge_flow        bigint                                  comment "充值流水"
    ,recharge_amount      decimal(12, 2)                          comment "充值金额"
    ,recharge_channel     varchar(255)                            comment "充值渠道"
    ,sub_channel          varchar(255)                            comment "子渠道"
    ,create_time          datetime                                comment "创建时间"
    ,arrival_time         datetime                                comment "到账时间"
    ,order_type           varchar(255)                            comment "订单类型"
    ,test_flag            varchar(255)                            comment "测试数据"
    ,not_mobo             varchar(255)                            comment "用香港PAyPal回款订单剔除不属于Mobo部分"
    ,ym                   varchar(255)                            comment "月份"
    ,main_company_rewrite varchar(255)                            comment "主体公司改写成CHANGDU（HK）"
    ,etl_time             datetime default current_timestamp      comment "etl时间"
)
duplicate key(main_company, language, country, order_number)
comment "海剧-海外充值明细SDK（认收）报表"
distributed by hash(main_company, language, country, order_number) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
