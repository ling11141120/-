drop table if exists dws.dws_user_push_behavior_detail_df;
create table dws.dws_user_push_behavior_detail_df (
     dt                   date           not null                     comment "日期，事件时间"
    ,product_id           int            not null                     comment "产品id"
    ,event                varchar(50)    not null                     comment "事件类型(下发/送达/点击)"
    ,event_id             varchar(64)    not null                     comment "事件id"
    ,push_id              bigint(20)     not null                     comment "推送id"
    ,user_id              bigint(20)     not null                     comment "用户id"
    ,core                 int                                         comment "core"
    ,mt                   varchar(50)                                 comment "操作系统"
    ,push_type            varchar(100)                                comment "推送类型"
    ,push_name            varchar(255)                                comment "推送名称"
    ,msg_on               int                                         comment "消息通知开关"
    ,is_act               int                                         comment "是否活跃(1:是,0:否)"
    ,app_notify_msg_on    int                                         comment "APP通知消息开关(1:开启,其他:关闭)"
    ,etl_tm               datetime       default current_timestamp    comment "etl清洗时间"
)
primary key (dt, product_id, event,event_id, push_id, user_id)
comment "用户推送行为明细表"
partition by date_trunc("day", dt)
distributed by hash(event_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
   ,"partition_live_number" = "20"
)
;