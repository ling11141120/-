drop table if exists ads.ads_user_short_video_c4_gold_earn_behavior;
create table ads.ads_user_short_video_c4_gold_earn_behavior (
     dt                     date       not null    comment "日期"
    ,user_id                bigint     not null    comment "用户id"
    ,total_cash_amt         decimal(16,2)          comment "用户拥有现金(累计值)，显示保留2位小数"
    ,total_coin_num         decimal(16,4)          comment "金币数(累计值)"
    ,interstitial_ad_cnt    int                    comment "插屏广告次数"
    ,rewarded_ad_cnt        int                    comment "激励视次数"
    ,today_ad_value         double                 comment "广告总价值"
    ,app_duration           decimal(16,2)          comment "app使用时长(秒)"
    ,total_login_days       int                    comment "总登录天数(累计值)"
    ,watch_episode_count    int                    comment "观看剧集次数"
    ,coin_user_type         int                    comment "金币用户类型,0=非金币|1=金币"
    ,etl_tm                 datetime               comment "etl清洗时间"
)
primary key (dt,user_id)
comment "海剧C4金币网赚版本1.6.5用户行为报表"
partition by date_trunc("day",dt)
distributed by hash (dt,user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "partition_live_number" = "61",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;

