drop table if exists ads.ads_wide_short_video_user_info_a;
create table ads.ads_wide_short_video_user_info_a (
     dt                         date           not null comment "统计日期"
    ,product_id                 smallint       not null comment "产品名称"
    ,user_id                    bigint         not null comment "用户id"
    ,sex                        smallint                comment "性别"
    ,reg_tm                     datetime                comment "用户的注册时间"
    ,mt                         smallint                comment "平台 0未知 1iphone 4安卓 9书城"
    ,mt2                        smallint                comment "注册时平台 0未知 1iphone 4安卓 9书城"
    ,corever                    smallint                comment "当前core"
    ,corever2                   smallint                comment "注册时core"
    ,app_ver                    string                  comment "app版本"
    ,ver                        bigint                  comment "客户端版本号"
    ,current_language           bigint                  comment "用户当前语言"
    ,current_language2          bigint                  comment "注册时语言"
    ,reg_country                string                  comment "注册时国家，不会变化"
    ,is_bound_email             smallint                comment "是否绑定邮箱 1:是 0：否"
    ,fst_login_tm               datetime                comment "首次登录时间"
    ,lst_login_tm               datetime                comment "上一次登录时间"
    ,new_login_tm               datetime                comment "最新登录时间"
    ,login_days_td              bigint                  comment "累计登录天数"
    ,login_cnt_td               bigint                  comment "累计登录次数"
    ,remain_day                 bigint                  comment "登录留存天数"
    ,consume_amt_td             decimal(24, 8)          comment "累计消耗(代币、赠币)"
    ,fst_consume_tm             datetime                comment "首次消费时间"
    ,lst_consume_tm             datetime                comment "最近一次消费时间"
    ,consume_cnt_td             bigint                  comment "累积消费次数"
    ,consume_tv_td              bitmap                  comment "消费剧集bitmap(剧id+集序号)"
    ,consume_money_amt_td       decimal(24, 8)          comment "累计消耗代币数"
    ,fst_consume_money_tm       datetime                comment "首次消费代币时间"
    ,lst_consume_money_tm       datetime                comment "最近一次消费代币时间"
    ,consume_money_cnt_td       bigint                  comment "累积消费代币次数"
    ,consume_money_tv_td        bitmap                  comment "代币消费剧集bitmap(剧id+集序号)"
    ,consume_cert_amt_td        decimal(24, 8)          comment "累计消耗赠币"
    ,fst_consume_cert_tm        datetime                comment "首次消费赠币时间"
    ,lst_consume_cert_tm        datetime                comment "最近一次消费赠币时间"
    ,consume_cert_cnt_td        bigint                  comment "累积消费赠币次数"
    ,consume_cert_tv_td         bitmap                  comment "赠币消费剧集bitmap(剧id+集序号)"
    ,fst_watch_tm               datetime                comment "首次观看时间"
    ,lst_watch_tm               datetime                comment "末次观看时间"
    ,watch_series_td            bitmap                  comment "累计观看剧的bitmap"
    ,watch_tv_td                bitmap                  comment "累计观看剧集bitmap(剧id+集序号)"
    ,watch_days_td              bigint                  comment "累计观看天数"
    ,watch_cnt_td               bigint                  comment "累计观看次数(需要除以2再向上取整)"
    ,new_epis_series_td         bitmap                  comment "观看到了最新剧集的剧集"
    ,total_subscribe_amt        decimal(24, 8)          comment "累计订阅金额（不考虑退款因素）"
    ,first_subscribe_amt        decimal(24, 8)          comment "首次订阅金额"
    ,first_subscribe_tp         smallint                comment "首次订阅类型"
    ,first_subscribe_tm         datetime                comment "首次订阅时间"
    ,last_subscribe_amt         decimal(24, 8)          comment "最后订阅金额"
    ,last_subscribe_tp          smallint                comment "最后订阅类型"
    ,last_subscribe_tm          datetime                comment "最后订阅时间"
    ,total_subscribe_cnt        bigint                  comment "累计订阅次数（不考虑退款因素）"
    ,total_subscribe_refund_cnt bigint                  comment "累计退订次数"
    ,is_mul_subscribe           smallint                comment "有无多项订阅"
    ,has_subscribe              bigint                  comment "历史有无订阅"
    ,first_recharge_amt         decimal(24, 8)          comment "首次充值金额"
    ,first_recharge_tm          datetime                comment "首次充值时间"
    ,total_recharge_amt         decimal(24, 8)          comment "累计充值金额"
    ,total_refund_amt           decimal(24, 8)          comment "累计退款金额"
    ,total_recharge_cnt         bigint                  comment "累计充值次数"
    ,total_refund_cnt           bigint                  comment "累计退款次数"
    ,recharge_avg               decimal(24, 8)          comment "平均充值金额"
    ,recharge_max               decimal(24, 8)          comment "最大充值金额"
    ,month_recharge_max         decimal(24, 8)          comment "近一个月最大充值金额"
    ,last_recharge_amt          decimal(24, 8)          comment "最后充值金额"
    ,last_recharge_tm           datetime                comment "最近充值时间"
    ,charge_mode                decimal(24, 8)          comment "充值众数（不考虑退款因素）"
    ,fst_like_tm                datetime                comment "首次点赞时间"
    ,lst_like_tm                datetime                comment "末次点赞时间"
    ,like_series_td             bitmap                  comment "累计点赞剧的bitmap"
    ,like_epis_td               bitmap                  comment "累计点赞剧集bitmap(剧id+集序号)"
    ,like_cnt_td                bigint                  comment "累计点赞次数"
    ,fst_install_book_id        bigint                  comment "首次引流书籍"
    ,lst_install_book_id        bigint                  comment "最新引流书籍"
    ,lst_source                 string                  comment "最新媒体值"
    ,lst_install_date           datetime                comment "最新激活时间"
    ,etl_time                   datetime                comment "数据清洗时间"
)
primary key(dt, product_id, user_id)
comment "海剧用户累计指标表"
partition by range(dt)
(partition p20251223 values less than ("2025-12-24"))
distributed by hash(product_id, user_id) buckets 12
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-365",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "70",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;