create table if not exists ads.ads_sr_push_message_log (
     dt             date         not null                  comment "createtime 分区"
    ,product_id     int          not null                  comment "产品id"
    ,id             bigint       not null                  comment "Id"
    ,create_time    datetime     not null                  comment "插入时间"
    ,user_id        bigint                                 comment "用户Id"
    ,active_user_id bigint                                 comment "活跃用户id"
    ,prod_id        varchar(255)                           comment "产品ID"
    ,mt             int                                    comment "平台"
    ,title          string                                 comment "标题"
    ,token_id       bigint                                 comment "TokenId"
    ,token          string                                 comment "令牌"
    ,body           string                                 comment "内容"
    ,customers      string                                 comment "推送下发参数"
    ,param          string                                 comment "辅助参数"
    ,batch_id       bigint                                 comment "批次Id"
    ,state          int                                    comment "状态:0未入列1已入列2已出列3已推送4推送失败5token不存在6FCM有效投递7FCM送达8已发站内信"
    ,update_time    datetime                               comment "更新时间"
    ,push_response  string                                 comment "推送结果"
    ,push_type      int                                    comment "推送类型 1常规 2私信"
    ,push_time      datetime                               comment "计划推送时间"
    ,message_id     string                                 comment "消息 ID 用于标识消息（FCM使用）"
    ,token_type     int                                    comment "0友盟1FCM2华为"
    ,task_type      int                                    comment "任务类型1Tag中台推送2全站推送3召回推送任务4章节更新推送"
    ,image_url      string                                 comment ""
    ,is_silent      tinyint                                comment ""
    ,etl_time       datetime     default current_timestamp comment "ETL时间"
    ,push_title_id  string                                 comment "push标题ID"
    ,push_content_id string                                comment "push内容ID"
    ,index index_productid (product_id) using bitmap       comment 'index_productid'
    ,index index_state (state)          using bitmap       comment 'index_state'
)
primary key(dt, product_id, id, create_time)
comment "push推送日志表"
partition by range(dt)
(partition p20260509 values less than ("2026-05-10"))
distributed by hash(dt, product_id, id) buckets 15
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "update_time, batch_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-180",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
