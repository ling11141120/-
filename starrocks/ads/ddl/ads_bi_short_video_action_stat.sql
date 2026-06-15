CREATE TABLE ads_bi_short_video_action_stat (
     dt                          date          NOT NULL COMMENT "日期"
    ,md5_key                     varchar(65533)NOT NULL COMMENT "主键key"
    ,series_id                   bigint(20)             COMMENT "短剧ID"
    ,is_toufang                  smallint(6)            COMMENT "用户维度(是否引流):0:全部；1：引流；2：非引流"
    ,user_subscribe_type         varchar(128)           COMMENT "用户订阅类型编码：810(SVIP)/860(NSVIP)/840(新福利包)/0(普通充值)/其他"
    ,source                      varchar(65533)         COMMENT "媒体"
    ,mt                          smallint(6)            COMMENT "终端"
    ,core                        smallint(6)            COMMENT "core"
    ,product_id                  smallint(6)            COMMENT "产品名称"
    ,series_name                 varchar(65533)         COMMENT "短剧名称"
    ,series_language             smallint(6)            COMMENT "短剧语言"
    ,last_epis                   bigint(20)             COMMENT "发布剧集"
    ,series_code                 varchar(65533)         COMMENT "短剧代号"
    ,series_tp                   varchar(65533)         COMMENT "短剧分类"
    ,publish_tm                  datetime               COMMENT "上架时间"
    ,click_user_bitmap           bitmap                 COMMENT "点击user的bitmap"
    ,exposure_user_bitmap        bitmap                 COMMENT "曝光user的bitmap"
    ,all_unlock_user_bitmap      bitmap                 COMMENT "解锁user的bitmap（不分解锁类型）"
    ,consume_unlock_user_bitmap  bitmap                 COMMENT "消费解锁user的bitmap"
    ,svip_unlock_user_bitmap     bitmap                 COMMENT "svip解锁user的bitmap"
    ,ad_unlock_user_bitmap       bitmap                 COMMENT "广告解锁user的bitmap"
    ,watch_user_bitmap           bitmap                 COMMENT "观看用户bitmap"
    ,svip_watch_user_bitmap      bitmap                 COMMENT "svip观看用户bitmap"
    ,all_unlock_epis_cnt         int(11)                COMMENT "用户解锁总集数（不分解锁类型）"
    ,consume_unlock_epis_cnt     int(11)                COMMENT "用户消费解锁总集数"
    ,svip_unlock_epis_cnt        int(11)                COMMENT "用户svip解锁总集数"
    ,ad_unlock_epis_cnt          int(11)                COMMENT "用户广告解锁总集数"
    ,etl_time                    datetime     NOT NULL COMMENT "数据清洗时间"
    ,INDEX index_series_language (series_language) USING BITMAP COMMENT "短剧语言索引"
) ENGINE=OLAP
PRIMARY KEY(dt, md5_key)
COMMENT "海外短剧行为统计表"
DISTRIBUTED BY HASH(dt, md5_key) BUCKETS 210
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
