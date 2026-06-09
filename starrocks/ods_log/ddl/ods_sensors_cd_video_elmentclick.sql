----------------------------------------------------------------
-- 目标表：ods_sensors_cd_video_elmentclick
-- 来源实例：
-- 来源表：
-- 来源负责人：xjc
-- 开发人：
-- 开发日期：2026-04-23
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_cd_video_elmentclick;
create table ods_log.ods_sensors_cd_video_elmentclick (
     dt                 date     not null comment "日期"
    ,id                 string   not null comment "主键"
    ,rid                string            comment "记录ID"
    ,track_id           string            comment "track_id"
    ,event              string            comment "事件"
    ,event_tm           datetime          comment "事件时间"
    ,app_channel        string            comment "渠道编号"
    ,app_id             string            comment "app_id"
    ,app_lang_id        string            comment "界面语言"
    ,device_lang        string            comment "设备语言"
    ,login_id           string            comment "用户ID"
    ,product_id         string            comment "产品ID"
    ,app_version        string            comment "应用版本"
    ,os                 string            comment "操作系统"
    ,ip                 string            comment "IP"
    ,city               string            comment "城市"
    ,province           string            comment "省份"
    ,country            string            comment "国家"
    ,lib                string            comment "lib"
    ,page_id            string            comment "页面ID"
    ,page_name          string            comment "页面名称"
    ,element_id         string            comment "控件ID"
    ,element_name       string            comment "控件名称"
    ,first_tag          string            comment "一级标签"
    ,second_tag         string            comment "二级标签"
    ,third_tag          string            comment "三级标签"
    ,element_type       string            comment "控件类型"
    ,shortplay_id       string            comment "短剧ID"
    ,episode_id         string            comment "剧集ID"
    ,watch_episode_sort string            comment "内容页剧集ID序号"
    ,button_status      string            comment "按钮状态"
    ,element_content    string            comment "元素内容"
    ,project_id         string            comment "5阅读 8 短剧"
    ,etl_tm             datetime          comment "清洗时间"
    ,book_id            varchar(255)      comment "书籍ID"
)
primary key(dt, id)
comment "event=elmentclick 控件点击事件"
partition by range(dt)
(partition p20260423 values less than ("2026-04-24"))
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-92",
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
