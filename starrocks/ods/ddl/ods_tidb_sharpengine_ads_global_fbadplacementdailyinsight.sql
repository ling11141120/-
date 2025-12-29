----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_fbadplacementdailyinsight
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.FbAdPlacementDailyInsight
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2025-12-22
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_fbadplacementdailyinsight;
create table ods.ods_tidb_sharpengine_ads_global_fbadplacementdailyinsight (
    dt                     date             not null                     comment "数据日期"
   ,id                     bigint           not null                     comment "主键"
   ,adid                   varchar(150)     not null                     comment "广告ID"
   ,adstatus               varchar(150)     not null                     comment "广告状态"
   ,fbaccountid            varchar(384)     not null                     comment "Facebook账号ID"
   ,publisherplatform      varchar(384)     not null                     comment "发布平台,如 Facebook Instagram Audience Network 等"
   ,platformposition       varchar(384)     not null                     comment "平台版位,如 feed stories right_column 等"
   ,date_start             varchar(150)     not null                     comment "数据开始日期,格式：YYYY-MM-DD"
   ,date_stop              varchar(150)     not null                     comment "数据结束日期,格式：YYYY-MM-DD"
   ,adname                 varchar(1500)                                 comment "广告名称"
   ,spend                  decimal(10,2)    not null                     comment "花费金额,USD"
   ,putdata                string                                        comment "原始上报数据,JSON格式"
   ,installs               int              not null                     comment "安装次数,应用安装事件"
   ,clicks                 int              not null                     comment "总点击次数"
   ,impressions            int              not null                     comment "展示次数"
   ,cpc                    varchar(150)                                  comment "每次点击成本"
   ,cpm                    varchar(150)                                  comment "每千次展示成本"
   ,cpp                    varchar(150)                                  comment "每次转化成本"
   ,ctr                    varchar(150)                                  comment "点击率"
   ,updatetime             datetime         not null                     comment "数据更新时间,含毫秒"
   ,mt                     int              not null                     comment "媒体类型标识"
   ,productid              varchar(150)                                  comment "产品ID"
   ,roas                   decimal(10,2)    not null                     comment "广告支出回报率"
   ,adsetid                varchar(384)                                  comment "广告组ID"
   ,adcampid               varchar(384)                                  comment "广告系列ID"
   ,amount                 decimal(10,2)    not null                     comment "归因转化金额,本地归因"
   ,fbamount               decimal(10,2)    not null                     comment "Facebook归因转化金额"
   ,videoviewcount         int              not null                     comment "视频播放次数.至少播放一次"
   ,video10sviewcount      int              not null                     comment "视频10秒以上播放次数"
   ,videoavgwatchedtime    int              not null                     comment "视频平均观看时长,秒"
   ,installs2              int              not null                     comment "备用安装指标,可能来自不同归因模型"
   ,imageid                int              not null                     comment "广告素材图片ID"
   ,linkclick              int              not null                     comment "链接点击次数,落地页点击"
   ,conversion             int              not null                     comment "转化次数,通用转化事件"
   ,registration           int              not null                     comment "去重注册数"
   ,apppurchase            int                                           comment "应用内付费次数,由应用事件上报"
   ,apppurchasevalue       decimal(10,2)                                 comment "应用内付费总价值,USD"
   ,pixelpurchase          int                                           comment "通过Facebook Pixel回传的付费次数"
   ,pixelpurchasevalue     decimal(10,2)                                 comment "通过Pixel回传的付费总价值,USD"
   ,sr_createtime          datetime         default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime          datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt,id)
comment "fb版位日成效 author:742337"
partition by date_trunc("month", dt)
distributed by hash(dt)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;