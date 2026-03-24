----------------------------------------------------------------
-- 目标表：ods.ods_tidb_sharpengine_ads_global_adsouttestbook
-- 来源实例：new_tidb_source
-- 来源表：sharpengine_ads_global.AdsOutTestBook
-- 来源负责：
-- 采集工具：SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-03-12
----------------------------------------------------------------

drop table if exists ods.ods_tidb_sharpengine_ads_global_adsouttestbook;
create table ods.ods_tidb_sharpengine_ads_global_adsouttestbook (
     id                       bigint      not null                     comment "主键ID"
    ,bookid                   bigint      not null                     comment "书籍Id"
    ,coversrc                 varchar(12288)                           comment "封面"
    ,summary                  varchar(65533)                           comment "简介"
    ,freechapterlength        bigint      not null                     comment "免费章节字数"
    ,isputdown                int         not null                     comment "上下架"
    ,istranslatebook          int         not null                     comment "是否翻译,1是|0不是"
    ,isadsouttestsmall        int         not null                     comment "是否小测 1是"
    ,estimateddeliverydate    datetime                                 comment "预计交付日期"
    ,createtime               datetime    not null                     comment "创建时间"
    ,updatetime               datetime    not null                     comment "更新时间"
    ,iswashingbook            int         not null                     comment "是否洗稿短篇 0否  1是"
    ,priority                 int                                      comment "优先级  p0  p1  p2"
    ,isexcluded               tinyint     not null                     comment "是否排除"
    ,sr_createtime            datetime    default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime            datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key (id)
comment "外测书籍"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;