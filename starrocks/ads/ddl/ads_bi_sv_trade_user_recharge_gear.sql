drop table if exists ads.ads_bi_sv_trade_user_recharge_gear;
create table ads.ads_bi_sv_trade_user_recharge_gear (
     dt              date           comment "统计周期"
    ,period_type     varchar(20)    comment "统计周期类型,ctt/rmt,rmt(拉活用户)"
    ,product_id      int            comment "产品id"
    ,user_id         bigint         comment "用户id"
    ,reg_language    int            comment "投放语言（注册语言）"
    ,source_chl      varchar(1000)  comment "最新渠道"
    ,reg_country     string         comment "注册国家"
    ,country_level   string         comment "国家等级,注册国家对应"
    ,mt              int            comment "平台"
    ,corever         int            comment "core"
    ,user_type       varchar(50)    comment "用户类型"
    ,shop_item       string         comment "充值类型"
    ,recharge_gear   int            comment "充值档位（充值金额）"
    ,is_first_charge int            comment "是否首次充值 1：是 ，0：否"
    ,vip_type        int            comment "vip类型,1 月卡 2 季卡 3 年卡 4 周卡"
    ,charge_cnt      bigint         comment "充值次数"
    ,before_charge   bigint         comment "充值金额（分成前）"
    ,after_charge    decimal(18, 2) comment "充值金额（分成后）"
    ,etl_time        datetime       comment "处理时间"
    ,subscribe_mode  varchar(50)    comment "订阅方式"
)
duplicate key(dt, period_type, product_id, user_id)
comment "交易域用户充值档位、结构表"
distributed by hash(period_type, product_id, user_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_type, mt, reg_language, corever, period_type",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;