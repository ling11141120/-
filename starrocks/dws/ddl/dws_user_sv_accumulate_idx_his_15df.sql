drop table if exists dws.dws_user_sv_accumulate_idx_his_15df;
create table dws.dws_user_sv_accumulate_idx_his_15df (
     dt                         date           not null comment "分区日期"
    ,user_id                    bigint         not null comment "用户id"
    ,login_days_td              bigint                  comment "累计登录天数"
    ,login_cnt_td               bigint                  comment "累计登录次数"
    ,consume_amt_td             decimal(24, 8)          comment "累计消耗(代币、赠币)"
    ,consume_cnt_td             bigint                  comment "累积消费次数"
    ,consume_money_amt_td       decimal(24, 8)          comment "累计消耗代币数"
    ,consume_money_cnt_td       bigint                  comment "累积消费代币次数"
    ,consume_cert_amt_td        decimal(24, 8)          comment "累计消耗赠币"
    ,consume_cert_cnt_td        bigint                  comment "累积消费赠币次数"
    ,watch_days_td              bigint                  comment "累计观看天数"
    ,watch_tv_td                bitmap                  comment "累计观看剧集bitmap(剧id+集序号)"
    ,watch_cnt_td               bigint                  comment "累计观看次数(需要除以2再向上取整)"
    ,watch_series_td            bitmap                  comment "累计观看剧bitmap"
    ,like_cnt_td                bigint                  comment "累计点赞次数"
    ,like_series_td             bitmap                  comment "累计点赞剧bitmap"
    ,like_epis_td               bitmap                  comment "累计点赞剧集bitmap(剧id+集序号)"
    ,total_subscribe_amt        decimal(24, 8)          comment "累计订阅金额"
    ,total_subscribe_cnt        bigint                  comment "累计订阅次数"
    ,total_recharge_amt         decimal(24, 8)          comment "累计充值金额"
    ,total_recharge_cnt         bigint                  comment "累计充值次数"
    ,recharge_avg               decimal(24, 8)          comment "平均充值金额"
    ,total_subscribe_refund_cnt bigint                  comment "累计退订次数"
    ,total_refund_amt           decimal(24, 8)          comment "累计退款金额"
    ,total_refund_cnt           bigint                  comment "累计退款次数"
    ,mul_subscribe_item         bitmap                  comment "累计订阅类型bitmap"
    ,has_subscribe              bigint                  comment "历史有无订阅"
    ,idx_ddl                    date                    comment "指标截止日期"
    ,sign_card_total_price      decimal(18, 2)          comment "累计签到卡金额"
    ,vip_total_price            decimal(18, 2)          comment "累计VIP金额"
    ,svip_total_price           decimal(18, 2)          comment "累计SVIP金额"
)
primary key(dt, user_id)
comment "用户域-海剧用户累计指标历史-近15天全量"
partition by date_trunc('day', dt)
distributed by hash(user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "partition_live_number" = "16",
    "compression" = "LZ4"
)
;