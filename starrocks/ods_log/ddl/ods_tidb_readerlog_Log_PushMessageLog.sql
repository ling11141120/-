----------------------------------------------------------------
-- 目标表：ods_tidb_readerlog_Log_PushMessageLog
-- 来源实例：old-tidb-source
-- 来源表：
--       readerlog_en.Log_PushMessageLog
--       readerlog_pt.Log_PushMessageLog
--       readerlog_fr.Log_PushMessageLog
--       readerlog_ft.Log_PushMessageLog
--       readerlog_id.Log_PushMessageLog
--       readerlog_jp.Log_PushMessageLog
--       readerlog_ru.Log_PushMessageLog
--       readerlog_sp.Log_PushMessageLog
--       readerlog_th.Log_PushMessageLog
-- 来源负责人：未知
-- 开发人：050239
-- 开发日期：2026-05-07
----------------------------------------------------------------

create table if not exists ods.ods_tidb_readerlog_Log_PushMessageLog (
     dt            date         not null                  comment "createtime 分区"
    ,product_id    int          not null                  comment "产品id"
    ,Id            bigint       not null                  comment "Id"
    ,CreateTime    datetime     not null                  comment "插入时间"
    ,UserId        bigint                                 comment "用户Id"
    ,ProdId        varchar(255)                           comment "产品ID"
    ,MT            int          default "0"               comment "平台"
    ,Title         string                                 comment "标题"
    ,TokenId       bigint                                 comment "TokenId"
    ,Token         string                                 comment "令牌"
    ,Body          string                                 comment "内容"
    ,Customers     string                                 comment "推送下发参数"
    ,Param         string                                 comment "辅助参数"
    ,BatchId       bigint                                 comment "批次Id"
    ,State         int          default "0"               comment "状态:0未入列1已入列2已出列3已推送4推送失败5token不存在6FCM有效投递7FCM送达8已发站内信"
    ,UpdateTime    datetime                               comment "更新时间"
    ,PushResponse  string                                 comment "推送结果"
    ,PushType      int          default "1"               comment "推送类型 1常规 2私信"
    ,PushTime      datetime                               comment "计划推送时间"
    ,MessageId     string                                 comment "消息 ID 用于标识消息（FCM使用）"
    ,TokenType     int                                    comment "0友盟1FCM2华为"
    ,TaskType      int          default "1"               comment "任务类型1Tag中台推送2全站推送3召回推送任务4章节更新推送"
    ,ImageUrl      string                                 comment ""
    ,IsSilent      tinyint                                comment ""
    ,sr_createtime datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime     default current_timestamp comment "starrocks数据更新时间"
    ,index index_productid (product_id) using bitmap comment 'index_productid'
    ,index index_State (State) using bitmap comment 'index_State'
)
primary key(dt, product_id, id, createtime)
comment "push推送日志表"
partition by range(dt)
(partition p20260507 values less than ("2026-05-08"))
distributed by hash(dt, product_id, id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "BatchId, UpdateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-240",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "240",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
