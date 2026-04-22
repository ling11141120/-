drop table if exists ads.ads_bi_sv_paywall_recharge_user_detail_di;
create table ads.ads_bi_sv_paywall_recharge_user_detail_di (
     dt                       date           not null                  comment "日期分区"
    ,md5_key                  varchar(32)    not null                  comment "联合主键"
    ,strategy_node_id         varchar(200)   not null                  comment "策略节点ID"
    ,user_id                  bigint         not null                  comment "用户id"
    ,strategy_id              varchar(200)   not null                  comment "策略ID"
    ,map_strategy_id          varchar(200)   not null                  comment "策略映射ID"
    ,version_id               int                                      comment "版本id"
    ,recharge_source          varchar(200)                             comment "充值来源"
    ,product_id               int                                      comment "产品id"
    ,put_language             varchar(50)                              comment "投放语言"
    ,country_level            varchar(50)                              comment "国家等级"
    ,mt                       varchar(50)                              comment "终端"
    ,core                     int                                      comment "core"
    ,strategy_name            varchar(200)                             comment "策略名称"
    ,strategy_weight          varchar(200)                             comment "策略权重"
    ,strategy_code            varchar(200)                             comment "策略代号"
    ,sv_last_preload_ecpm     decimal(12, 6)                           comment "最近一次激励视频预加载eCPM拆包维度"
    ,recharge_mode            decimal(12, 2)                           comment "充值众数"
    ,exposure_uv              int                                      comment "曝光UV"
    ,exposure_pv              int                                      comment "曝光PV"
    ,ad_exposure_uv           int                                      comment "广告曝光UV"
    ,ad_exposure_pv           int                                      comment "广告曝光PV"
    ,ad_amt                   decimal(12, 6)                           comment "广告收益"
    ,shop_item_type           varchar(500)                             comment "档位类型"
    ,vip_type                 int                                      comment "1、月卡，2、季卡，3、年卡，4、周卡"
    ,subpay_type              varchar(50)                              comment "充值类型"
    ,item_count               varchar(500)                             comment "充值档位"
    ,recharge_un              int                                      comment "充值人数"
    ,recharge_times           int                                      comment "充值次数"
    ,recharge_amount          decimal(12, 2)                           comment "充值金额"
    ,normal_recharge_amount   decimal(12, 2)                           comment "充值金额-普通充值"
    ,signin_recharge_amount   decimal(12, 2)                           comment "充值金额-签到卡"
    ,svip_recharge_amount     decimal(12, 2)                           comment "充值金额-SVIP"
    ,nsvip_recharge_amount    decimal(12, 2)                           comment "充值金额-NSVIP"
    ,third_recharge_amount    decimal(12, 2)                           comment "充值金额-三方支付"
    ,normal_recharge_times    decimal(12, 2)                           comment "充值次数-普通充值"
    ,signin_recharge_times    decimal(12, 2)                           comment "充值次数-签到卡"
    ,svip_recharge_times      decimal(12, 2)                           comment "充值次数-SVIP"
    ,nsvip_recharge_times     decimal(12, 2)                           comment "充值次数-NSVIP"
    ,normal_recharge_un       decimal(12, 2)                           comment "充值人数-普通充值"
    ,signin_recharge_un       decimal(12, 2)                           comment "充值人数-签到卡"
    ,svip_recharge_un         decimal(12, 2)                           comment "充值人数-SVIP"
    ,nsvip_recharge_un        decimal(12, 2)                           comment "充值人数-NSVIP"
    ,recharge_un_subscription decimal(12, 2)                           comment "充值人数-订阅"
    ,is_recharge              int                                      comment "是否充值"
    ,finish_time              int                                      comment "订单完成用时(秒)"
    ,create_order_num         int                                      comment "创建订单数"
    ,etl_ime                  datetime       default current_timestamp comment "清洗时间"
)
primary key(dt, md5_key)
comment "海剧付费墙充值用户明细报表"
partition by date_trunc('day', dt)
distributed by hash(dt, md5_key)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "733"
)
;