drop table if exists ads.ads_srsv_dispute_payorder_result;
create table if not exists ads.ads_srsv_dispute_payorder_result (
     id                             bigint(20)      not null    comment "自增ID"
    ,product_type                   varchar(300)    not null    comment "三方产品类型，stripe，paypal"
    ,dispute_id                     varchar(300)                comment "争议ID"
    ,insert_time                    datetime                    comment "添加时间"
    ,product_id                     int(11)                     comment "订单表>产品ID"
    ,order_id                       varchar(600)                comment "订单表>订单号"
    ,user_id                        varchar(600)                comment "订单表>用户ID"
    ,user_type                      varchar(600)                comment "用户类型"
    ,core                           int(11)                     comment "订单表>core"
    ,mt                             varchar(600)                comment "订单表>平台,mt,1-iOS,4-安卓,其他"
    ,current_language2              varchar(600)                comment "投放语言"
    ,shop_item_id                   int(11)                     comment "充值类型"
    ,country                        varchar(600)                comment "国家/地区"
    ,source_chl_type                varchar(600)                comment "媒体来源(总)/分类"
    ,source_chl                     varchar(600)                comment "媒体来源"
    ,refund_time                    datetime                    comment "退款时间"
    ,final_amount                   decimal(11, 2)              comment "损失金额"
    ,balance_transactions_amount    decimal(11, 2)              comment "争议金额"
    ,is_status_succeed              int(11)                     comment "是否胜诉，1是0否"
    ,final_status                   int(11)                     comment "最终状态"
    ,etl_time                       datetime                    comment "数据清洗时间"
)
primary key(id, product_type)
comment "订单争议结果表"
distributed by hash(id) buckets 3
properties ("replication_num" = "3",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "lz4"
)
;