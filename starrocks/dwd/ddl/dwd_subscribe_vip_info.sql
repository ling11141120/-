drop table if exists dwd.dwd_subscribe_vip_info;
create table dwd.dwd_subscribe_vip_info (
     product_id  int      not null comment "分区日期"
    ,user_id     bigint   not null comment "用户id"
    ,vip_type    int      not null comment "vip类型"
    ,is_vip      tinyint           comment "是否vip"
    ,vip_level   int               comment "vip等级"
    ,expire_time datetime          comment "过期时间"
    ,create_time datetime          comment "创建时间"
    ,update_time datetime          comment "更新时间"
    ,etl_time    datetime          comment "etl时间"
)
primary key(product_id, user_id, vip_type)
comment "订阅域-vip信息"
distributed by hash(product_id, user_id, vip_type)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;