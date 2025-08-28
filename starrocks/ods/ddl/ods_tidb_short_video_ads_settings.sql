----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_ads_settings
-- 负责人： xxg
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_short_video_ads_settings;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_short_video_ads_settings (
     id                     BIGINT(20)    NOT NULL                  COMMENT '主键'
    ,strategy_name          VARCHAR(765)                            COMMENT '策略名称'
    ,ads_attr               INT(11)                                 COMMENT '广告属性 1通用 2降权'
    ,position_ids           VARCHAR(765)                            COMMENT '广告位置id数组 1限免卡降档-半屏充值弹层 2限免卡降档-首页弹窗 3 限免卡降档-返回推弹窗 4任务-签到额外奖励 5任务-看视频领观看券6任务-看广告领额外奖励 7播放页-观看激励视频解锁 8播放页-全屏原生 9播放页-instory 原生'
    ,ads_type               INT(11)                                 COMMENT '广告类型 1激励视频 2原生视频'
    ,status                 INT(11)                                 COMMENT '状态 0关闭 1开启'
    ,weight                 INT(11)                                 COMMENT '权重'
    ,group_ids              STRING                                  COMMENT '选中人群包id逗号拼接'
    ,group_names            STRING                                  COMMENT '选中人群包名称逗号拼接'
    ,exclude_group_ids      STRING                                  COMMENT '剔除人群包id 逗号拼接'
    ,exclude_group_names    STRING                                  COMMENT '剔除人群包名称 逗号拼接'
    ,mt                     INT(11)                                 COMMENT '平台 1ios 4Android'
    ,lang_ids               VARCHAR(765)                            COMMENT '语言id 逗号拼接'
    ,min_ver_id             INT(11)                                 COMMENT '服务器最小版本'
    ,max_ver_id             INT(11)                                 COMMENT '服务器最大版本'
    ,ads_platform           INT(11)                                 COMMENT '广告平台'
    ,ads_id                 VARCHAR(765)                            COMMENT '广告id'
    ,create_time            DATETIME                                COMMENT '创建时间'
    ,update_time            DATETIME                                COMMENT '修改时间'
    ,sr_createtime          DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime          DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
PRIMARY KEY(id)
COMMENT '海剧-广告id配置表'
DISTRIBUTED BY HASH(id) BUCKETS 1
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "storage_format" = "DEFAULT",
            "enable_persistent_index" = "true",
            "compression" = "LZ4"
            )
;