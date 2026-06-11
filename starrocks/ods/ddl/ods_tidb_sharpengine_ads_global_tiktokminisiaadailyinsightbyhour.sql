----------------------------------------------------------------
-- 目标表：ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour
-- 来源实例：new_tidb_source
-- 来源表：sharpengine_ads_global.TiktokMinisIaaDailyInsightByHour
-- 来源负责人：
-- 开发人：xjc
-- 开发日期：2026-06-10
----------------------------------------------------------------

create table if not exists ods.ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour (
     dt              date          not null                     comment "分区日期，createtime"
    ,id              bigint        not null                     comment "主键"
    ,clientkey       varchar(768)  not null                     comment "tiktok oauth client_key"
    ,core            int           not null                     comment "core数值"
    ,corename        varchar(192)  not null                     comment "core展示名称"
    ,minisname       varchar(384)                               comment "小程序名称"
    ,productid       int           not null                     comment "产品id"
    ,date_start      varchar(150)  not null                     comment "小时开始时间"
    ,date_stop       varchar(150)  not null                     comment "小时结束时间"
    ,adsclick        decimal(18,4) not null                     comment "ads_click.value"
    ,adsclickrate    decimal(18,8) not null                     comment "ads_click_rate.value"
    ,adsexposure     decimal(18,4) not null                     comment "ads_exposure.value"
    ,adsrequest      decimal(18,4) not null                     comment "ads_request.value"
    ,ecpm            decimal(18,8) not null                     comment "ecpm.value"
    ,iaarevenue      decimal(18,8) not null                     comment "iaa_revenue.value"
    ,putdata         string                                     comment "原始响应json"
    ,createtime      datetime      not null                     comment "创建时间"
    ,updatetime      datetime      not null                     comment "更新时间"
    ,sr_createtime   datetime      default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime   datetime      default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, id)
comment "TikTok小程序/小游戏IAA小时数据,author(742337)"
partition by date_trunc("month", dt)
distributed by hash(dt, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;
