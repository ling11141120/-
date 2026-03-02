drop table if exists ads.ads_bi_short_video_trade_user_subscribe_di;
create table ads.ads_bi_short_video_trade_user_subscribe_di (
     dt                  date            not null comment "统计日期"
    ,product_id          int             not null comment "产品id 6833海外短剧"
    ,id                  int             not null comment "id"
    ,order_id            varchar(128)             comment "订单id"
    ,core                int                      comment "core"
    ,mt                  int                      comment "终端"
    ,current_language2   bigint                   comment "注册语言"
    ,country             string                   comment "国家"
    ,user_id             bigint          not null comment "用户id"
    ,shop_item           int                      comment "订阅类型"
    ,item_id             string                   comment "item_id"
    ,item_count          decimal(16, 2)           comment "实际支付金额"
    ,vip_type            string                   comment "订阅周期"
    ,sub_pay_type        string                   comment "订阅渠道"
    ,charge_type         string                   comment "订阅属性"
    ,price               int                      comment "订阅价格"
    ,first_price         int                      comment "首充价格"
    ,first_validity      int                      comment "首充有效期"
    ,first_time          datetime                 comment "第一次订阅时间（用户维度首次支付订阅类时间）"
    ,after_charge        decimal(16, 2)           comment "订单金额（分成后）"
    ,vip_expire_time     datetime                 comment "充值订阅卡时，谷歌和苹果返回的过期时间"
    ,vip_start_time      datetime                 comment "订阅开始时间"
    ,cancel_time         date                     comment "取消订阅时间（在最后一条生效的订阅数据上打标记/或在这一系列中均打标记）"
    ,subscribe_status    int                      comment "订阅状态"
    ,autoRenew_times     int                      comment "续订次数"
    ,shop_num            int                      comment "历史累计订阅次数"
    ,M0                  int                      comment "第1个月价值"
    ,M1                  int                      comment "第2个月价值"
    ,M2                  int                      comment "第3个月价值"
    ,M3                  int                      comment "第4个月价值"
    ,M4                  int                      comment "第5个月价值"
    ,M5                  int                      comment "第6个月价值"
    ,M6                  int                      comment "第7个月价值"
    ,M7                  int                      comment "第8个月价值"
    ,M8                  int                      comment "第9个月价值"
    ,M9                  int                      comment "第10个月价值"
    ,M10                 int                      comment "第11个月价值"
    ,M11                 int                      comment "第12个月价值"
    ,M12                 int                      comment "次年第1月价值"
    ,etl_time            datetime                 comment "处理时间"
)
primary key(dt, product_id, id)
comment "海外短剧-用户充值表"
partition by range(dt)
(partition by p20260302 values less than ("2026-03-03"))
distributed by hash(dt, product_id, id) buckets 7
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-120",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

