----------------------------------------------------------------
-- 目标表： ods.ods_short_video_commandtask
-- 来源实例： idc-tidb-查询
-- 来源表： short_video.commandtask
-- 采集工具： 极光-定时批量
-- 负责人： qhr
-- 开发日期： 2023-12-26
-- 备注： ClassType='user_refund'
----------------------------------------------------------------

drop table if exists ods.ods_short_video_commandtask;
create table ods.ods_short_video_commandtask (
     id             int(11)        not null                  comment ""
    ,classtype      varchar(512)                             comment ""
    ,args           string                                   comment ""
    ,scheduletime   datetime                                 comment ""
    ,status         int(11)                                  comment ""
    ,execcount      int(11)                                  comment ""
    ,exectime       datetime                                 comment ""
    ,sr_createtime  datetime       default current_timestamp comment ""
    ,sr_updatetime  datetime                                 comment ""
)
primary key (id)
comment "短剧--订单退款记录"
distributed by hash (id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;