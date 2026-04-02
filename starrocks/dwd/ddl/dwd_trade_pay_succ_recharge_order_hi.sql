drop table if exists dwd.dwd_trade_pay_succ_recharge_order_hi;
create table dwd.dwd_trade_pay_succ_recharge_order_hi(
     dt                  date         not null comment "分区日期"
    ,product_id          int          not null comment "product_id"
    ,order_id            varchar(128) not null comment "订单id"
    ,user_id             bigint                comment "用户id"
    ,create_time         datetime              comment "创建时间"
    ,recharge_amt        int                   comment "充值金额"
    ,mt                  int                   comment "终端"
    ,recharge_type_cd    varchar(128)          comment "充值类型编码"
    ,recharge_type       varchar(128)          comment "充值类型"
    ,token_num           int                   comment "代币数"
    ,base_amount         int                   comment "分成后数量"
    ,recharge_channel    varchar(50)           comment "充值渠道"
    ,recharge_src        varchar(50)           comment "充值来源"
    ,strategy_id         bigint                comment "策略id"
    ,subscribe_status    int                   comment "订阅状态"
    ,card_expire_time    datetime              comment "订阅卡过期时间"
    ,item_id             varchar(128)          comment "申请id"
    ,etl_time            datetime              comment "etl时间"
    ,log_id              bigint                comment "记录id"
    ,actual_recharge_amt decimal(18,2)         comment "实际充值金额"
    ,core                int                   comment "包体"
    ,vip_type_cd         int                   comment "会员类型编码"
)
primary key(dt, product_id, order_id)
comment '交易域-支付成功充值订单'
partition by date_trunc('day', dt)
distributed by hash(dt, product_id, order_id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;