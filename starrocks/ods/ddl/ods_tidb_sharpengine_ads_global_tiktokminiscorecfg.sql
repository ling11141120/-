----------------------------------------------------------------
-- 目标表：ods_tidb_sharpengine_ads_global_tiktokminiscorecfg
-- 来源实例：new_tidb_source
-- 来源表：sharpengine_ads_global.TiktokMinisCoreCfg
-- 来源负责人：102094
-- 开发人：xjc
-- 开发日期：2026-06-11
----------------------------------------------------------------

create table ods.ods_tidb_sharpengine_ads_global_tiktokminiscorecfg (
     id                      bigint        not null                          comment "主键"
    ,core                    int           not null                          comment "core数值"
    ,corename                varchar(192)  not null                          comment "core展示名称"
    ,minisname               varchar(384)                                    comment "小程序名称"
    ,account                 varchar(300)                                    comment "TikTok开发者账号标识，对应CommonAdTokenInfo.Name"
    ,sort                    int           not null                          comment "排序值"
    ,disabled                tinyint       not null                          comment "是否禁用：0=启用，1=禁用"
    ,requireschargeplan      tinyint       not null                          comment "是否需要价值面板：0=不需要，1=需要"
    ,accesstokenclientkey    varchar(768)  not null                          comment "TikTok OAuth client_key"
    ,accesstokenclientsecret varchar(3072) not null                          comment "TikTok OAuth client_secret，建议加密存储"
    ,metricprofile           tinyint       not null                          comment "行为口径：1=按现有Core16付费口径，2=按现有Core18广告曝光口径，3=按现有Core19 TT端原生口径"
    ,roistdcfgprojects       varchar(384)  not null                          comment "ROI标准配置适用项目，逗号分隔"
    ,remark                  varchar(1536) not null                          comment "备注"
    ,createuser              varchar(384)  not null                          comment "创建人"
    ,createtime              datetime      not null                          comment "创建时间"
    ,updateuser              varchar(384)  not null                          comment "更新人"
    ,updatetime              datetime      not null                          comment "更新时间"
    ,sr_createtime           datetime      default current_timestamp         comment "starrocks数据注入时间"
    ,sr_updatetime           datetime      default current_timestamp         comment "starrocks数据更新时间"
)
primary key(id)
comment "TT小程序Core配置表,author(102094)"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;
