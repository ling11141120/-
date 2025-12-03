----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_userprayers
-- 来源实例： old_tidb_source
-- 来源表： hallow.userprayers
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-11-13
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_userprayers;
create table ods.ods_tidb_hallow_userprayers (
     dt            date         not null comment "分区日期"
    ,Id            bigint       not null comment '主键Id'
    ,ParentId      bigint       not null comment '用户Id'
    ,Subject       varchar(765) not null comment '主题'
    ,Scripture     string       not null comment '经文内容'
    ,Visibility    smallint     not null comment '祷文可见性'
    ,CreateTime    datetime     not null comment '创建时间'
    ,FinishTime    datetime              comment '完成时间'
    ,sr_createtime datetime              comment "starrocks入库时间"
    ,sr_updatetime datetime              comment "starrocks数据更新时间"
)
primary key(dt, Id)
comment "圣经用户祷告表"
partition by date_trunc("month", dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;