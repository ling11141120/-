drop table if exists ads.ads_user_push_behavior_df_back;
create table ads.ads_user_push_behavior_df_back (
    dt                                 date            not null                     comment "日期"
   ,project_id                         int             not null                     comment "5:海阅,8:海剧"
   ,md5_key                            varchar(32)     not null                     comment "联合唯一键MD5"
   ,push_id                            bigint                                       comment "推送id"
   ,user_id                            bigint                                       comment "用户id"
   ,core                               varchar(32)                                  comment "核心版本"
   ,mt                                 varchar(20)                                  comment "操作系统"
   ,push_type                          varchar(128)                                 comment "推送类型"
   ,push_name                          varchar(255)                                 comment "推送名称"
   ,is_act                             tinyint                                      comment "是否活跃"
   ,is_send                            tinyint                                      comment "是否下发,1:是, null:否"
   ,is_received                        tinyint                                      comment "是否送达,1:是, null:否"
   ,is_click                           tinyint                                      comment "是否点击,1:是, null:否"
   ,app_notify_msg_on                  tinyint                                      comment "是否开启消息通知,1:是, null:否"
   ,etl_tm                             datetime        default current_timestamp    comment "etl清洗时间"
   ,index idx_core (core)              using bitmap                                 comment 'core bitmap索引'
   ,index idx_mt (mt)                  using bitmap                                 comment 'mt bitmap索引'
   ,index idx_push_type (push_type)    using bitmap                                 comment '推送类型 bitmap索引'
   ,index idx_push_name (push_name)    using bitmap                                 comment '推送名称 bitmap索引'
) 
primary key (dt, project_id, md5_key)
comment "用户推送行为标签表"
partition by date_trunc("month", dt)
distributed by hash(md5_key)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
   ,"partition_live_number" = "6"
   ,"bloom_filter_columns" = "push_id, user_id"
)
;