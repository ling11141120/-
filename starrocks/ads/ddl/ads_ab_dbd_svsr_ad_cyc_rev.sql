create table if not exists ads.ads_ab_dbd_svsr_ad_cyc_rev (
     dt                 date           not null comment '日期'
    ,core               int(11)        not null comment 'core'
    ,project_id         int(3)         not null comment '项目id'
    ,period_type        varchar(60)    not null comment '周期类型'
    ,day0_amount_byad   decimal(12, 6)          comment '当天广告收益'
    ,day1_amount_byad   decimal(12, 6)          comment '累计1天广告收益'
    ,day2_amount_byad   decimal(12, 6)          comment '累计2天广告收益'
    ,day3_amount_byad   decimal(12, 6)          comment '累计3天广告收益'
    ,day7_amount_byad   decimal(12, 6)          comment '累计7天广告收益'
    ,day15_amount_byad  decimal(12, 6)          comment '累计15天广告收益'
    ,day21_amount_byad  decimal(12, 6)          comment '累计21天广告收益'
    ,day30_amount_byad  decimal(12, 6)          comment '累计30天广告收益'
    ,day45_amount_byad  decimal(12, 6)          comment '累计45天广告收益'
    ,day60_amount_byad  decimal(12, 6)          comment '累计60天广告收益'
    ,day90_amount_byad  decimal(12, 6)          comment '累计90天广告收益'
    ,day120_amount_byad decimal(12, 6)          comment '累计120天广告收益'
)
primary key (dt, core, project_id, period_type)
comment 'AB测试-运营看板-海剧海阅广告周期收益表'
partition by date_trunc('month', dt)
distributed by hash(dt, core, project_id, period_type)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;