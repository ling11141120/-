drop table if exists dwd.dwd_srsv_trade_hk_sync_payorder_di;
create table dwd.dwd_srsv_trade_hk_sync_payorder_di (
     dt                   date             not null comment "日期分区"
    ,id                   bigint           not null comment "主键id"
    ,order_serial_id      string                    comment "订单流水号全局唯一,写入到业务库使用"
    ,order_id             string                    comment "订单号,透传给支付合作方"
    ,coo_order_id         string                    comment "支付订单号,合作方回传的"
    ,pay_chanel_id        int                       comment "渠道号"
    ,account              string                    comment "账号"
    ,user_id              bigint                    comment "用户Id"
    ,server_id            int                       comment "服务器id,已废弃"
    ,user_i_p_address     string                    comment "客户端ip"
    ,create_time          datetime                  comment "创建时间"
    ,coo_notify_time      datetime                  comment "收到的付款时间"
    ,finish_time          datetime                  comment "订单处理完成时间,表示已经发送给业务服务器的时间"
    ,amount               int                       comment "金额,分为单位"
    ,give_amount          int                       comment "赠送金额,一般无用了"
    ,bank_amount          int                       comment "银行金额,一般等同于Amount"
    ,order_status         int                       comment "订单状态1为成功"
    ,coo_order_status     int                       comment "合作方扣款状态1为成功"
    ,shop_item            string                    comment "支付的商品id"
    ,product_id           string                    comment "充值产品编号"
    ,pay_type             string                    comment ""
    ,bank_id              string                    comment ""
    ,ext1                 varchar(1048576)          comment ""
    ,ext2                 varchar(1048576)          comment ""
    ,ext3                 varchar(1048576)          comment ""
    ,ext4                 varchar(1048576)          comment ""
    ,ext5                 varchar(1048576)          comment ""
    ,os_type              int                       comment "相当于Mt"
    ,shop_item_id         int                       comment "商品Id,配置在后台"
    ,coupon_id            string                    comment "优惠券Id"
    ,package_id           string                    comment "客户端透传参数,不同场景用途不一样"
    ,phone                string                    comment ""
    ,has_notify_times     int                       comment ""
    ,pay_config_id        int                       comment ""
    ,core                 int                       comment ""
    ,base_amount          int                       comment "统计收入金额字段"
    ,unique_guid          string                    comment ""
    ,test_flag            int                       comment "测试标记1为测试"
    ,coo_ext_status       int                       comment ""
    ,coo_ext_info         varchar(1048576)          comment ""
    ,bill_info            varchar(1048576)          comment ""
    ,row_update_timestamp datetime                  comment ""
    ,sub_pay_type         string                    comment "子渠道类型"
    ,auto_renew_times     int                       comment "续订次数"
    ,subscribe_status     int                       comment ""
    ,app_ver              string                    comment ""
    ,country              string                    comment ""
    ,sr_createtime        datetime                  comment "sr入库时间"
    ,sr_updatetime        datetime                  comment "sr更新时间"
    ,province             varchar(100)              comment "省"
)
primary key(dt, id)
comment "海阅海剧充值表（带国家）"
partition by range(dt)
(partition p202601 values less than ("2026-02-01"))
distributed by hash(id) buckets 3
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;