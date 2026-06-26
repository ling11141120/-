----------------------------------------------------------------
-- 目标表：ods_tidb_sharpengine_ads_global_tiktokminisadltv
-- 来源实例：idc-adstidb-查询
-- 来源表：sharpengine_ads_global.TiktokMinisAdLtv
-- 来源负责人：何妨
-- 开发人：qhr
-- 开发日期：2026-06-26
----------------------------------------------------------------

create table if not exists ods.ods_tidb_sharpengine_ads_global_tiktokminisadltv (
     Dt                                    date           not null             comment "日期"
    ,Id                                    bigint         not null             comment "主键ID"
    ,AdId                                  varchar(500)                        comment "广告ID"
    ,AdName                                varchar(2000)                       comment "广告名称"
    ,ProjectCode                           int            default "0"          comment "项目类型1=海阅|2=海剧|6=圣经"
    ,ProductId                             int            default "0"          comment "ProductId"
    ,FbAccount                             varchar(500)   not null             comment "广告账号ID"
    ,Spend                                 decimal(10, 4) default "0"          comment "花费"
    ,Roas                                  decimal(10, 4) default "0"          comment "Roas"
    ,Amount                                decimal(10, 4) default "0"          comment "收入"
    ,D0Roas                                decimal(10, 4) default "0"          comment "D0Roas"
    ,D0Amount                              decimal(10, 4) default "0"          comment "D0收入"
    ,Clicks                                int            not null default "0" comment "点击数"
    ,Impressions                           int            not null default "0" comment "展示数"
    ,TotalAddToCart                        int            not null default "0" comment "加入购物车事件数"
    ,TotalCheckoutInitiation               int            not null default "0" comment "结账数"
    ,TotalPurchase                         int            not null default "0" comment "付费数"
    ,UniqueAddToCart                       int            not null default "0" comment "去重加入购物车事件数"
    ,UniqueCheckoutInitiation              int            not null default "0" comment "去重结账数"
    ,UniquePurchase                        int            not null default "0" comment "去重付费数"
    ,UniqueLaunch                          int            not null default "0" comment "去重打开次数/激活数"
    ,SourceChl                             varchar(500)                        comment "媒体"
    ,CreateTime                            datetime       not null             comment "创建时间"
    ,UpdateTime                            datetime       not null             comment "更新时间"
    ,AdImpressionAdRevenueRoasCalendarDay0 decimal(10, 4) not null default "0" comment "第0个日历日广告收入"
    ,AdImpressionAdRevenueRoasDay0         decimal(10, 4) not null default "0" comment "第0天付费ROAS(广告曝光口径)"
    ,AdImpressionAdRevenueRoas             decimal(10, 4) not null default "0" comment "广告收入ROAS(TikTok)"
    ,UniqueAdImpression                    int            not null default "0" comment "去重广告曝光事件数"
    ,TotalPurchaseRoasCalendarDay0         decimal(10, 4) not null default "0" comment "第0天付费ROAS(日历日口径)"
    ,TotalAdImpression                     int            not null default "0" comment "广告曝光事件总数"
    ,UniqueFirstLaunch                     int            not null default "0" comment "去重打首次开次数/激活数"
)
primary key(Dt, Id)
comment "Tiktok小程序广告LTV表"
partition by date_trunc("day", dt)
distributed by hash(Dt, Id)
properties (
    "bloom_filter_columns" = "ProjectCode",
    "compression" = "LZ4",
    "enable_persistent_index" = "true",
    "fast_schema_evolution" = "true",
    "replicated_storage" = "true",
    "replication_num" = "3"
)
;