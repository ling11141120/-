drop table if exists ads.ads_sv_user_vip_benefit_value_df;
create table ads.ads_sv_user_vip_benefit_value_df (
     dt                         date        not null    comment "统计日期"
    ,user_id                    bigint      not null    comment "用户id"
    ,stat_type                  int         not null    comment "统计周期,1:周口径,2:近三个月累计"
    ,vip_unlock_epis_cnt        bigint                  comment "VIP免费看剧去重集数"
    ,vip_ad_free_epis_cnt       bigint                  comment "VIP免广告观看天数"
    ,sign_card_gain_coin_cnt    bigint                  comment "签到卡累计已获得观看币"
    ,sign_card_gain_bonus_cnt   bigint                  comment "签到卡累计已获得礼券"
    ,etl_time                   datetime                comment "处理时间"
)
primary key(dt, user_id, stat_type)
comment "海剧用户会员中心权益价值感知"
partition by date_trunc("day",dt)
distributed by hash (dt, user_id, stat_type)
properties(
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4",
    "partition_live_number" = "5"
)
;