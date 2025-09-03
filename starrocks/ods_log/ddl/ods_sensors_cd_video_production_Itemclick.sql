DROP TABLE IF EXISTS ods_log.ods_sensors_cd_video_production_Itemclick;
CREATE TABLE ods_log.ods_sensors_cd_video_production_Itemclick (
     dt                  DATE         NOT NULL COMMENT "日期"
    ,id                  VARCHAR(65533) NOT NULL COMMENT "主键"
    ,rid                 VARCHAR(65533) COMMENT "记录ID"
    ,track_id            VARCHAR(65533) COMMENT "track_id"
    ,event               VARCHAR(65533) COMMENT "事件"
    ,event_tm            DATETIME COMMENT "事件时间"
    ,app_channel         VARCHAR(65533) COMMENT "渠道编号"
    ,app_id              VARCHAR(65533) COMMENT "app_id"
    ,app_lang_id         VARCHAR(65533) COMMENT "界面语言"
    ,device_lang         VARCHAR(65533) COMMENT "设备语言"
    ,login_id            VARCHAR(65533) COMMENT "用户ID"
    ,product_id          VARCHAR(65533) COMMENT "产品ID"
    ,app_version         VARCHAR(65533) COMMENT "应用版本"
    ,os                  VARCHAR(65533) COMMENT "操作系统"
    ,ip                  VARCHAR(65533) COMMENT "IP"
    ,city                VARCHAR(65533) COMMENT "城市"
    ,province            VARCHAR(65533) COMMENT "省份"
    ,country             VARCHAR(65533) COMMENT "国家"
    ,lib                 VARCHAR(65533) COMMENT ""
    ,device_id           VARCHAR(65533) COMMENT "设备id"
    ,identity_login_id   VARCHAR(65533) COMMENT "identity_login_id"
    ,distinct_id         VARCHAR(65533) COMMENT "distinct_id"
    ,identity_user_id    VARCHAR(65533) COMMENT "identity_userid"
    ,app_product_id      VARCHAR(65533) COMMENT "包体ID"
    ,send_id             VARCHAR(65533) COMMENT "转化来源"
    ,app_core_ver        VARCHAR(65533) COMMENT "core"
    ,app_product_x       VARCHAR(65533) COMMENT "应用程序ID"
    ,lib_version         VARCHAR(65533) COMMENT "lib_version"
    ,page_id             VARCHAR(65533) COMMENT "页面ID"
    ,book_id             VARCHAR(65533) COMMENT "小说ID"
    ,is_bookshelf        VARCHAR(65533) COMMENT "小说是否已在书架中"
    ,module_channel_id   VARCHAR(65533) COMMENT "频道id"
    ,parent_group_id     VARCHAR(65533) COMMENT "用户集合ID"
    ,current_book_id     VARCHAR(65533) COMMENT "当前书籍ID"
    ,ranking_type        VARCHAR(65533) COMMENT "排行榜类型"
    ,gender              VARCHAR(65533) COMMENT "性别"
    ,app_module          VARCHAR(65533) COMMENT "模块"
    ,period              VARCHAR(65533) COMMENT "时间周期"
    ,page_name           VARCHAR(65533) COMMENT "页面名称"
    ,element_id          VARCHAR(65533) COMMENT "控件ID：当页面有下钻控件时上报，目前榜单集合/浏览历史/我的追剧"
    ,element_name        VARCHAR(65533) COMMENT "控件名称：当页面有下钻控件时上报，目前榜单集合/浏览历史/我的追剧"
    ,shortplay_id        VARCHAR(65533) COMMENT "短剧ID：整部短剧的ID"
    ,is_shortplayshelf   VARCHAR(65533) COMMENT "短剧是否已在追剧中：若短剧已主动加入追剧页面记录为1-是，不在为0-否"
    ,element_type        VARCHAR(65533) COMMENT "控件类型：只有运营位为控件或特殊对象时记录，例如：普通弹窗、底部弹窗等"
    ,channel_id          VARCHAR(65533) COMMENT "频道id：在首页里不同频道分页id"
    ,channel_name        VARCHAR(65533) COMMENT "频道名称：在首页里不同频道分页名称：找剧 /发现"
    ,list_id             VARCHAR(65533) COMMENT "榜单id：从后台获取榜单id"
    ,list_style          VARCHAR(65533) COMMENT "榜单样式：从后台获取榜单id的“榜单样式”"
    ,list_name           VARCHAR(65533) COMMENT "榜单名称：热播短剧/主编力荐/人气排行等"
    ,list_index          VARCHAR(65533) COMMENT "榜单位序：用户看到的榜单信息中的位序"
    ,activity_id         VARCHAR(65533) COMMENT "活动id"
    ,event_strategy_id   VARCHAR(65533) COMMENT "策略id"
    ,group_id            VARCHAR(65533) COMMENT "用户分组id"
    ,keyword             VARCHAR(65533) COMMENT "搜索词：搜索结果页面上报"
    ,search_mode         VARCHAR(65533) COMMENT "搜索方式：{1：主动搜索，2：猜你想搜，3：历史搜索} 根据上次搜索方式上报，搜索结果页面上报"
    ,search_hit_type     VARCHAR(65533) COMMENT "搜索命中方式"
    ,project_id          VARCHAR(65533) COMMENT "5阅读 8 短剧"
    ,list_id1            VARCHAR(65533) COMMENT "list_id1"
    ,channel_id1         VARCHAR(65533) COMMENT "channel_id1"
    ,etl_tm              DATETIME COMMENT "清洗时间"
    ,activity_link       VARCHAR(65533) COMMENT ""
    ,book_list_id        VARCHAR(65533) COMMENT ""
    ,programme_id        VARCHAR(65533) COMMENT ""
    ,list_class          VARCHAR(65533) COMMENT "角标类型"
    ,label_type          VARCHAR(65533) COMMENT "角标类型"
) 
ENGINE=OLAP 
PRIMARY KEY(dt, id)
COMMENT "event=itemclick 短剧点击"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
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