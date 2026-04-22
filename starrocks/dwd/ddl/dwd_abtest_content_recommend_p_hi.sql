drop table if exists dwd.dwd_abtest_content_recommend_p_hi;
create table dwd.dwd_abtest_content_recommend_p_hi (
     dt_hour            datetime not null comment "日期小时"
    ,project_id         int      not null comment "项目ID"
    ,exp_id             int      not null comment "实验ID"
    ,exp_grp_id         int      not null comment "实验组ID"
    ,object_id          bigint   not null comment "book_id书ID或者series_id剧ID"
    ,user_id            bigint   not null comment "用户ID"
    ,event_time         datetime not null comment "事件时间"
    ,exp_grp_type       int      not null comment "实验组类型ID"
    ,exp_type_id        int      not null comment "实验类型ID： 用户运营，内容推荐"
    ,exp_sub_type       string            comment "实验标签， 内容推荐下有：书城，cnxh"
    ,vip_type           int               comment "0-普通 1-福利包 2-vip 3-svip,参加多个活动，逗号分隔"
    ,position_index     int               comment "推荐日志得位序,曝光是顺序曝光,排在前面的曝光可能性更大"
    ,traffic_allocation double            comment "实验组流量占比"
    ,project_name       string            comment "项目名称"
    ,exp_name           string            comment "实验名称"
    ,exp_create_time    datetime          comment "实验创建时间"
    ,exp_update_time    datetime          comment "实验修改时间"
    ,exp_grp_name       string            comment "实验组名称"
    ,etl_time           datetime not null comment "数据清洗时间"
)
primary key(dt_hour, project_id, exp_id, exp_grp_id, object_id, user_id, event_time)
comment "AB测试-内容推荐(阅读与短剧)-实验信息-明细表--小时增量"
partition by range(dt_hour)
(partition p20260421 values less than ("2026-04-22"))
distributed by hash(exp_grp_id, user_id) buckets 1
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "project_id, exp_id, vip_type, exp_sub_type, position_index",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-30",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "210",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;
