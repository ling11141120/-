drop table if exists dwd.dwd_device_gp_app_anr_di;
create table dwd.dwd_device_gp_app_anr_di (
     dt              date           not null comment "日期"
    ,id              bigint(20)     not null comment "主键"
    ,anr_type        varchar(50)    not null comment "ANR类型"
    ,init_time       datetime       not null comment "数据写入时间"
    ,start_time      datetime                comment "抓取日期"
    ,product_id      int(11)                 comment "产品Id"
    ,core            int(11)                 comment "Core"
    ,lang            varchar(60)             comment "语言"
    ,version_code    bigint(20)              comment "版本号"
    ,device_name     varchar(300)            comment "设备名称"
    ,manufacturer    varchar(100)            comment "厂商"
    ,device_model    varchar(100)            comment "机型"
    ,anr_count       int(11)                 comment "受影响用户数"
    ,anr_rate        decimal(15, 5)          comment "受影响比例"
    ,anr_global_rate decimal(15, 5)          comment "全局ANR率"
    ,device_guid     varchar(150)            comment "Guid"
    ,update_time     datetime                comment "数据更新时间"
    ,anr_time        datetime                comment "ANR日期"
    ,session_count   int(11)                 comment "会话数"
    ,active_count    int(11)                 comment "活动用户数"
    ,etl_tm          datetime                comment "etl时间"
)
primary key (dt, id, anr_type)
comment "设备域-GooglePlay上报机型ANR-每日增量"
partition by date_trunc('month', dt)
distributed by hash(dt, id, anr_type)
properties (
    "replication_num" = "2",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;