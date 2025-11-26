drop table if exists ads.ads_bi_sv_recharge_user_detail_di;
create table ads.ads_bi_sv_recharge_user_detail_di (
     dt                       date          NOT NULL                  comment "日期分区"
    ,period_type              varchar(50)   NOT NULL                  comment "周期类型"
    ,strategy_id              varchar(200)  NOT NULL                  comment "策略ID"
    ,recharge_source          varchar(200)  NOT NULL                  comment "充值来源"
    ,user_id                  bigint(20)    NOT NULL                  comment "用户id"
    ,row_1                    int(11)       NOT NULL                  comment "排序"
    ,product_id               int(11)                                 comment "产品id"
    ,user_type                varchar(200)                            comment "用户类型"
    ,put_language             varchar(50)                             comment "投放语言"
    ,country_level            varchar(50)                             comment "国家等级"
    ,mt                       varchar(50)                             comment "终端"
    ,corever                  int(11)                                 comment "core"
    ,strategy_name            varchar(200)                            comment "策略名称"
    ,strategy_weight          varchar(200)                            comment "策略权重"
    ,strategy_code            varchar(200)                            comment "策略代号"
    ,sv_last_preload_ecpm     decimal(12,6)                           comment "最近一次激励视频预加载eCPM拆包维度"
    ,recharge_mode            decimal(12,2)                           comment "充值众数"
    ,exposure_uv              int(11)                                 comment "曝光UV"
    ,exposure_pv              int(11)                                 comment "曝光PV"
    ,ad_exposure_uv           int(11)                                 comment "广告曝光UV"
    ,ad_exposure_pv           int(11)                                 comment "广告曝光PV"
    ,ad_amt                   decimal(12,6)                           comment "广告收益"
    ,shop_item_type           varchar(500)                            comment "档位类型"
    ,vip_type                 int(11)                                 comment "1、月卡，2、季卡，3、年卡，4、周卡"
    ,subpay_type              varchar(50)                             comment "充值类型"
    ,item_count               varchar(500)                            comment "充值档位"
    ,recharge_un              int(11)                                 comment "充值人数"
    ,recharge_times           int(11)                                 comment "充值次数"
    ,recharge_amount          decimal(12,2)                           comment "充值金额"
    ,normal_recharge_amount   decimal(12,2)                           comment "充值金额-普通充值"
    ,signin_recharge_amount   decimal(12,2)                           comment "充值金额-签到卡"
    ,svip_recharge_amount     decimal(12,2)                           comment "充值金额-SVIP"
    ,normal_recharge_times    decimal(12,2)                           comment "充值次数-普通充值"
    ,signin_recharge_times    decimal(12,2)                           comment "充值次数-签到卡"
    ,svip_recharge_times      decimal(12,2)                           comment "充值次数-SVIP"
    ,normal_recharge_un       decimal(12,2)                           comment "充值人数-普通充值"
    ,signin_recharge_un       decimal(12,2)                           comment "充值人数-签到卡"
    ,svip_recharge_un         decimal(12,2)                           comment "充值人数-SVIP"
    ,recharge_un_subscription decimal(12,2)                           comment "充值人数-订阅"
    ,is_recharge              int(11)                                 comment "是否充值"
    ,finish_time              int(11)                                 comment "订单完成用时(秒)"
    ,create_order_num         int(11)                                 comment "创建订单数"
    ,etl_ime                  datetime      DEFAULT CURRENT_TIMESTAMP comment "清洗时间"
)
primary key(dt, period_type, strategy_id, recharge_source, user_id, row_1)
comment "海剧充值用户明细报表"
partition by range(dt)
(partition p202511 values less than ("2025-12-01"))
distributed by hash(dt, strategy_id, user_id) buckets 5 
properties (
    "replication_num"                    = "3",
    "bloom_filter_columns"              = "dt",
    "dynamic_partition.enable"          = "true",
    "dynamic_partition.time_unit"       = "month",
    "dynamic_partition.time_zone"       = "Asia/Shanghai",
    "dynamic_partition.start"           = "-2147483648",
    "dynamic_partition.end"             = "3",
    "dynamic_partition.prefix"          = "p",
    "dynamic_partition.buckets"         = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory"                         = "false",
    "enable_persistent_index"           = "true",
    "replicated_storage"                = "true",
    "compression"                       = "LZ4"
)
;