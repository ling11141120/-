----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_chatlog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_chatlog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-11-13
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_chatlog;
create table ods.ods_tidb_hallow_log_log_chatlog (
    Id               bigint          not null                  comment "主键Id"
   ,CreateTime       datetime        not null                  comment "日志时间"
   ,UserId           bigint          not null                  comment "用户Id"
   ,ConversationId   varchar(192)                              comment "聊天会话Id"
   ,Content          string                                    comment "聊天内容"
   ,Reply            string                                    comment "回答"
   ,InputType        tinyint                                   comment "输入类型 1：用户输入  2：快速提问  3：默认问题"
   ,MessageType      tinyint                                   comment "消息类型 1：文本  2：经文  3：梗图  4：课程"
   ,ResourceId       varchar(765)                              comment "资源ID"
   ,sr_createtime    datetime        default current_timestamp comment "starrocks入库时间"
   ,sr_updatetime    datetime        default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id,CreateTime)
comment "圣经新增用户对话次数"
partition by date_trunc("month", CreateTime)
distributed by hash(CreateTime)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;