----------------------------------------------------------------
-- 目标表： ods_cdmoney_report_tidb_cn_dispute_order_stripe
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.dispute_order_stripe
-- 来源负责： 蔡扶炜
-- 采集工具： 极光—定时批量
-- 开发人： wx
-- 开发日期： 2025-09-19
----------------------------------------------------------------
drop table if exists ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe;
create table if not exists ods.ods_cdmoney_report_tidb_cn_dispute_order_stripe (
     id                  bigint(20)      not null    comment "自增ID"
    ,dispute_id          varchar(300)                comment "争议ID"
    ,pay_channel_id      varchar(300)                comment "渠道ID"
    ,pay_channel_name    varchar(300)                comment "渠道名称"
    ,invoice_id          varchar(300)                comment "账单id"
    ,coo_order_id        varchar(600)                comment "支付订单号,合作方回传的,paypal提供的"
    ,order_id            varchar(600)                comment "订单表>订单号,对应接口字段invoice_number"
    ,account             varchar(600)                comment "订单表>用户账号"
    ,user_id             varchar(600)                comment "订单表>用户ID"
    ,amount              decimal(18, 2)              comment "订单表>订单金额"
    ,coins               decimal(18, 2)              comment "订单表>代币"
    ,product_id          varchar(300)                comment "订单表>产品ID"
    ,shop_item_id        varchar(300)                comment "订单表>商品ID"
    ,core                int(11)                     comment "订单表>core"
    ,os_type             int(11)                     comment "订单表>平台,相当于mt,1-iOS,4-安卓,其他"
    ,order_create_time   datetime                    comment "订单表>创建时间"
    ,coo_notify_time     datetime                    comment "订单表>到账时间"
    ,coo_order_status    int(11)                     comment "订单表>合作方扣款状态：1 成功"
    ,insert_time         datetime                    comment "添加时间"
    ,update_time         datetime                    comment "更新时间"
    ,moneylog_data       varchar(1048576)            comment "用户消费明细 shop_item_id = 800/830/840需提供"
    ,watchlog_data       varchar(1048576)            comment "观看/阅读记录 shop_item_id=810/850需提供"
    ,is_order_sync       int(11)                     comment "订单基础数据同步状态 1 已同步 0 待同步 2 同步失败"
    ,is_moneylog_sync    int(11)                     comment "消费明细数据同步状态 1 已同步 0 待同步 shop_item_id = 800/830/840需提供"
    ,is_watchlog_sync    int(11)                     comment "观看/阅读数据同步状态 1 已同步 0 待同步 shop_item_id=810/850需提供"
    ,is_finish_sync      int(11)                     comment "同步数据是否完整 1 是, 0 否"
    ,moneylog_fileid     varchar(600)                comment "消费明细文件id"
    ,watchlog_fileid     varchar(600)                comment "观看记录文件id"
    ,order_fileid        varchar(600)                comment "订单文件id"
    ,is_file_ready       int(11)                     comment "文件是否已热加载 1 是, 0 否"
    ,sr_createtime       datetime         default    current_timestamp comment "sr入库时间"
    ,sr_updatetime       datetime         default    current_timestamp comment "starrocks数据更新时间"
)
primary key(id)
comment "Stripe争议订单表"
distributed by hash(id) buckets 1
properties ("replication_num" = "3",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "lz4"
)
;