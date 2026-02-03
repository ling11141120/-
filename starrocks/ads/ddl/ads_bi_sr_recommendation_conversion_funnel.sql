drop table if exists ads.ads_bi_sr_recommendation_conversion_funnel;
create table ads.ads_bi_sr_recommendation_conversion_funnel (
     dt                        date           not null                     comment "日期"
    ,app_product_id            int(11)        not null                     comment "应用产品id"
    ,app_core_ver              varchar(10)    not null                     comment "应用核心版本"
    ,os                        varchar(50)    not null                     comment "操作系统"
    ,position_type             varchar(50)    not null                     comment "场景"
    ,programme_id              bigint(11)     not null                     comment "方案id"
    ,module_channel_id         bigint(11)     not null                     comment "频道id"
    ,list_id                   bigint(11)     not null                     comment "榜单id"
    ,activity_id               bigint(11)     not null                     comment "活动策略id"
    ,exposure_login_id         bigint(20)     not null                     comment "曝光用户id"
    ,product_name              varchar(255)                                comment "产品名称"
    ,scheme_name               varchar(255)                                comment "方案名称"
    ,module_channel_name       varchar(255)                                comment "频道名称"
    ,list_name                 varchar(255)                                comment "榜单名称"
    ,tactics_name              varchar(255)                                comment "策略名称"
    ,tactics_scheme_name       varchar(255)                                comment "策略/方案"
    ,exposure_cnt              bigint(20)                                  comment "曝光次数"
    ,click_login_id            bigint(20)                                  comment "点击用户id"
    ,click_cnt                 bigint(20)                                  comment "点击次数"
    ,reading_login_id          bigint(20)                                  comment "阅读用户id"
    ,reading_chapter_cnt       bigint(20)                                  comment "阅读章节数"
    ,unlockchapter_login_id    bigint(20)                                  comment "解锁用户id"
    ,unlock_chapter_num        bigint(20)                                  comment "解锁章节数"
    ,unlockchapter_consume     bigint(20)                                  comment "消耗金币数"
    ,etl_tm                    datetime       default current_timestamp    comment "etl清洗时间"
) 
primary key (dt, app_product_id, app_core_ver, os, position_type, programme_id, module_channel_id, list_id, activity_id, exposure_login_id)
comment "海阅推荐页转化漏斗"
partition by date_trunc("month", dt)
distributed by hash(dt, app_product_id, app_core_ver, exposure_login_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;