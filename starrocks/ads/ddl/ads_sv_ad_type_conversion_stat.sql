drop table if exists ads.ads_sv_ad_type_conversion_stat;
create table ads.ads_sv_ad_type_conversion_stat (
    dt                       date           not null                     comment "日期"
   ,md5_key                  varchar(32)    not null                     comment "md5主键"
   ,ad_show_type             varchar(50)                                 comment "广告类型id"
   ,core                     varchar(50)                                 comment "core版本"
   ,mt                       int(11)                                     comment "终端 1=ios 4=android"
   ,language_id              int(11)                                     comment "投放语言id"
   ,reg_country              varchar(200)                                comment "注册国家code"
   ,ad_show_type_name        varchar(200)                                comment "广告类型名称"
   ,mt_name                  varchar(50)                                 comment "终端名称"
   ,language_name            varchar(200)                                comment "投放语言名称"
   ,reg_country_name         varchar(200)                                comment "注册国家名称"
   ,ad_request_pv            bigint(20)                                  comment "广告请求pv"
   ,ad_request_success_pv    bigint(20)                                  comment "广告请求成功pv"
   ,ad_invocation_pv         bigint(20)                                  comment "广告调用pv"
   ,ad_show_success_pv       bigint(20)                                  comment "广告展现成功pv"
   ,total_show_duration      bigint(20)                                  comment "累计展现耗时"
   ,ad_show_fail_pv          bigint(20)                                  comment "广告展现失败pv"
   ,etl_time                 datetime       default current_timestamp    comment "etl清洗时间"
   ,project_id               varchar(30)                                 comment "5阅读 8 短剧"
)
primary key(dt, md5_key)
comment "海剧-广告触达到播放转化报表-分广告类型转化统计"
partition by range(dt)
distributed by hash(dt, md5_key)
properties (
    "replication_num" = "3"
   ,"bloom_filter_columns" = "dt"
   ,"dynamic_partition.enable" = "true"
   ,"dynamic_partition.time_unit" = "month"
   ,"dynamic_partition.time_zone" = "Asia/Shanghai"
   ,"dynamic_partition.start" = "-2147483648"
   ,"dynamic_partition.end" = "3"
   ,"dynamic_partition.prefix" = "p"
   ,"dynamic_partition.buckets" = "3"
   ,"dynamic_partition.history_partition_num" = "0"
   ,"dynamic_partition.start_day_of_month" = "1"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;