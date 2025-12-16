----------------------------------------------------------------
-- 目标表： ods.ods_tidb_mobkingaddata
-- 来源实例： old_tidb_source
-- 来源表： readernovel_tidb_ft.mobkingaddata
-- 来源负责：
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-12-15
----------------------------------------------------------------

drop table if exists ods.ods_tidb_mobkingaddata;
create table ods.ods_tidb_mobkingaddata (
     Id            bigint         not null                  comment ""
    ,Date          date                                     comment "日期"
    ,Appid         varchar(1000)                            comment "站点ID"
    ,Cpm           decimal(18, 6)                           comment "广告千次展现单价"
    ,FillRate      decimal(18, 6)                           comment "填充率"
    ,SubRevenue    decimal(18, 6)                           comment "流水(分成前)"
    ,SubNetRevenue decimal(18, 6)                           comment "收入(分成后)"
    ,AdReq         bigint                                   comment "请求数"
    ,AdRes         bigint                                   comment "填充数"
    ,Imp           bigint                                   comment "    展示数"
    ,Click         bigint                                   comment "点击数"
    ,CreateTime    datetime                                 comment "创建时间"
    ,ProjectType   bigint                                   comment "项目类型,0-海阅，1-海剧"
    ,sr_createtime datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id)
comment "mobking广告数据"
distributed by hash(Id) buckets 1 
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;