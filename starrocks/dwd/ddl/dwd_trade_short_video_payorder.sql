drop table if exists dwd.dwd_trade_short_video_payorder;
create table dwd.dwd_trade_short_video_payorder (
     dt                 date           not null                          comment ""
    ,product_id         int(11)        not null                          comment "产品id 6833海外短剧"
    ,id                 int(11)        not null                          comment ""
    ,status             int(11)        not null                          comment "0 正常订单 1 退款订单"
    ,type               int(11)        default '0'                       comment "类型"
    ,user_id            bigint(20)                                       comment "用户id"
    ,used               int(11)        default '0'                       comment ""
    ,order_id           varchar(128)                                     comment "订单id"
    ,flag               int(11)        default '0'                       comment "标识（没用）"
    ,create_time        datetime       default '1970-01-01 00:00:00.000' comment "创建时间"
    ,get_time           datetime       default '1970-01-01 00:00:00.000' comment "获取时间"
    ,item_count         int(11)        default '0'                       comment "金额数"
    ,system_type        int(11)        default '0'                       comment "系统类型"
    ,receive_date       datetime                                         comment "被接收时间"
    ,mt                 int(11)        default '0'                       comment "平台"
    ,coupon_id          varchar(128)                                     comment "礼券id"
    ,package_id         varchar(255)                                     comment "存放充值页面来源"
    ,shop_item          varchar(128)                                     comment "充值类型"
    ,extinfo            varchar(128)                                     comment "ext信息"
    ,vip_expire_time    varchar(20)                                      comment "vip过期时间"
    ,real_money         int(11)                                          comment "给的阅币数"
    ,give_money         int(11)                                          comment "暂时无用"
    ,amount             int(11)                                          comment "暂时无用"
    ,prod_id            int(11)        default '0'                       comment "暂时无用"
    ,pay_config_id      int(11)                                          comment "充值项的id，可能不准确"
    ,corever            int(11)                                          comment "包体"
    ,unique_guid        varchar(255)                                     comment "用户设备id"
    ,test_flag          int(11)        default '0'                       comment "用于判别是否为测试 1为测试, 0为正常"
    ,buy_token          varchar(255)                                     comment "购买时候的google的token"
    ,base_amount        int(11)        default '0'                       comment "分成后的数量（除以100为分成后的金额）"
    ,version            varchar(255)                                     comment "购买时，用户客户端的版本号"
    ,subpay_type        varchar(50)                                      comment "充值渠道"
    ,gift_money         int(11)                                          comment "充值赠送的礼券数(可能不准确)"
    ,order_init_time    datetime                                         comment "用户订单创建时间"
    ,cooorder_extinfo   varchar(1000)                                    comment "合作方订单扩展"
    ,custom_data        varchar(65533)                                   comment "自定义数据，透传，json格式"
    ,ScheduleTime       datetime                                         comment "退款时间"
    ,etl_tm             datetime                                         comment "清洗时间"
    ,actual_amount      decimal(18, 2)                                   comment "总支付金额，小数类型"
)
PRIMARY KEY (dt, product_id, id, status)
COMMENT "短剧--用户订单表"
DISTRIBUTED BY HASH (id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;