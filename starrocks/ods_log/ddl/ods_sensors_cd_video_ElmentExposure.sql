----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_ElmentExposure
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr
-- 开发日期： 2025-10-21
----------------------------------------------------------------

DROP TABLE IF EXISTS ods_log.ods_sensors_cd_video_ElmentExposure;
CREATE TABLE ods_log.ods_sensors_cd_video_ElmentExposure (
     dt                DATE        NOT NULL COMMENT "日期"
    ,id                STRING      NOT NULL COMMENT "主键"
    ,rid               STRING               COMMENT "记录ID"
    ,track_id          STRING               COMMENT "track_id"
    ,event             STRING               COMMENT "事件"
    ,event_tm          DATETIME             COMMENT "事件时间"
    ,app_channel       STRING               COMMENT "渠道编号"
    ,app_id            STRING               COMMENT "app_id"
    ,app_lang_id       STRING               COMMENT "界面语言"
    ,device_lang       STRING               COMMENT "设备语言"
    ,login_id          STRING               COMMENT "用户ID"
    ,product_id        STRING               COMMENT "产品ID"
    ,app_version       STRING               COMMENT "应用版本"
    ,os                STRING               COMMENT "操作系统"
    ,ip                STRING               COMMENT "IP"
    ,city              STRING               COMMENT "城市"
    ,province          STRING               COMMENT "省份"
    ,country           STRING               COMMENT "国家"
    ,lib               STRING               COMMENT "lib"
    ,page_id           STRING               COMMENT "页面id"
    ,page_name         STRING               COMMENT "页面名称"
    ,element_id        STRING               COMMENT "控件ID"
    ,element_name      STRING               COMMENT "控件名称"
    ,first_tag_list    STRING               COMMENT "一级标签列表"
    ,second_tag_list   STRING               COMMENT "二级标签列表"
    ,third_tag_list    STRING               COMMENT "三级标签列表"
    ,shortplay_id      STRING               COMMENT "短剧ID（仅在视频播放页上报）"
    ,episode_id        STRING               COMMENT "剧集ID（仅在视频播放页上报）"
    ,watch_episode_sort STRING              COMMENT "内容页剧集ID序号（仅在视频播放页上报）"
    ,button_status     STRING               COMMENT "按钮状态（例如：开/关，适用于点赞、追剧等开关状态的按钮）"
    ,element_content   STRING               COMMENT "元素内容（适用于类似倍速控件、选集控件等带有数值信息的控件或特殊对象时记录曝光/点击元素的内容）"
    ,project_id        STRING               COMMENT "5阅读 8 短剧"
    ,zffs_list         STRING               COMMENT ""
    ,sfzf_strategy_id  STRING               COMMENT ""
    ,element_index     STRING               COMMENT ""
    ,activity_id       STRING               COMMENT ""
    ,group_id          STRING               COMMENT ""
    ,app_core_ver      STRING               COMMENT "core"
    ,etl_tm            DATETIME             COMMENT "清洗时间"
) 
PRIMARY KEY(dt, id)
COMMENT "event=ElmentExposure 控件曝光事件"
PARTITION BY RANGE(dt)
(PARTITION p20251027 VALUES LESS THAN ("2025-10-27"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-90",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;