drop table if exists ads.ads_ad_user_adshow_h;
create table ads.ads_ad_user_adshow_h (
     dt                datetime      not null comment "事件时间"
    ,product_id        int           not null comment "产品id"
    ,user_id           int                    comment "用户id"
    ,core              int                    comment "core"
    ,mt                int                    comment "终端"
    ,current_language2 varchar(255)           comment "投放语言"
    ,appver            varchar(255)           comment "版本号"
    ,ad_show_type      int                    comment "广告类型"
    ,ad_show_type_name varchar(40)            comment "广告类型名称"
    ,positions         int                    comment "广告位置"
    ,ads_name          varchar(255)           comment "广告来源"
    ,ads_source        varchar(655)           comment "admob广告源"
    ,main_strategy_id  string                 comment "主策略id"
    ,event_strategy_id string                 comment "策略id"
    ,programme_id      varchar(1000)          comment "频道方案ID"
    ,cnt               int                    comment "次数"
    ,etl_tm            datetime               comment "清洗时间"
)
duplicate key(dt, product_id)
comment "广告域-用户广告展示-分时表"
partition by date_trunc('day', dt)
distributed by hash(dt, product_id, user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;