----------------------------------------------------------------
-- 目标表：ods_sensors_production_adinvocation
-- 来源实例：神策埋点
-- 来源表：event=ADInvocation
-- 来源负责人：无
-- 开发人：qhr
-- 开发日期：2026-06-08
----------------------------------------------------------------

create table if not exists ods_log.ods_sensors_production_adinvocation (
     dt                date        not null comment "分区日期"
    ,id                string      not null comment "nvl(rid,track_id)"
    ,track_id          string               comment "track_id"
    ,rid               string               comment "记录id"
    ,event_tm          datetime             comment "事件时间"
    ,device_id         string               comment "设备id"
    ,login_id          string               comment "login_id"
    ,identity_login_id string               comment "identity_login_id"
    ,device_lang       string               comment "设备语言"
    ,event             string               comment "事件"
    ,distinct_id       string               comment "distinct_id"
    ,app_product_id    string               comment "包体id"
    ,app_core_ver      string               comment "core"
    ,app_product_x     string               comment "应用程序id"
    ,app_channel       string               comment "渠道编号"
    ,app_lang_id       string               comment "界面语言"
    ,lib_version       string               comment "lib_version"
    ,app_version       string               comment "app_version"
    ,page_id           string               comment "页面ID"
    ,page_name         string               comment "页面名称(1)"
    ,ad_position_id1   string               comment "广告位ID"
    ,element_id        string               comment "控件ID"
    ,element_name      string               comment "控件名称"
    ,element_type      int                  comment "控件类型"
    ,ad_id             string               comment "广告ID"
    ,ad_platform       string               comment "广告平台"
    ,ad_source         string               comment "广告来源"
    ,ad_type           int                  comment "广告类型"
    ,main_strategy_id  string               comment "主策略ID"
    ,event_strategy_id string               comment "策略ID"
    ,etl_tm            datetime             comment "清洗时间"
    ,project_id        int                  comment "项目id：5阅读 8短剧"
    ,os                string               comment "操作系统"
    ,app_id            string               comment "app_id"
    ,ad_position_id    varchar(30)          comment "广告位置ID"
    ,appId             string               comment "海阅app_id"
    ,dollar_app_id     string               comment "$app_id，海剧海阅共有"
)
primary key(dt, id)
comment "event=ADInvocation 广告调用"
partition by date_trunc('day', dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;
