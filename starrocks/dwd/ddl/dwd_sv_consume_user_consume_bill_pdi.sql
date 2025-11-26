drop table if exists dwd.dwd_sv_consume_user_consume_bill_pdi;
create table dwd.dwd_sv_consume_user_consume_bill_pdi (
     dt                  date              not null         comment "日期"
    ,id                  bigint(20)        not null         comment "bill表主键"
    ,consume_type        bigint(20)        not null         comment "消费类型,0是代币,1是赠币"
    ,series_unlock_id    bigint(20)        not null         comment "剧集解锁表主键"
    ,create_time         datetime          not null         comment "创建时间"
    ,account_id          bigint(20)                         comment "账号id"
    ,coin                bigint(20)                         comment "当前代币数"
    ,bonus               bigint(20)                         comment "当前赠币数"
    ,update_time         datetime                           comment "更新时间"
    ,pre_bonus           bigint(20)                         comment "充值前赠币"
    ,pre_coin            bigint(20)                         comment "充值前代币"
    ,series_id           bigint(20)                         comment "剧id"
    ,epis_id             bigint(20)                         comment "剧集id"
    ,epis_ids            array<bigint(20)>                  comment "剧集id(冗余字段，记录一次解锁对应的剧集)"
    ,epis_name           varchar(65533)                     comment "剧集名称"
    ,epis_num            bigint(20)                         comment "集数"
    ,platform            varchar(65533)                     comment "平台"
    ,gain_bonus          bigint(20)                         comment "获得的bonus"
    ,gain_coin           bigint(20)                         comment "获得的coin"
    ,bill_type           bigint(20)                         comment "充值类型"
    ,consume_type2       bigint(20)                         comment "消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币,3超前点播赠币,4批量购买剧集,5整剧购买,6打包购买,7跨集批量解锁,8余额冻结,9余额激活"
    ,consume_value       decimal(20, 6)                     comment "消费数量"
    ,region_id           bigint(20)                         comment "归属区域 id，1：香港，2：北美;"
    ,etl_time            datetime                           comment "处理时间"
    ,index index_consume_type (consume_type)   using bitmap comment 'index_consume_type'
    ,index index_consume_type2 (consume_type2) using bitmap comment 'index_consume_type2'
) 
primary key(dt, id, consume_type, series_unlock_id, create_time)
comment "海外短剧用户消耗明细表"
partition by range(dt)
(partition p20251024 values less than ("2025-10-24"))
distributed by hash(dt, id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "account_id, create_time",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;