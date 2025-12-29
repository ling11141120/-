----------------------------------------------------------------
-- 目标表：ods.ods_tidb_readernovel_tidb_xx_beesadsdata
-- 来源实例：old_tidb_source
-- 来源表：readernovel_tidb_ft.beesadsdata
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人： xjc
-- 开发日期： 2025-12-22
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_beesadsdata;
create table ods.ods_tidb_readernovel_tidb_xx_beesadsdata (
     dt                 date        not null                     comment "分区日期"
    ,id                 bigint      not null                     comment "自增Id"
    ,date               datetime                                 comment "日期"
    ,channelname        varchar(765)                             comment "ChannelName"
    ,clicks             bigint                                   comment "点击数"
    ,cpc                double                                   comment "GrossRevenue/Clicks"
    ,ctr                double                                   comment "Clicks/Impressions"
    ,domain             varchar(765)                             comment "域名"
    ,ecpm               double                                   comment "ecpm"
    ,grossrevenue       double                                   comment "总收益"
    ,impressionrate     double                                   comment "展示率Impressions/TotalAdRequests"
    ,impressions        bigint                                   comment "展示数"
    ,netrevenue         double                                   comment "收益"
    ,responserate       double                                   comment "响应率TotalAdResponse/TotalAdRequests"
    ,timezone           varchar(50)                              comment "时区"
    ,totaladrequests    bigint                                   comment "请求数"
    ,projecttype        int                                      comment "项目类型 0:未知 1:阅读 2:短剧"
    ,createtime         datetime                                 comment "创建时间"
    ,sr_createtime      datetime    default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime      datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key (dt,id)
comment "beesads h5广告数据 author:350625"
partition by date_trunc("year", dt)
distributed by hash(dt)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;