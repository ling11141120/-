----------------------------------------------------------------
-- 目标表：ods_tidb_shuangwen_tidb_xx_objectcaldistance
-- 来源实例：hk-cm-mysql-slave
-- 来源表：
--       fanyidb_tidb.objectcaldistance
--       shuangwen_tidb_en.objectcaldistance
--       shuangwen_tidb_sp.objectcaldistance
-- 来源负责人：cyd
-- 开发人：050239
-- 开发日期：2026-05-11
----------------------------------------------------------------

create table if not exists ods.ods_tidb_shuangwen_tidb_xx_objectcaldistance (
     Id              int      not null                  comment "主键"
    ,ProductId       int      not null                  comment "产品id"
    ,SiteId          int      not null                  comment "语言id"
    ,SwBookId        int      not null                  comment "目标书籍id"
    ,ObjectBookId    int      not null                  comment "项目图书id"
    ,ObjectChapterId int      not null                  comment "章节id"
    ,Distance1       int      not null                  comment "质检分子"
    ,Distance2       int      not null                  comment "一校分子"
    ,Distance3       int      not null                  comment "二校分子"
    ,MachineLength   int      not null                  comment "机翻字符数"
    ,EChapterLength  int      not null                  comment "质检字符数"
    ,PEChapterLength int      not null                  comment "一校字符数"
    ,WkChapterLength int      not null                  comment "二校字符数"
    ,CreateTime      datetime not null                  comment "创建时间"
    ,CompleteTime    datetime                           comment "质检完成时间"
    ,ForeignTime     datetime                           comment "一校完成时间"
    ,PublishTime     datetime                           comment "二校完成时间"
    ,sr_createtime   datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime   datetime default current_timestamp comment "starrocks数据更新时间"
)
primary key(id, productid)
comment "章节修改比例"
distributed by hash(id, productid) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
