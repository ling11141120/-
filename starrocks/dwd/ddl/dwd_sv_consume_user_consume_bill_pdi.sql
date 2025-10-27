DROP TABLE IF EXISTS dwd.dwd_sv_consume_user_consume_bill_pdi;
CREATE TABLE dwd.dwd_sv_consume_user_consume_bill_pdi (
     dt                  DATE              NOT NULL         COMMENT "日期"
    ,id                  BIGINT(20)        NOT NULL         COMMENT "bill表主键"
    ,consume_type        BIGINT(20)        NOT NULL         COMMENT "消费类型,0是代币,1是赠币"
    ,series_unlock_id    BIGINT(20)        NOT NULL         COMMENT "剧集解锁表主键"
    ,create_time         DATETIME          NOT NULL         COMMENT "创建时间"
    ,account_id          BIGINT(20)                         COMMENT "账号id"
    ,coin                BIGINT(20)                         COMMENT "当前代币数"
    ,bonus               BIGINT(20)                         COMMENT "当前赠币数"
    ,update_time         DATETIME                           COMMENT "更新时间"
    ,pre_bonus           BIGINT(20)                         COMMENT "充值前赠币"
    ,pre_coin            BIGINT(20)                         COMMENT "充值前代币"
    ,series_id           BIGINT(20)                         COMMENT "剧id"
    ,epis_id             BIGINT(20)                         COMMENT "剧集id"
    ,epis_ids            ARRAY<BIGINT(20)>                  COMMENT "剧集id(冗余字段，记录一次解锁对应的剧集)"
    ,epis_name           VARCHAR(65533)                     COMMENT "剧集名称"
    ,epis_num            BIGINT(20)                         COMMENT "集数"
    ,platform            VARCHAR(65533)                     COMMENT "平台"
    ,gain_bonus          BIGINT(20)                         COMMENT "获得的bonus"
    ,gain_coin           BIGINT(20)                         COMMENT "获得的coin"
    ,bill_type           BIGINT(20)                         COMMENT "充值类型"
    ,consume_type2       BIGINT(20)                         COMMENT "消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币,3超前点播赠币,4批量购买剧集,5整剧购买,6打包购买,7跨集批量解锁,8余额冻结,9余额激活"
    ,consume_value       DECIMAL(20, 6)                     COMMENT "消费数量"
    ,region_id           BIGINT(20)                         COMMENT "归属区域 id，1：香港，2：北美;"
    ,etl_time            DATETIME                           COMMENT "处理时间"
    ,INDEX index_consume_type (consume_type)   USING BITMAP COMMENT 'index_consume_type'
    ,INDEX index_consume_type2 (consume_type2) USING BITMAP COMMENT 'index_consume_type2'
) 
PRIMARY KEY(dt, id, consume_type, series_unlock_id, create_time)
COMMENT "海外短剧用户消耗明细表"
PARTITION BY RANGE(dt)
(PARTITION p20251024 VALUES LESS THAN ("2025-10-24"))
DISTRIBUTED BY HASH(dt, id) BUCKETS 1
PROPERTIES (
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