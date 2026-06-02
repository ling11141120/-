create table if not exists dwd.dwd_market_sr_push_msg_log_di (
     dt            date         not null                  comment "分区日期"
    ,product_id    int          not null                  comment "product_id"
    ,id            bigint       not null                  comment "Id"
    ,create_time   datetime     not null                  comment "插入时间"
    ,user_id       bigint                                 comment "用户Id"
    ,app_id        varchar(255)                           comment "产品ID"
    ,mt            int                                    comment "平台"
    ,title         string                                 comment "标题"
    ,token_id      bigint                                 comment "TokenId"
    ,token         string                                 comment "令牌"
    ,body          string                                 comment "Push内容"
    ,customers     string                                 comment "自定义参数"
    ,batch_id      bigint                                 comment "批次Id"
    ,is_success    int                                    comment "是否推送成功"
    ,push_type     int                                    comment "推送类型"
    ,schedule_time datetime                               comment "计划推送时间"
    ,err_msg_id    string                                 comment "消息ID用于标识消息（FCM使用）"
    ,task_type     int                                    comment "任务类型"
    ,image_url       string                                 comment "图片地址"
    ,push_title_id   bigint                                 comment "push标题ID，解析自Body.aps.attributes.extData"
    ,push_content_id bigint                                 comment "push内容ID，解析自Body.aps.attributes.extData"
    ,etl_time        datetime                               comment "etl写入时间"
)
primary key(dt, product_id, id)
comment "营销域-海阅push资源位消息推送日志"
partition by date_trunc('day', dt)
distributed by hash(dt, product_id, id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, user_id, create_time, batch_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "60"
)
;
