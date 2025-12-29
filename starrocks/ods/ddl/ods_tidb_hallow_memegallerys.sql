----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_memegallerys
-- 来源实例： old_tidb_source
-- 来源表： hallow.memegallerys
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-12-22
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_memegallerys;
create table ods.ods_tidb_hallow_memegallerys (
    id               bigint      not null                     comment "套图id"
   ,text             varchar(1536)                            comment "文本"
   ,comment          varchar(6144)                            comment "描述"
   ,keyword          varchar(765)                             comment "关键词"
   ,tag              varchar(765)                             comment "标签"
   ,panel            int                                      comment "图片格数（几格漫画）"
   ,healing          int                                      comment "治愈评分"
   ,touching         int                                      comment "感动评分"
   ,memecount        int         not null                     comment "套图中梗图数量"
   ,status           tinyint     not null                     comment "状态：1(上架)  0(下架)"
   ,scene            varchar(765)                             comment "场景"
   ,author           varchar(765)                             comment "作者"
   ,sr_createtime    datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime    datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "用于存储套图（梗图集合）的元数据信息表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;
