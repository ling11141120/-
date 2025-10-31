----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_cd_video_production_ordersuccess
-- 来源实例：
-- 来源表：
-- 来源负责：
-- 采集工具： 极光-实时映射
-- 开发人： wx
-- 开发日期： 2025-10-31
----------------------------------------------------------------
drop table if exists ods_log.ods_sensors_cd_video_production_ordersuccess;
create table ods_log.ods_sensors_cd_video_production_ordersuccess (
     dt                   date              NOT NULL COMMENT "日期"
    ,id                   varchar(65533)    NOT NULL COMMENT "主键"
    ,rid                  varchar(65533)             COMMENT "记录ID"
    ,track_id             varchar(65533)             COMMENT "track_id"
    ,event                varchar(65533)             COMMENT "事件"
    ,event_tm             datetime                   COMMENT "事件时间"
    ,app_channel          varchar(65533)             COMMENT "渠道编号"
    ,app_id               varchar(65533)             COMMENT "app_id"
    ,app_lang_id          varchar(65533)             COMMENT "界面语言"
    ,device_lang          varchar(65533)             COMMENT "设备语言"
    ,login_id             varchar(65533)             COMMENT "用户ID"
    ,product_id           varchar(65533)             COMMENT "产品ID"
    ,app_version          varchar(65533)             COMMENT "应用版本"
    ,os                   varchar(65533)             COMMENT "操作系统"
    ,ip                   varchar(65533)             COMMENT "IP"
    ,city                 varchar(65533)             COMMENT "城市"
    ,province             varchar(65533)             COMMENT "省份"
    ,country              varchar(65533)             COMMENT "国家"
    ,lib                  varchar(65533)             COMMENT "lib"
    ,device_id            varchar(65533)             COMMENT "设备id"
    ,identity_login_id    varchar(65533)             COMMENT "identity_login_id"
    ,distinct_id          varchar(65533)             COMMENT "distinct_id"
    ,identity_user_id     varchar(65533)             COMMENT "identity_userid"
    ,app_product_id       varchar(65533)             COMMENT "包体ID"
    ,send_id              varchar(65533)             COMMENT "转化来源"
    ,app_core_ver         varchar(65533)             COMMENT "core"
    ,app_product_x        varchar(65533)             COMMENT "应用程序ID"
    ,pay_source           varchar(65533)             COMMENT "充值信息"
    ,parent_group_id      varchar(65533)             COMMENT "用户集合ID"
    ,group_id             varchar(65533)             COMMENT "用户分组ID"
    ,app_module           varchar(65533)             COMMENT "模块"
    ,lib_version          varchar(65533)             COMMENT "5阅读 8 短剧"
    ,recharge_amount      varchar(65533)             COMMENT "充值货币金额"
    ,present_gift         varchar(65533)             COMMENT "赠送货币金额"
    ,real_recharge        varchar(65533)             COMMENT "支付金额"
    ,payment_method       varchar(65533)             COMMENT "支付方式"
    ,recharge_type        varchar(65533)             COMMENT "充值类型"
    ,subscription_days    varchar(65533)             COMMENT "订阅天数"
    ,current_coin         varchar(65533)             COMMENT "当前账户付费货币余额"
    ,current_gift         varchar(65533)             COMMENT "当前账户免费货币余额"
    ,activity_id          varchar(65533)             COMMENT "活动id"
    ,event_strategy_id    varchar(65533)             COMMENT "策略id"
    ,project_id           varchar(65533)             COMMENT "5阅读 8 短剧"
    ,etl_tm               datetime                   COMMENT "清洗时间"
    ,zffs                 varchar(65533)             COMMENT "支付方式"
    ,czlx                 varchar(65533)             COMMENT "充值类型"
    ,cz_template_id       varchar(65533)             COMMENT "充值模板ID"
    ,cz_template_name     varchar(65533)             COMMENT "充值模板名称"
    ,activity_link        varchar(1024)              COMMENT "活动链路"
    ,pay_link             varchar(1024)              COMMENT "支付链路"
    ,programme_id         varchar(65533)             COMMENT "方案ID"
    ,ad_group_id          varchar(65533)             COMMENT "广告人群包ID"
    ,ad_strategy_id       varchar(65533)             COMMENT "广告策略ID"
    ,main_strategy_id     varchar(65533)             COMMENT "主策略ID"
    ,is_subscription      varchar(65533)             COMMENT "是否续订"
    ,zffs_strategy_id     varchar(65533)             COMMENT "支付方式策略ID"
    ,pre_zffs             varchar(65533)             COMMENT "原支付方式"
    ,zffs_id              varchar(65533)             COMMENT "支付方式ID"
)
PRIMARY KEY(dt, id)
COMMENT "event=ordersuccess 充值成功事件"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-365",
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