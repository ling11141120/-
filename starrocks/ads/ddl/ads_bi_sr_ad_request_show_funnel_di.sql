create table if not exists ads.ads_bi_sr_ad_request_show_funnel_di (
     dt                    date           not null                  comment "日期"
    ,core                  varchar(10)    not null                  comment "CORE版本"
    ,mt                    varchar(50)    not null                  comment "终端"
    ,ad_id                 varchar(255)   not null                  comment "广告ID"
    ,app_version           varchar(64)    not null                  comment "APP版本"
    ,ad_show_type_name     varchar(255)   not null                  comment "广告类型"
    ,ad_position_name      varchar(255)   not null                  comment "广告位置"
    ,put_language          varchar(255)   not null                  comment "投放语言"
    ,reg_country           varchar(255)   not null                  comment "注册国家"
    ,ad_request_pv         bigint                                   comment "广告请求PV"
    ,ad_request_success_pv bigint                                   comment "广告请求成功PV"
    ,ad_invocation_pv      bigint                                   comment "广告调用PV"
    ,ad_show_success_pv    bigint                                   comment "广告展现成功PV"
    ,total_show_duration   decimal(20, 3)                           comment "累计展现耗时"
    ,ad_show_fail_pv       bigint                                   comment "广告展现失败PV"
    ,etl_time              datetime       default current_timestamp comment "数据清洗时间"
)
unique key(dt, core, mt, ad_id, app_version, ad_show_type_name, ad_position_name, put_language, reg_country)
comment "海阅-广告触达到播放转化bi底表"
partition by date_trunc("day", dt)
distributed by hash(dt, ad_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
