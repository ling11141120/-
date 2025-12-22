----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_usercourserecords
-- 来源实例： old_tidb_source
-- 来源表： hallow.usercourserecords
-- 来源负责： chh
-- 采集工具： SeaTunnel
-- 开发人：qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_usercourserecords;
create table ods.ods_tidb_hallow_usercourserecords (
     dt             date       not null comment '分区日期'
    ,Id             bigint     not null comment '记录ID'
    ,ParentId       bigint     not null comment '用户ID'
    ,CourseId       bigint     not null comment '课程ID'
    ,EpisodeIndex   int        not null comment '小集序号'
    ,State          tinyint    not null comment '状态：0(正在读)  1(读过)  2(读完)'
    ,CurrentSeconds int                 comment '当前进度(秒)'
    ,CreateTime     datetime            comment '创建时间'
    ,UpdateTime     datetime            comment '更新时间'
    ,sr_createtime  datetime            comment "starrocks入库时间"
    ,sr_updatetime  datetime            comment "starrocks数据更新时间"
)
primary key (dt, Id)
comment "圣经用户学习记录表"
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