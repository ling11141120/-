----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_production_element_expose
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：qhr/xjc
-- 开发日期：2025-12-01
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_production_element_expose;
create table ods_log.ods_sensors_production_element_expose (
     dt                       date      not null    comment "分区日期"
    ,id                       string    not null    comment "nvl(rid,track_id)"
    ,track_id                 string                comment ""
    ,rid                      string                comment "记录ID"
    ,event_tm                 datetime              comment "事件时间"
    ,device_id                string                comment "设备id"
    ,login_id                 string                comment "login_id"
    ,identity_login_id        string                comment "identity_login_id"
    ,device_lang              string                comment "设备语言"
    ,event                    string                comment "事件"
    ,distinct_id              string                comment "distinct_id"
    ,identity_user_id         string                comment "identity_userid"
    ,app_product_id           string                comment "包体ID"
    ,send_id                  string                comment "转化来源"
    ,app_core_ver             string                comment "core"
    ,app_channel              string                comment "渠道编号"
    ,app_product_x            string                comment "应用程序ID"
    ,app_lang_id              string                comment "界面语言"
    ,page_name                string                comment "页面名称"
    ,page_id                  string                comment "页面ID"
    ,element_name             string                comment "控件名称"
    ,element_id               string                comment "控件ID"
    ,payment_method           string                comment "支付方式"
    ,type                     string                comment "类型"
    ,activity_id              string                comment "活动id"
    ,parent_group_id          string                comment "用户集合ID"
    ,group_id                 string                comment "用户分组ID"
    ,etl_tm                   datetime              comment "清洗时间"
    ,lib                      string                comment "lib"
    ,activity_link            varchar(1024)         comment "活动链路"
    ,pay_link                 varchar(1024)         comment "支付链路"
    ,os                       varchar(1024)         comment "操作系统"
    ,ad_group_id              string                comment "广告人群包ID"
    ,ad_strategy_id           string                comment "广告策略ID"
    ,ad_position_id           string                comment "广告位ID"
    ,type2                    string                comment "类型2"
    ,module_channel_id        string                comment "频道ID"
    ,programme_id             string                comment "方案ID"
    ,click_content            string                comment "点击内容"
    ,event_strategy_id        string                comment "策略ID"
    ,main_strategy_id         string                comment "主策略ID"
    ,app_module               string                comment "模块"
    ,book_category_id_list    string                comment "书籍分类ID列表"
    ,zffs_strategy_id         string                comment "支付方式策略ID"
    ,zffs_id_list             string                comment "支付方式ID列表"
    ,ad_source                varchar(30)           comment "广告来源"
    ,appCoreVer               varchar(255)          comment "海阅新core值"
    ,dollar_app_id            varchar(255)          comment "海剧海阅共用，可转换为core值"
)
primary key(dt, id)
comment "event=element_expose 控件曝光事件"
partition by range(dt)
(partition p20251201 values than ("2025-12-02"))
distributed by hash(dt, id) buckets 3
properties (
    "replication_num" = "2"
   ,"dynamic_partition.enable" = "true"
   ,"dynamic_partition.time_unit" = "DAY"
   ,"dynamic_partition.time_zone" = "Asia/Shanghai"
   ,"dynamic_partition.start" = "-30"
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