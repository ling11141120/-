drop table if exists dws.dws_user_sv_accumulate_idx_di;
create table dws.dws_user_sv_accumulate_idx_di (
     user_id                    bigint         not null            comment "用户id"
    ,login_days_td              bigint         sum                 comment "累计登录天数"
    ,login_cnt_td               bigint         sum                 comment "累计登录次数"
    ,consume_amt_td             decimal(24, 8) sum                 comment "累计消耗(代币、赠币)"
    ,consume_cnt_td             bigint         sum                 comment "累积消费次数"
    ,consume_money_amt_td       decimal(24, 8) sum                 comment "累计消耗代币数"
    ,consume_money_cnt_td       bigint         sum                 comment "累积消费代币次数"
    ,consume_cert_amt_td        decimal(24, 8) sum                 comment "累计消耗赠币"
    ,consume_cert_cnt_td        bigint         sum                 comment "累积消费赠币次数"
    ,watch_days_td              bigint         sum                 comment "累计观看天数"
    ,watch_tv_td                bitmap         bitmap_union        comment "累计观看剧集bitmap(剧id+集序号)"
    ,watch_cnt_td               bigint         sum                 comment "累计观看次数(需要除以2再向上取整)"
    ,watch_series_td            bitmap         bitmap_union        comment "累计观看剧bitmap"
    ,like_cnt_td                bigint         sum                 comment "累计点赞次数"
    ,like_series_td             bitmap         bitmap_union        comment "累计点赞剧bitmap"
    ,like_epis_td               bitmap         bitmap_union        comment "累计点赞剧集bitmap(剧id+集序号)"
    ,total_subscribe_amt        decimal(24, 8) sum                 comment "累计订阅金额"
    ,total_subscribe_cnt        bigint         sum                 comment "累计订阅次数"
    ,total_recharge_amt         decimal(24, 8) sum                 comment "累计充值金额"
    ,total_recharge_cnt         bigint         sum                 comment "累计充值次数"
    ,recharge_avg               decimal(24, 8) replace_if_not_null comment "平均充值金额"
    ,total_subscribe_refund_cnt bigint         sum                 comment "累计退订次数"
    ,total_refund_amt           decimal(24, 8) sum                 comment "累计退款金额"
    ,total_refund_cnt           bigint         sum                 comment "累计退款次数"
    ,mul_subscribe_item         bitmap         bitmap_union        comment "累计订阅类型bitmap"
    ,has_subscribe              bigint         max                 comment "历史有无订阅"
    ,idx_ddl                    date           replace_if_not_null comment "指标截止日期"
)
aggregate key(user_id)
comment "用户域-海剧用户累计指标表"
distributed by hash(user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;