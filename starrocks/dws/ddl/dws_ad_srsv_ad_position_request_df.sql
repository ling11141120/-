drop table if exists dws.dws_ad_srsv_ad_position_request_df;
create table dws.dws_ad_srsv_ad_position_request_df (
     dt                   date                                  comment "日期"
    ,event_name           varchar(100)                          comment "事件名称"
    ,id                   varchar(100)                          comment "事件唯一记录id"
    ,user_id              bigint                                comment "用户id"
    ,ad_show_type         varchar(50)                           comment "广告展示类型"
    ,ad_show_type_name    varchar(100)                          comment "广告展示类型名称"
    ,ad_position_id       bigint                                comment "广告位id"
    ,ad_position_name     varchar(200)                          comment "广告位名称"
    ,ad_id                varchar(200)                          comment "广告id"
    ,core                 varchar(50)                           comment "core"
    ,mt                   varchar(20)                           comment "mt"
    ,language_id          varchar(20)                           comment "语言id"
    ,reg_country          bigint                                comment "注册国家"
    ,project_id           bigint                                comment "5：海阅，8：海剧"
    ,app_ver              bigint                                comment "应用版本号"
    ,request_result       varchar(50)                           comment "广告请求结果"
    ,request_duration     decimal(20, 3)                        comment "请求时长"
    ,etl_tm               datetime default current_timestamp    comment "清洗时间"
)
primary key(dt, event_name, id)
comment "广告域-ADRequest/ADInvocation/ADShow/ADTrigger事件广告位置请求明细数据表"
partition by date_trunc("month", dt)
distributed by hash(dt, event_name, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;