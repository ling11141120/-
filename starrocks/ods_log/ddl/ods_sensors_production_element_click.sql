----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_production_element_click
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具：极光-实时映射
-- 开发人：xjc
-- 开发日期：2025-11-13
----------------------------------------------------------------

drop table if exists ods_log.ods_sensors_production_element_click;
create table ods_log.ods_sensors_production_element_click (
     dt                       date              not null    comment "分区日期"
    ,id                       varchar(65533)    not null    comment "nvl(rid,track_id)"
    ,track_id                 varchar(65533)                comment ""
    ,rid                      varchar(65533)                comment "记录id"
    ,event_tm                 datetime                      comment "事件时间"
    ,device_id                varchar(65533)                comment "设备id"
    ,login_id                 varchar(65533)                comment "login_id"
    ,identity_login_id        varchar(65533)                comment "identity_login_id"
    ,device_lang              varchar(65533)                comment "设备语言"
    ,event                    varchar(65533)                comment "事件"
    ,distinct_id              varchar(65533)                comment "distinct_id"
    ,identity_user_id         varchar(65533)                comment "identity_userid"
    ,app_product_id           varchar(65533)                comment "包体id"
    ,send_id                  varchar(65533)                comment "转化来源"
    ,app_core_ver             varchar(65533)                comment "core"
    ,lib                      varchar(65533)                comment "平台"
    ,app_version              varchar(65533)                comment "app版本号"
    ,app_channel              varchar(65533)                comment "渠道编号"
    ,app_product_x            varchar(65533)                comment "应用程序id"
    ,app_lang_id              varchar(65533)                comment "界面语言"
    ,page_name                varchar(65533)                comment "页面名称"
    ,page_id                  varchar(65533)                comment "页面id"
    ,element_name             varchar(65533)                comment "控件名称"
    ,element_id               varchar(65533)                comment "控件id"
    ,payment_method           varchar(65533)                comment "支付方式"
    ,type                     varchar(65533)                comment "类型"
    ,element_content          varchar(65533)                comment "点击元素内容"
    ,activity_id              varchar(65533)                comment "活动id"
    ,parent_group_id          varchar(65533)                comment "用户集合id"
    ,group_id                 varchar(65533)                comment "用户分组id"
    ,etl_tm                   datetime                      comment "清洗时间"
    ,ad_position_id           int(11)                       comment "广告位置id"
    ,activity_link            varchar(1024)                 comment "活动链路"
    ,pay_link                 varchar(1024)                 comment "支付链路"
    ,os                       varchar(1024)                 comment "操作系统"
    ,ad_group_id              varchar(65533)                comment "广告人群包id"
    ,ad_strategy_id           varchar(65533)                comment "广告策略id"
    ,read_source_page_name    varchar(500)                  comment ""
    ,module_channel_id        varchar(65533)                comment "频道id"
    ,programme_id             varchar(65533)                comment "方案id"
    ,event_strategy_id        varchar(65533)                comment "策略id"
    ,main_strategy_id         varchar(65533)                comment "主策略id"
    ,book_category_id_list    varchar(65533)                comment "书籍分类id列表"
    ,book_category_id         varchar(65533)                comment "书籍分类id"
    ,zffs_strategy_id         varchar(65533)                comment "支付方式策略id"
    ,zffs_id_list             varchar(65533)                comment "支付方式id列表"
    ,add_source               varchar(255)                  comment "广告来源"
    ,appCoreVer               varchar(255)                  comment "海阅新core值"
    ,dollar_app_id            varchar(255)                  comment "海剧海阅共用，可转换为core值"
    ,app_id                   varchar(255)                  comment "海剧app_id值"
    ,appId                    varchar(255)                  comment "海阅app_id值"
)
primary key (dt, id)
comment "event=element_click 控件点击时上报"
partition by range (dt)()
distributed by hash (dt, id) buckets 3
properties (
     "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-92"
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