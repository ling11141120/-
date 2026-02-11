----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_pay_extend
-- 来源实例： old_tidb_source
-- 来源表： short_video.account_pay_extend
-- 来源负责：
-- 采集工具： 极光-定时链路
-- 开发人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_account_pay_extend;
create table ods.ods_tidb_short_video_account_pay_extend (
     id                               bigint         not null                   comment '用户id（accountId）'
    ,first_recharge_watch_series_num  int                                       comment '首充前观看剧数'
    ,first_recharge_watch_epis_num    int                                       comment '首充前观看集数'
    ,latest_third_recharge_time       datetime                                  comment '最近一次三方充值时间'
    ,registry_first_recharge_duration int                                       comment '注册到首充的分钟数'
    ,first_sign_card_price            decimal(18, 2)                            comment '首次签到卡金额'
    ,sign_card_total_price            decimal(18, 2)                            comment '累计签到卡金额'
    ,first_vip_price                  decimal(18, 2)                            comment '首次VIP金额'
    ,first_svip_price                 decimal(18, 2)                            comment '首次SVIP金额'
    ,vip_total_price                  decimal(18, 2)                            comment '累计VIP金额'
    ,svip_total_price                 decimal(18, 2)                            comment '累计SVIP金额'
    ,max_bonus_ratio                  int                                       comment '最高礼券加赠比例'
    ,latest_bonus_ratio               int                                       comment '最近一次礼券加赠比例 '
    ,create_time                      datetime                                  comment '创建时间'
    ,update_time                      datetime                                  comment '修改时间'
    ,sr_createtime                    datetime       default current_timestamp  comment 'starrocks数据注入时间'
    ,sr_updatetime                    datetime       default current_timestamp  comment 'starrocks数据更新时间'
)
primary key(id)
comment "用户支付扩展表"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

