----------------------------------------------------------------
-- 目标表： ods_log.ods_sensors_production_ordersuccess
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 极光-实时映射
-- 开发人： wx
-- 开发日期： 2025-10-31
----------------------------------------------------------------
drop table if exists ods_log.ods_sensors_production_ordersuccess;
create table ods_log.ods_sensors_production_ordersuccess (
     dt                    date      not null comment "分区日期"
    ,id                    string    not null comment "nvl(rid,track_id)"
    ,track_id              string             comment ""
    ,rid                   string             comment "记录ID"
    ,event_tm              datetime           comment "事件时间"
    ,device_id             string             comment "设备id"
    ,login_id              string             comment "login_id"
    ,identity_login_id     string             comment "identity_login_id"
    ,event                 string             comment "事件"
    ,app_core_ver          string             comment "core"
    ,distinct_id           string             comment "distinct_id"
    ,app_product_id        string             comment "包体ID"
    ,lib_version           string             comment "lib_version"
    ,app_version           string             comment "app_version"
    ,os                    varchar(200)       comment "操作系统"
    ,app_id                string             comment "app_id"
    ,recharge_amount       double             comment "充值货币金额"
    ,current_coin          double             comment "当前账户付费货币余额"
    ,goods_id              double             comment "商品id"
    ,real_recharge         double             comment "充值金额"
    ,app_module            string             comment "模块"
    ,goods_name            string             comment "商品名称"
    ,pay_source            string             comment "充值信息"
    ,group_id              string             comment "用户分组ID"
    ,task_current_progress double             comment "任务当前进度"
    ,activity_id           string             comment "活动id"
    ,parent_group_id       string             comment "用户集合ID"
    ,present_gift          double             comment "赠送货币金额"
    ,recharge_type         string             comment "充值类型"
    ,event_strategy_id     double             comment "策略id"
    ,payment_method        string             comment "支付方式"
    ,subscription_days     double             comment "订阅天数"
    ,task_max_progress     double             comment "任务最大进度"
    ,current_gift          double             comment "当前账户免费货币余额"
    ,identity_userid       string             comment "事件表用户账号ID"
    ,programme_id          double             comment "方案ID"
    ,goods_type            double             comment "商品类型"
    ,cz_template_id        string             comment "充值模板id"
    ,zffs                  string             comment "支付方式"
    ,sfzf_strategy_id      string             comment "三方支付策略id"
    ,cz_template_name      string             comment "充值模板名称"
    ,czlx                  string             comment "充值类型8544988851058442240"
    ,discount_rate         double             comment "折扣率"
    ,activity_link         string             comment "活动链路"
    ,sub_recharge_type     string             comment "子充值类型"
    ,pay_link              string             comment "支付链路"
    ,ad_group_id           string             comment "广告人群包ID"
    ,ad_strategy_id        string             comment "广告策略ID"
    ,main_strategy_id      double             comment "主策略ID"
    ,is_subscription       double             comment "是否续订"
    ,zffs_strategy_id      string             comment "支付策略id"
    ,zffs_id               string             comment "支付id"
    ,etl_tm                datetime           comment "清洗时间"
)
PRIMARY KEY(dt, id)
COMMENT "event=orderSuccess 充值成功事件"
PARTITION BY RANGE(dt)
(PARTITION p20251031 VALUES LESS THAN ("2025-10-31"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "DAY"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-365"
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