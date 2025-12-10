----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_ElmentExposure
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： qhr/xjc
-- 开发日期： 2025-10-21
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_ElmentExposure;
create table ods_log.ods_sensors_cd_video_ElmentExposure (
     dt                    date      not null    comment "日期"
    ,id                    string    not null    comment "主键"
    ,rid                   string                comment "记录ID"
    ,track_id              string                comment "track_id"
    ,event                 string                comment "事件"
    ,event_tm              datetime              comment "事件时间"
    ,app_channel           string                comment "渠道编号"
    ,app_id                string                comment "app_id"
    ,app_lang_id           string                comment "界面语言"
    ,device_lang           string                comment "设备语言"
    ,login_id              string                comment "用户ID"
    ,product_id            string                comment "产品ID"
    ,app_version           string                comment "应用版本"
    ,os                    string                comment "操作系统"
    ,ip                    string                comment "IP"
    ,city                  string                comment "城市"
    ,province              string                comment "省份"
    ,country               string                comment "国家"
    ,lib                   string                comment "lib"
    ,page_id               string                comment "页面id"
    ,page_name             string                comment "页面名称"
    ,element_id            string                comment "控件ID"
    ,element_name          string                comment "控件名称"
    ,first_tag_list        string                comment "一级标签列表"
    ,second_tag_list       string                comment "二级标签列表"
    ,third_tag_list        string                comment "三级标签列表"
    ,shortplay_id          string                comment "短剧ID（仅在视频播放页上报）"
    ,episode_id            string                comment "剧集ID（仅在视频播放页上报）"
    ,watch_episode_sort    string                comment "内容页剧集ID序号（仅在视频播放页上报）"
    ,button_status         string                comment "按钮状态（例如：开/关，适用于点赞、追剧等开关状态的按钮）"
    ,element_content       string                comment "元素内容（适用于类似倍速控件、选集控件等带有数值信息的控件或特殊对象时记录曝光/点击元素的内容）"
    ,project_id            string                comment "5阅读 8 短剧"
    ,zffs_list             string                comment "支付方式列表"
    ,sfzf_strategy_id      string                comment "策略id"
    ,element_index         string                comment "元素索引"
    ,activity_id           string                comment "活动id"
    ,group_id              string                comment "分组id"
    ,app_core_ver          string                comment "core"
    ,anonymous_id          string                comment "匿名id"
    ,etl_tm                datetime              comment "清洗时间"
)
primary key(dt, id)
comment "event=elmentExposure 控件曝光事件"
partition by range(dt)
(partition p20251027 values less than ("2025-10-27"))
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "2"
   ,"dynamic_partition.enable" = "true"
   ,"dynamic_partition.time_unit" = "DAY"
   ,"dynamic_partition.time_zone" = "Asia/Shanghai"
   ,"dynamic_partition.start" = "-90"
   ,"dynamic_partition.end" = "3"
   ,"dynamic_partition.prefix" = "p"
   ,"dynamic_partition.buckets" = "3"
   ,"dynamic_partition.history_partition_num" = "0"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "ZSTD"
)
;