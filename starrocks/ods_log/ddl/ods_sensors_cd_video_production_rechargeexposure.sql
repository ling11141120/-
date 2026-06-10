----------------------------------------------------------------
-- 目标表：ods_log.ods_sensors_cd_video_production_rechargeexposure
-- 来源实例：神策埋点
-- 来源表：event=rechargeExposure
-- 来源负责人：无
-- 开发人：qhr
-- 开发日期：2026-06-08
----------------------------------------------------------------

create table if not exists ods_log.ods_sensors_cd_video_production_rechargeexposure (
     dt                    date             not null                  comment "分区日期"
    ,id                    string           not null                  comment "nvl(rid,track_id)"
    ,track_id              string                                     comment ""
    ,rid                   string                                     comment "记录ID"
    ,event_tm              datetime                                   comment "事件时间"
    ,device_id             string                                     comment "设备id"
    ,login_id              string                                     comment "login_id"
    ,identity_login_id     string                                     comment "identity_login_id"
    ,device_lang           string                                     comment "设备语言"
    ,event                 string                                     comment "事件"
    ,distinct_id           string                                     comment "distinct_id"
    ,identity_user_id      string                                     comment "identity_userid"
    ,app_product_id        string                                     comment "包体ID"
    ,send_id               string                                     comment "转化来源"
    ,app_core_ver          string                                     comment "core"
    ,app_channel           string                                     comment "渠道编号"
    ,app_product_x         string                                     comment "应用程序ID"
    ,app_lang_id           string                                     comment "界面语言"
    ,page_name             string                                     comment "页面名称"
    ,page_id               string                                     comment "页面ID"
    ,element_name          string                                     comment "控件名称"
    ,element_id            string                                     comment "控件ID"
    ,recharge_type         string                                     comment "充值类型"
    ,book_id               string                                     comment "小说ID"
    ,chapter_id            string                                     comment "章节id"
    ,recharge_amount       string                                     comment "充值货币金额"
    ,present_gift          string                                     comment "赠送货币金额"
    ,countdown             string                                     comment "倒计时标签时长"
    ,real_recharge         string                                     comment "支付金额"
    ,list_sort             string                                     comment "列表位置"
    ,is_available          string                                     comment "是否可用"
    ,event_strategy_id     string                                     comment "策略id"
    ,app_module            string                                     comment "模块"
    ,element_type          string                                     comment "控件类型"
    ,czlx                  string                                     comment "充值类型"
    ,subscription_days     string                                     comment "订阅天数"
    ,programme_id          string                                     comment "方案ID"
    ,cz_template_id        string                                     comment "充值模板ID"
    ,cz_template_name      string                                     comment "充值模板名称"
    ,task_current_progress string                                     comment "当前任务进度"
    ,task_max_progress     string                                     comment "任务最大进度"
    ,app_id                string                                     comment "app ID"
    ,app_version           string                                     comment "应用版本"
    ,product_id            string                                     comment "产品ID"
    ,os                    string                                     comment "操作系统"
    ,ip                    string                                     comment "IP"
    ,city                  string                                     comment "城市"
    ,province              string                                     comment "省份"
    ,country               string                                     comment "国家"
    ,lib                   string                                     comment "lib"
    ,lib_version           string                                     comment "5阅读 8 短剧"
    ,project_id            string                                     comment "5阅读 8 短剧"
    ,shortplay_id          string                                     comment "短剧id"
    ,episode_id            string                                     comment "剧集id"
    ,activity_link         varchar(1024)                              comment "活动链路"
    ,pay_link              varchar(1024)                              comment "支付链路"
    ,activity_id           string                                     comment "活动id"
    ,parent_group_id       varchar(1048576)                           comment "用户集合ID"
    ,etl_tm                datetime         default current_timestamp comment ""
    ,ad_group_id           string                                     comment "广告人群包ID"
    ,ad_strategy_id        string                                     comment "广告策略ID"
    ,main_strategy_id      string                                     comment "主策略ID"
    ,module_channel_id     string                                     comment "频道id"
    ,recharge_index        string                                     comment "档位位序"
    ,zffs_list             string                                     comment "支付方式列表"
    ,is_subscription       string                                     comment "是否续订"
    ,zffs_id_list          string                                     comment "支付方式ID列表"
    ,zffs_strategy_id      string                                     comment "支付方式策略ID"
    ,anonymous_id          string                                     comment "匿名id"
    ,mt                    int                                        comment "平台"
    ,subscribe_mode        string                                     comment "订阅模式"
    ,total_periods         int                                        comment "总期数"
)
primary key(dt, id)
comment "event=rechargeExposure 充值档位曝光事件"
partition by range(dt)
(partition p20260608 values less than ("2026-06-09"))
distributed by hash(id) buckets 3
properties (
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
