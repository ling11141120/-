drop table if exists ads.ads_user_paywall_metrics_df;
create table ads.ads_user_paywall_metrics_df (
     dt                          date        not null                     comment "统计日期"
    ,user_id                     bigint      not null                     comment "用户id"
    ,recharge_unlock_epis_cnt    bigint                                   comment "前3d充值解锁集数"
    ,watch_min                   decimal(18, 2)                           comment "前3d观看分钟数"
    ,ad_unlock_epis_cnt          bigint                                   comment "前3d看广告解锁集数"
    ,watch_epis_cnt              bigint                                   comment "前3d看集数"
    ,watch_series_cnt            bigint                                   comment "前3d看剧数"
    ,max_watch_epis_cnt          bigint                                   comment "前3d单剧最大观看集数"
    ,max_active_time             datetime                                 comment "最大活跃时间"
    ,etl_time                    datetime    default current_timestamp    comment "清洗时间"
    ,recharge_amt                decimal(18, 2)                           comment "前3d充值金额"
    ,max_exp_strategy_id         varchar(128)                             comment "前3d曝光次数最多的半屏策略id"
)
primary key(dt, user_id)
comment "付费墙用户行为指标"
partition by date_trunc("day", dt)
distributed by hash(dt,user_id)
properties (
    "replication_num" = "3",
    "partition_live_number" = "14",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;