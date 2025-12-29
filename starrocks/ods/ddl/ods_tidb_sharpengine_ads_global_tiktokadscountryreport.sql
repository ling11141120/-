----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_tiktokadscountryreport
-- 来源实例： old_tidb_source
-- 来源表： sharpengine_ads_global.tiktokadscountryreport
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2025-12-10
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_tiktokadscountryreport;
create table ods.ods_tidb_sharpengine_ads_global_tiktokadscountryreport (
     dt                      date        not null                     comment '日期'
    ,id                      bigint      not null                     comment 'Id'
    ,fbaccount               bigint                                   comment 'fb账号'
    ,campaign_id             bigint                                   comment '广告活动ID'
    ,adgroup_id              bigint                                   comment '广告组ID'
    ,ad_id                   bigint                                   comment '广告ID'
    ,stat_time_day           varchar(765)                             comment '统计日期'
    ,stat_time_hour          varchar(765)                             comment '统计小时'
    ,ac                      varchar(765)                             comment '网络连接类型'
    ,age                     varchar(765)                             comment '年龄'
    ,country_code            varchar(765)                             comment '国家编码'
    ,interest_category       varchar(765)                             comment '兴趣分类'
    ,interest_category_v2    varchar(765)                             comment '兴趣分类v2'
    ,gender                  varchar(765)                             comment '性别'
    ,language                varchar(765)                             comment '语言'
    ,placement               varchar(765)                             comment '位置'
    ,platform                varchar(765)                             comment '平台'
    ,campaign_name           varchar(765)                             comment '活动名称'
    ,spend                   varchar(765)                             comment 'total spend'
    ,impressions             varchar(765)                             comment '展示数'
    ,reach                   varchar(765)                             comment '覆盖人数'
    ,createdate              datetime                                 comment '创建时间'
    ,statdate                datetime                                 comment '统计日期'
    ,clicks                  varchar(765)                             comment '点击数'
    ,conversion              varchar(765)                             comment '转换数'
    ,registration            varchar(765)                             comment '去重注册数'
    ,sr_createtime           datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime           datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(dt, id)
comment "tiktok广告报告"
partition by date_trunc("year", dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;