----------------------------------------------------------------
-- 目标表： ods.ods_cdmoney_report_tidb_cn_dispute_stripe
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.dispute_stripe
-- 来源负责： 
-- 采集工具： 极光定时采集
-- 开发人： xjc
-- 开发日期： 2026-03-09
----------------------------------------------------------------

drop table if exists ods.ods_cdmoney_report_tidb_cn_dispute_stripe;
create table ods.ods_cdmoney_report_tidb_cn_dispute_stripe (
    id                                   bigint      not null                     comment "自增ID"
   ,pay_channel_id                       varchar(300)                             comment "渠道ID"
   ,dispute_id                           varchar(300)                             comment "争议ID"
   ,charge_id                            varchar(300)                             comment "交易id"
   ,amount                               decimal(11,2)                            comment "争议金额（元）"
   ,dispute_fee                          decimal(11,2)                            comment "stripe处理费(初始),预扣争议费用"
   ,balance_transactions_amount          decimal(11,2)                            comment "争议金额(初始)"
   ,settle_amount                        decimal(11,2)                            comment "预扣款总额(初始)"
   ,final_settle_amount                  decimal(11,2)                            comment "结算总额(最终)"
   ,final_balance_transactions_amount    decimal(11,2)                            comment "争议金额(最终)"
   ,final_dispute_fee                    decimal(11,2)                            comment "stripe处理费(最终)"
   ,currency                             varchar(100)                             comment "三位货币代码（如USD）用于展示各项费用"
   ,stage                                varchar(300)                             comment "争议阶段"
   ,status                               varchar(300)                             comment "争议状态"
   ,final_status                         int                                      comment "最终状态"
   ,reason                               varchar(300)                             comment "争议原因"
   ,EvidenceDetails                      varchar(65533)                           comment "争议细节"
   ,evidences                            varchar(65533)                           comment "证据"
   ,evidence_due_by                      datetime                                 comment "回复截止时间"
   ,detail_resp_data                     varchar(1048576)                         comment "详情接口响应数据"
   ,evidence_resp_data                   varchar(1048576)                         comment "提供证据接口响应数据"
   ,reply_resp_data                      varchar(1048576)                         comment "回复接口响应数据"
   ,insert_time                          datetime                                 comment "添加时间"
   ,update_time                          datetime                                 comment "更新时间"
   ,is_exec                              int                                      comment "当前节点是否已执行,流转到下个节点重置为0"
   ,auto_send_evidence_count             int                                      comment "自动提交证据次数"
   ,send_overtime_warn_count             int                                      comment "超时预警推送次数"
   ,send_multiple_reply_warn_count       int                                      comment "买家多次回复消息预警推送次数"
   ,is_reply                             int                                      comment "是否有回复消息"
   ,buyer_evidence_count                 int                                      comment "买家证据数量"
   ,seller_evidence_count                int                                      comment "卖家证据数量"
   ,handler_status                       int                                      comment "处理状态：0 待处理，2 订单数据缺失，3 自动回复失败，4 自动回复成功，5-人工回复成功"
   ,paymentmethod_type                   varchar(150)                             comment "支付类型"
   ,counter_fee                          decimal(11,2)                            comment "反驳费"
   ,sr_createtime                        datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime                        datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "Stripe争议表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;