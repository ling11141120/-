----------------------------------------------------------------
-- 目标表： ods.ods_ab_hj_related
-- 来源实例： old-tidb-source
-- 来源表： ab_experiment.ab_hj_related
-- 来源负责人： 暂无
-- 开发人： qhr
-- 开发日期： 2026-04-21
----------------------------------------------------------------

drop table if exists ods.ods_ab_hj_related;
create table ods.ods_ab_hj_related (
     id             bigint        not null     comment "ID"
    ,ab_id          bigint        not null     comment "ab实验id"
    ,version_id     bigint                     comment "实验组id"
    ,strategy_id    bigint        not null     comment "策略id"
    ,type           varchar(128)  not null     comment "策略类型"
    ,creator        varchar(128)               comment "创建人"
    ,modifier       varchar(128)               comment "修改人"
    ,created_time   datetime                   comment "创建时间"
    ,modified_time  datetime                   comment "更新时间"
    ,yn             tinyint       default "1"  comment "0正常 1删除"
    ,project_id     int                        comment "项目id"
    ,sr_createtime  datetime                   comment ""
    ,sr_updatetime  datetime                   comment ""
)
primary key(id)
comment "实验和海剧策略关联表"
distributed by hash(id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "version_id, ab_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
