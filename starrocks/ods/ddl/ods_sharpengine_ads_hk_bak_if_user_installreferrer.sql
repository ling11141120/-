----------------------------------------------------------------
-- 目标表： ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_hk_bak.if_user_installreferrer
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-25
----------------------------------------------------------------

drop table if exists ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer;
create table ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer (
     Id                        bigint(20)   not null                  comment "id"
    ,dt                        date         not null                  comment "分区-instaldate"
    ,ProductId                 int(11)                                comment "产品id"
    ,UserId                    bigint(20)   default "-1"              comment "用户id"
    ,Source                    varchar(100)                           comment "媒体值（广告投放平台）"
    ,AdId                      varchar(250)                           comment "广告id"
    ,AdType                    int(11)                                comment "广告类型"
    ,InstallDate               datetime                               comment "激活安装时间"
    ,AdAccountId               varchar(255)                           comment "广告账户id"
    ,AdSetId                   varchar(255)                           comment "广告系列id"
    ,BookId                    varchar(50)                            comment "书籍id"
    ,Creative                  varchar(500)                           comment "广告创意"
    ,InstallOriginalRequest    string                                 comment "安装原始请求"
    ,Login                     varchar(255)                           comment "登录信息"
    ,UniqueCdReaderId          varchar(255)                           comment "设备信息"
    ,Country                   varchar(255)                           comment "国家"
    ,Mt                        int(11)                                comment "终端-下游使用mt逻辑：if(Mt is not null and Mt != 0, Mt, RawMt)"
    ,RawMt                     int(11)                                comment "原始终端-下游使用mt逻辑：if(Mt is not null and Mt != 0, Mt, RawMt)"
    ,Core                      int(11)                                comment "core"
    ,DataInsertDate            varchar(50)                            comment "插入时间"
    ,Networkname               varchar(255)                           comment "媒体值"
    ,Chl2                      varchar(128)                           comment "渠道值"
    ,CreateTime                datetime                               comment "新增时间"
    ,adgroup_name              varchar(500)                           comment "广告组名称"
    ,CurrentLanguage2          int(11)      not null                  comment "注册时语言"
    ,RemarketingTime           datetime                               comment "再营销时间"
    ,AdQualityStatus           int(11)      default "0"               comment "广告质量状态"
    ,InstallDateEst            date                                   comment "西五区激活安装时间"
    ,ReInstallDate             datetime                               comment "再安装时间"
    ,AnalysisServerStatus      int(11)      default "0"               comment "同步sharpengine_analysis_tidb数据服务处理状态 0=未处理|1=已处理"
    ,NextAttributeTime         datetime                               comment "下一次归因时间"
    ,NextAttributeAdId         varchar(255)                           comment "下一次广告归因id"
    ,NextAttributeSource       varchar(255)                           comment "下一次归因来源"
    ,PreAttributeTime          datetime                               comment "上一次归因来源时间"
    ,PreAttributeAdId          varchar(255)                           comment "上一次归因广告id"
    ,PreAttributeSource        varchar(255)                           comment "上一次归因来源"
    ,IsReInstall               int(11)      default "0"               comment "是否再安装"
    ,PreAttributeDataId        bigint(20)   default "0"               comment "上一次归因的Id"
    ,NextAttributeDataId       bigint(20)   default "0"               comment "下一次归因的Id"
    ,RawAdId                   varchar(250)                           comment "未处理广告ID"
    ,TraceId                   varchar(128)                           comment "s2s的追踪Id"
    ,PixelId                   varchar(128)                           comment "fb的像素Id"
    ,At                        int(11)      default "0"               comment "归因有效期"
    ,IsRemarketing             int(11)      default "0"               comment "是否再营销 0=非再营销|1=再营销"
    ,NextAttributeIsRemarketing int(11)                               comment "下一次归因是否再营销"
    ,PreAttributeIsRemarketing  int(11)                               comment "上一次归因是否再营销"
    ,RemarkTimeSendToAppServer int(11)      default "0"               comment "发送RemarketingTime到AppServer状态"
    ,CustomAudiences           varchar(128)                           comment "自定义受众"
    ,IsDelete                  tinyint(4)   default "0"               comment ""
    ,row_update_time           datetime                               comment ""
    ,c2rtime                   datetime                               comment ""
    ,abtestpageid              int(11)                                comment ""
    ,sr_createtime             datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime             datetime                               comment "starrocks数据更新时间"
)
primary key(Id, dt)
comment "广告用户安装记录表"
partition by range(dt)
(partition p202511 values less than ("2025-12-01"))
distributed by hash(Id, dt) buckets 1 
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "InstallDateEst, InstallDate",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;