drop table if exists dws.dws_sv_ads_position_play_data_di;
create table dws.dws_sv_ads_position_play_data_di (
    dt                  date        not null    comment "分区日期",
    ad_position_id      int(11)     not null    comment "广告位置id",
    product_id          int(11)     not null    comment "产品id",
    core                int(11)     not null    comment "core",
    exposure_cnt        int(11)     null        comment "曝光次数",
    exposure_unt        int(11)     null        comment "曝光人数",
    click_cnt           int(11)     null        comment "点击次数",
    click_unt           int(11)     null        comment "点击人数",
    show_cnt            int(11)     null        comment "播放次数",
    show_unt            int(11)     null        comment "播放人数",
    watch_cnt           int(11)     null        comment "完播次数",
    watch_unt           int(11)     null        comment "完播人数",
    etl_tm              datetime    not null    comment "清洗时间"
)
primary key(dt, ad_position_id, product_id, core)
comment "海剧-广告位置曝光点击播放数据"
distributed by hash(dt, ad_position_id, product_id, core) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "ssd",
    "compression" = "zstd"
);