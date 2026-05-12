----------------------------------------------------------------
-- 目标表：ods_tidb_readernovel_tidb_tag_center_book_scheme
-- 来源实例：old-tidb-source
-- 来源表：ReaderNovel_tidb_tab.center_book_sheme
-- 来源负责人：cyd
-- 开发人：050239
-- 开发日期：2026-05-07
----------------------------------------------------------------

create table if not exists ods.ods_tidb_readernovel_tidb_tag_center_book_scheme (
     dt               datetime     not null comment "日期"
    ,Id               int          not null comment ""
    ,UseType          int                   comment "使用类型"
    ,Name             string                comment "方案名称"
    ,SchemeType       int                   comment "方案属性"
    ,Status           int                   comment "状态"
    ,Weight           int                   comment "权重"
    ,BeginTime        datetime              comment "开始时间"
    ,EndTime          datetime              comment "结束时间"
    ,GroupIds         string                comment "人群包"
    ,ExcludeGroupIds  string                comment "剔除人群包"
    ,CreateTime       datetime              comment ""
    ,UpdateTime       datetime              comment ""
    ,AuditStatus      int                   comment "审核状态"
    ,ApplyType        int                   comment "应用类型"
    ,JGroupIds        varchar(100)          comment "极光人群包"
    ,ExcludeJGroupIds varchar(100)          comment "极光剔除人群包"
    ,SecondApplyType  int                   comment ""
    ,UnreadTime       int                   comment ""
    ,Flow             int                   comment "流量类型 0全量流量，1实验流量"
    ,IsVipAdSource    int                   comment "是否VIP引流（0否，1是）"
    ,PlanCode         varchar(300)          comment "策略代号）"
    ,sr_createtime    datetime              comment ""
    ,sr_updatetime    datetime              comment ""
)
primary key(dt, id)
distributed by hash(id) buckets 5
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
