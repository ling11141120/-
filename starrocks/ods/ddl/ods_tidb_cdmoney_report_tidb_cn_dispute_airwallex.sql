DROP TABLE IF EXISTS ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex;
CREATE TABLE ods.ods_tidb_cdmoney_report_tidb_cn_dispute_airwallex (
     dt                    DATE         NOT NULL             COMMENT "分区日期"
    ,id                    BIGINT       NOT NULL             COMMENT "自增ID"
    ,pay_channel_id        VARCHAR(300)                      COMMENT "渠道ID"
    ,pay_channel_name      VARCHAR(300)                      COMMENT "渠道名称"
    ,dispute_id            VARCHAR(300)                      COMMENT "争议id"
    ,invoice_id            VARCHAR(300)                      COMMENT "交易id"
    ,coo_order_id          VARCHAR(300)                      COMMENT "支付订单号,合作方回传的,paypal提供的,当做唯一标识争议id"
    ,order_id              VARCHAR(300)                      COMMENT "订单表>订单号"
    ,order_serialid        VARCHAR(240)                      COMMENT "order_serialid"
    ,account               VARCHAR(765)                      COMMENT "订单表>用户账号"
    ,user_id               VARCHAR(765)                      COMMENT "订单表>用户ID"
    ,amount                DECIMAL(18,2)                     COMMENT "订单表>订单金额"
    ,dispute_amount        DECIMAL(18,2)                     COMMENT "初始争议金额"
    ,final_dispute_amount  DECIMAL(18,2)                     COMMENT "结算争议金额"
    ,dispute_fee           DECIMAL(18,2)                     COMMENT "结算争议费用"
    ,final_settle_amount   DECIMAL(18,2)                     COMMENT "结算总额"
    ,card_brand            VARCHAR(90)                       COMMENT "卡组织"
    ,currency              VARCHAR(30)                       COMMENT "货币"
    ,coins                 DECIMAL(18,2)                     COMMENT "订单表>代币"
    ,product_id            VARCHAR(765)                      COMMENT "订单表>产品ID"
    ,shop_item_id          VARCHAR(765)                      COMMENT "渠道ID"
    ,core                  INT                               COMMENT "订单表>core"
    ,os_type               INT                               COMMENT "订单表>平台,相当于mt,1-iOS,4-安卓,其他"
    ,order_create_time     DATETIME                          COMMENT "订单表>创建时间"
    ,coo_notify_time       DATETIME                          COMMENT "订单表>到账时间"
    ,coo_order_status      INT                               COMMENT "订单表>合作方扣款状态：1 成功"
    ,is_finish_sync        INT          NOT NULL DEFAULT '0' COMMENT "同步数据是否完整 1 是, 0 否"
    ,statusdispute_judged_result VARCHAR(90) NOT NULL        COMMENT "争议状态"
    ,stage                 VARCHAR(90)                       COMMENT "争议阶段"
    ,final_status          INT          NOT NULL             COMMENT "最终状态"
    ,reason                VARCHAR(1500)                     COMMENT "退款原因"
    ,detail_resp_data      STRING                            COMMENT "详情接口响应数据"
    ,insert_time           DATETIME     NOT NULL             COMMENT "添加时间"
    ,due_at                DATETIME     NOT NULL             COMMENT "回复截止时间"
    ,update_time           DATETIME     NOT NULL             COMMENT "更新时间"
    ,handler_status        INT          NOT NULL             COMMENT "处理状态：0 无，2 订单数据缺失"
    ,challenge_details     STRING                            COMMENT "证据"
    ,moneylog_data         STRING                            COMMENT "用户消费明细 shop_item_id = 800/830/840需提供"
    ,watchlog_data         STRING                            COMMENT "观看/阅读记录 shop_item_id=810/850需提供"
    ,is_order_sync         INT          NOT NULL DEFAULT '0' COMMENT "订单基础数据同步状态 1 已同步 0 待同步 2 同步失败"
    ,is_moneylog_sync      INT          NOT NULL DEFAULT '0' COMMENT "消费明细数据同步状态 1 已同步 0 待同步 shop_item_id = 800/830/840需提供"
    ,is_watchlog_sync      INT          NOT NULL DEFAULT '0' COMMENT "观看/阅读数据同步状态 1 已同步 0 待同步 shop_item_id=810/850需提供"
    ,moneylog_fileid       VARCHAR(600)                      COMMENT "消费明细文件id"
    ,watchlog_fileid       VARCHAR(600)                      COMMENT "观看记录文件id"
    ,order_fileid          VARCHAR(600)                      COMMENT "订单文件id"
    ,is_file_ready         INT          NOT NULL DEFAULT '0' COMMENT "文件是否已热加载 1 是, 0 否"
    ,send_overtime_warn_count INT                            COMMENT "警告次数"
    ,sr_createtime         DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据注入时间"
    ,sr_updatetime         DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "StarRocks数据更新时间"
)
PRIMARY KEY(dt, id)
COMMENT "airwallex争议表"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(id) BUCKETS 16
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "compression" = "lz4",
    "partition_live_number" = "733"
)
;