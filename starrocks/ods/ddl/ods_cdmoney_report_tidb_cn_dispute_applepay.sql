----------------------------------------------------------------
-- 目标表： ods.ods_cdmoney_report_tidb_cn_dispute_applepay
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.dispute_applepay
-- 来源负责： 
-- 采集工具： 极光定时采集
-- 开发人： xjc
-- 开发日期： 2026-03-09
----------------------------------------------------------------

drop table if exists ods.ods_cdmoney_report_tidb_cn_dispute_applepay;
create table ods.ods_cdmoney_report_tidb_cn_dispute_applepay (
    id                          bigint      not null                     comment "Desc:自增ID"
   ,pay_channel_id              varchar(500)                             comment "渠道ID"
   ,pay_channel_name            varchar(500)                             comment "渠道名称"
   ,coo_order_id                varchar(500)                             comment ":支付订单号,合作方回传的,paypal提供的,当做唯一标识争议id"
   ,order_id                    varchar(500)                             comment "订单表>订单号"
   ,order_serialid              varchar(500)                             comment "order_serialid"
   ,account                     varchar(1000)                            comment "订单表>用户账号"
   ,user_id                     varchar(1000)                            comment "订单表>用户ID"
   ,amount                      decimal(18,2)                            comment "订单表>订单金额"
   ,dispute_fee                 decimal(18,2)                            comment "争议费用，等同于订单金额"
   ,coins                       decimal(18,2)                            comment "订单表>代币"
   ,product_id                  varchar(1000)                            comment "订单表>产品ID"
   ,shop_item_id                varchar(1000)                            comment "渠道ID"
   ,core                        int                                      comment "订单表>core"
   ,os_type                     int                                      comment "订单表>平台,相当于mt,1-iOS,4-安卓,其他"
   ,order_create_time           datetime                                 comment "订单表>创建时间"
   ,coo_notify_time             datetime                                 comment "订单表>到账时间"
   ,coo_order_status            int                                      comment "订单表>合作方扣款状态：1 成功"
   ,appAccountToken             varchar(100)                             comment "需要在用户购买时为每位用户生成唯一的UUID  订单里的Ext2"
   ,consumptionStatus           int                                      comment "1（没有消费）2(部分消费) 或 3(全部消费)。"
   ,account_add_time            datetime                                 comment "用户账号创建时间"
   ,account_lastlogin_time      datetime                                 comment "用户账号最后登陆时间"
   ,account_vipexpiretime       datetime                                 comment "vip到期时间"
   ,account_realmoney           int                                      comment "获得的阅币"
   ,account_giftmoney           int                                      comment "礼券"
   ,lifetimeDollarsPurchased    decimal(18,2)                            comment "户历史上在您APP内的总充值金额（美元）"
   ,lifetimeDollarsRefunded     decimal(18,2)                            comment "填写该用户历史上在您APP内的总退款金额（美元）"
   ,sampleContentProvided       int                                      comment "购买前是否允许用户试用或预览（例如免费试用期）。 1 是, 0 否,用户购买的是0+X档位则：true"
   ,is_finish_sync              int                                      comment "同步数据是否完整 1 是, 0 否"
   ,playTime                    bigint                                   comment "阅读时长，单位秒"
   ,status                      int                                      comment "争议状态"
   ,final_status                int                                      comment "最终状态"
   ,detail_resp_data            varchar(40000)                           comment "详情接口响应数据"
   ,insert_time                 datetime                                 comment "添加时间"
   ,evidence_due_by             datetime                                 comment "回复截止时间"
   ,update_time                 datetime                                 comment "更新时间"
   ,handler_status              int                                      comment "处理状态：0 无，2 订单数据缺失"
   ,consumptionRequestReason    varchar(10000)                           comment "原因"
   ,final_settle_amount         decimal(18,2)                            comment "结算总额"
   ,is_support_submit           int                                      comment "支持自动提交 0否 1是"
   ,sr_createtime               datetime    default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime               datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "苹果争议表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;