----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_courses
-- 来源实例： hallow
-- 来源表： hallow.courses
-- 来源负责：徐传林
-- 采集工具： 极光-定时批量
-- 开发人：xjc
-- 开发日期： 2025-10-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_courses;
create table if not exists ods.ods_tidb_hallow_courses (
     id                     bigint               not null                        comment "课程id"
    ,coursename             varchar(1020)                                        comment "课程名称"
    ,coursecover            varchar(1020)                                        comment "课程封面"
    ,state                  tinyint                                              comment "状态：1(上架)  0(下架)"
    ,courseepisodes         int                                                  comment "课程集数"
    ,tags                   varchar(1020)                                        comment "课程标签"
    ,tags_list              array(varchar(1020))                                 comment "课程标签数组"
    ,score                  int                                                  comment "课程评分"
    ,comment                varchar(4096)                                        comment "备注"
    ,scene                  varchar(1020)                                        comment "场景"
    ,scenetag               varchar(1020)                                        comment "场景标签"
    ,author                 varchar(1020)                                        comment "作者"
    ,bgimgtype              int                                                  comment "课程背景图片类型，0：浅色，1：深色"
    ,sr_createtime          datetime             default current_timestamp       comment "sr入库时间"
    ,sr_updatetime          datetime             default current_timestamp       comment "starrocks数据更新时间"
)
primary key (id)
comment "课程表"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;