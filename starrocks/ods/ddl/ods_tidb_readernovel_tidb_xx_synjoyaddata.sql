----------------------------------------------------------------
-- 目标表：ods.ods_tidb_readernovel_tidb_xx_synjoyaddata
-- 来源实例：old_tidb_source
-- 来源表：readernovel_tidb_ft.synjoyaddata
-- 采集工具：极光-定时批量
-- 开发人： xjc
-- 开发日期： 2025-11-05
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_xx_synjoyaddata;
create table ods.ods_tidb_readernovel_tidb_xx_synjoyaddata (
     product_id         int              not null                     comment "产品id"
    ,Id                 bigint           not null                     comment "id"
    ,Dt                 date             not null                     comment "日期"
    ,Site               varchar(765)                                  comment "站点标识"
    ,Revenue            decimal(18,6)                                 comment "收益,单位:usd"
    ,Requests           bigint                                        comment "广告请求数"
    ,MatchedRequests    bigint                                        comment "匹配的广告请求数"
    ,Impressions        bigint                                        comment "展示次数"
    ,Clicks             bigint                                        comment "点击次数"
    ,AdsensePv          bigint                                        comment "adsense页面浏览量,仅adsense链接存在"
    ,ProjectType        int                                           comment "项目类型 0:未知 1:阅读 2:短剧"
    ,CreateTime         datetime         default current_timestamp    comment "创建时间"
    ,sr_createtime      datetime         default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime      datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key (product_id,id, dt)
comment "synjoy h5广告数据 author:062958"
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