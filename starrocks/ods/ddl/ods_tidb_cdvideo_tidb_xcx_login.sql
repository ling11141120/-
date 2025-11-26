----------------------------------------------------------------
-- 目标表： ods.ods_tidb_cdvideo_tidb_xcx_login
-- 来源实例： new_tidb_source
-- 来源表： cdvideo_tidb_xcx.uni_id_log
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期：2025-11-25
----------------------------------------------------------------
drop table if exists ods.ods_tidb_cdvideo_tidb_xcx_login;
create table ods.ods_tidb_cdvideo_tidb_xcx_login (
     Id            bigint(20)  not null                  comment "自增ID"
    ,log_id        varchar(50)                           comment "uni-id-log._id"
    ,log_type      varchar(50)                           comment "操作类型 uni-id-log.type"
    ,login_type    varchar(50)                           comment "登录类型 uni-id-log.login_type"
    ,user_id       varchar(50)                           comment "uni-id-log.user_id"
    ,ip            varchar(50)                           comment "uni-id-log.ip"
    ,os            varchar(50)                           comment "uni-id-log.os"
    ,platform      varchar(50)                           comment "uni-id-log.platform"
    ,state         int(11)                               comment "结果:0 失败,1 成功 uni-id-log.state"
    ,create_time   datetime    not null                  comment "uni-id-log._add_time"
    ,sr_createtime datetime    deFAULT CURRENT_TIMESTAMP comment "starrocks数据注入时间"
    ,sr_updatetime datetime                              comment "starrocks数据更新时间"
)
primary key(Id)
comment "国内短剧用户登录表"
distributed by hash(Id) buckets 8
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;