----------------------------------------------------------------
-- 目标表： ods_tidb_sharpengine_ads_global_TiktokAdsAccount
-- 来源实例：new_tidb_source
-- 来源表：  sharpengine_ads_global.TiktokAdsAccount
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2026-02-09
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_TiktokAdsAccount;
create table ods.ods_tidb_sharpengine_ads_global_TiktokAdsAccount (
     Id                             int           not null                           comment "主键id"
    ,Account                        varchar(128)                                     comment "Tiktok投放账户ID"
    ,Secret                         varchar(128)                                     comment "Tiktok API Secret"
    ,PageId                         varchar(128)                                     comment "页面"
    ,AppId                          varchar(128)                                     comment ""
    ,AppUrl                         varchar(500)                                     comment "Facebook AppUrl"
    ,CreateTime                     datetime                                         comment "创建时间"
    ,ProductId                      int                                              comment "产品id"
    ,ProductName                    varchar(128)                                     comment "产品 账号名"
    ,Mt                             int                                              comment "设备"
    ,Token                          varchar(500)                                     comment "Tiktok API Token"
    ,InsId                          varchar(500)                                     comment "Tiktok InsId"
    ,Status                         int                                              comment "0-禁用 1-启用"
    ,AutoFillAd                     int                                              comment "自动填充 0 否 1 是"
    ,UpdateStatus                   int                                              comment "更新状态"
    ,Chl                            varchar(128)                                     comment "渠道"
    ,Core                           int                                              comment "core"
    ,FbAdRuleId                     int                                              comment "自动关闭规则Id"
    ,AdAutoActive                   int                                              comment ""
    ,StatusChangeTime               datetime                                         comment "状态更新时间"
    ,FbAccountType                  int                                              comment "1表示再营销 0正常新增投放"
    ,RowVersion                     bigint                                           comment "同步数据用的"
    ,SpendCap                       bigint                                           comment "额度金额"
    ,AmountSpent                    bigint                                           comment "已经花费的金额"
    ,PutProductId                   int                                              comment "投放语言ID"
    ,CurrentLanguage2               int                                              comment "投放语言"
    ,AccountAdType                  int                                              comment "账号广告类型"
    ,ExchangeRate                   double                                           comment "汇率"
    ,AccountChangeToRemarketingTime datetime                                         comment "设置为再营销账户的时间"
    ,LastInsightInfo                varchar(2000)                                    comment "最后一次抓取dailyinsight的信息"
    ,TimeZoneOffset                 int                                              comment ""
    ,AccountTz                      int           not null default "-13"             comment "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区"
    ,sr_createtime                  datetime               default current_timestamp comment ""
    ,sr_updatetime                  datetime                                         comment ""
    ,InstId                         bigint                 default '0'               comment '机构ID'
)
primary key(Id)
comment "Tiktok投放账号表"
distributed by hash(Id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;