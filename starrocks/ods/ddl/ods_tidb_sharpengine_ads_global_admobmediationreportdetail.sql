----------------------------------------------------------------
-- 目标表：ods.ods_tidb_sharpengine_ads_global_admobmediationreportdetail
-- 来源实例：new_tidb_source
-- 来源表：sharpengine_ads_global.AdMobMediationReportDetail
-- 采集工具：SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-03-31
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_admobmediationreportdetail;
create table ods.ods_tidb_sharpengine_ads_global_admobmediationreportdetail (
     dt                         date           not null                     comment "数据日期"
    ,id                         bigint         not null                     comment "主键id"
    ,dimensionhash              varchar(96)    not null                     comment "4个维度字段(DATE|APP|AD_SOURCE_INSTANCE|MEDIATION_GROUP)的MD5哈希，用于upsert去重"
    ,date                       date                                        comment "日期"
    ,app                        varchar(765)                                comment "所属app"
    ,ad_source_instance         varchar(765)                                comment "广告来源实例唯一id"
    ,mediation_group            varchar(765)                                comment "中介组唯一id"
    ,ad_source_instance_name    varchar(765)                                comment "广告来源实例名称"
    ,mediation_group_name       varchar(765)                                comment "中介组名称"
    ,ad_requests                int                                         comment "请求的数量"
    ,clicks                     int                                         comment "用户点击广告的次数"
    ,estimated_earnings         bigint                                      comment "AdMob 发布商的估算收入 例如，6.50 美元将表示为 6500000"
    ,impressions                int                                         comment "向用户展示的广告总数"
    ,matched_requests           int                                         comment "响应请求而返回广告的次数"
    ,match_rate                 double                                      comment "匹配的广告请求与总广告请求的比率"
    ,observed_ecpm              bigint                                      comment "第三方广告网络的估计平均  eCPM 例如，$2.30 将表示为 2300000"
    ,impression_ctr             double                                      comment "点击次数与展示次数的比值"
    ,account                    varchar(765)                                comment "广告账户"
    ,createdtime                datetime                                    comment "创建时间"
    ,updatedtime                datetime                                    comment "更新时间"
    ,sr_createtime              datetime       default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime              datetime       default current_timestamp    comment "starrocks数据更新时间"
)
primary key (dt, id)
comment "AdMob报表for BI (author:742337)"
partition by date_trunc("month", dt)
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;