create table if not exists dwd.dwd_flow_user_adposition_exposure (
     dt               date     not null comment "分区日期"
    ,id               string   not null comment "nvl(rid,track_id)"
    ,track_id         string            comment ""
    ,rid              string            comment "记录ID"
    ,event_tm         datetime          comment "事件时间"
    ,device_id        string            comment "设备id"
    ,login_id         bigint            comment "login_id"
    ,user_id          bigint            comment "用户id 来源：identity_login_id"
    ,device_lang      string            comment "设备语言"
    ,event            string            comment "事件"
    ,distinct_id      bigint            comment "distinct_id"
    ,identity_user_id bigint            comment "identity_userid"
    ,product_id       int               comment "产品id"
    ,send_id          string            comment "转化来源"
    ,corever          int               comment "core"
    ,app_channel      string            comment "渠道编号"
    ,app_product_x    int               comment "应用程序ID"
    ,current_language int               comment "界面语言 "
    ,lib_version      string            comment "埋点的开发版本号"
    ,appver           string            comment "app版本号"
    ,page_id          int               comment "页面ID"
    ,page_name        string            comment "页面名称"
    ,ad_position_id   int               comment "广告位ID"
    ,project_id       int               comment "5阅读 8 短剧"
    ,etl_tm           datetime          comment "清洗时间"
    ,index index_productid (product_id) using bitmap comment 'index_productid'
)
primary key(dt, id)
comment "event=ADPositionExposure 用户资源位（广告位置）曝光数据"
partition by range(dt)
(partition p20260611 values less than ("2026-06-12"))
distributed by hash(dt, id) buckets 3
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "user_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-30",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "18",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;
