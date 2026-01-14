drop table if exists dws.dws_user_sv_status_idx_his_15df;
create table dws.dws_user_sv_status_idx_his_15df (
     dt                         date           not null comment "分区日期"
    ,user_id                    bigint         not null comment "用户id"
    ,fst_login_tm               datetime                comment "首次登录时间"
    ,lst_login_tm               datetime                comment "上一次登录时间"
    ,new_login_tm               datetime                comment "最新登录时间"
    ,remain_day                 bigint                  comment "登录留存天数"
    ,fst_consume_tm             datetime                comment "首次消费时间"
    ,lst_consume_tm             datetime                comment "最近一次消费时间"
    ,consume_tv_td              bitmap                  comment "消费剧集bitmap(剧id+集序号)"
    ,fst_consume_money_tm       datetime                comment "首次消费代币时间"
    ,lst_consume_money_tm       datetime                comment "最近一次消费代币时间"
    ,consume_money_tv_td        bitmap                  comment "代币消费剧集bitmap(剧id+集序号)"
    ,fst_consume_cert_tm        datetime                comment "首次消费赠币时间"
    ,lst_consume_cert_tm        datetime                comment "最近一次消费赠币时间"
    ,consume_cert_tv_td         bitmap                  comment "赠币消费剧集bitmap(剧id+集序号)"
    ,fst_watch_tm               datetime                comment "首次观看时间"
    ,lst_watch_tm               datetime                comment "末次观看时间"
    ,new_epis_series_td         bitmap                  comment "观看到了最新剧集的剧集"
    ,first_subscribe_amt        decimal(24, 8)          comment "首次订阅金额"
    ,first_subscribe_tp         smallint                comment "首次订阅类型"
    ,first_subscribe_tm         datetime                comment "首次订阅时间"
    ,last_subscribe_amt         decimal(24, 8)          comment "最后订阅金额"
    ,last_subscribe_tp          smallint                comment "最后订阅类型"
    ,last_subscribe_tm          datetime                comment "最后订阅时间"
    ,first_recharge_amt         decimal(24, 8)          comment "首次充值金额"
    ,first_recharge_tm          datetime                comment "首次充值时间"
    ,recharge_max               decimal(24, 8)          comment "最大充值金额"
    ,month_recharge_max         decimal(24, 8)          comment "近一个月最大充值金额"
    ,last_recharge_amt          decimal(24, 8)          comment "最后充值金额"
    ,last_recharge_tm           datetime                comment "最近充值时间"
    ,charge_mode                decimal(24, 8)          comment "充值众数（不考虑退款因素）"
    ,fst_like_tm                datetime                comment "首次点赞时间"
    ,lst_like_tm                datetime                comment "末次点赞时间"
    ,fst_install_book_id        bigint                  comment "首次引流书籍"
    ,lst_install_book_id        bigint                  comment "最新引流书籍"
    ,lst_source                 varchar(40)             comment "最新媒体值"
    ,lst_install_date           datetime                comment "最新激活时间"
    ,etl_time                   datetime                comment "etl时间"
)
primary key(dt, user_id)
comment "用户域-海剧用户状态指标表-近15天全量"
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