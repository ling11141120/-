----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_favorites
-- 来源实例： old_tidb_source
-- 来源表： hallow.favorites
-- 来源负责： chh
-- 采集工具： SeaTunnel
-- 开发人：qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_favorites;
create table ods.ods_tidb_hallow_favorites (
     dt             date         not null comment '分区日期'
    ,Id             bigint       not null comment '主键Id'
    ,ParentId       bigint       not null comment '用户ID'
    ,SectionContent string       not null comment '经文内容'
    ,CreateTime     datetime     not null comment '创建时间'
    ,ImageId        int                   comment '图片ID'
    ,MusicId        int                   comment '音乐ID'
    ,SectionPos     varchar(765)          comment '券章节Key'
    ,BookId         int          not null comment '书籍ID'
    ,sr_createtime  datetime              comment "starrocks入库时间"
    ,sr_updatetime  datetime              comment "starrocks数据更新时间"
)
primary key (dt, Id)
comment "圣经收藏表"
partition by date_trunc('month', dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;