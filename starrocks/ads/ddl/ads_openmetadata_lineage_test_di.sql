create table if not exists ads.ads_openmetadata_lineage_test_di
(
    dt                           date         not null comment "分区日期"
    ,table_name                  varchar(100) not null comment "目标表名"
    ,row_count                   bigint                comment "当日数据行数"
    ,min_etl_time                datetime              comment "最早ETL时间"
    ,max_etl_time                datetime              comment "最晚ETL时间"
    ,status                      varchar(20)           comment "数据状态（正常/缺失/空数据）"
    ,etl_time                    datetime              comment "数据清洗时间"
)
engine = OLAP
primary key(dt, table_name)
comment "OpenMetadata血缘测试-ADS表数据完整性检查"
partition by date_trunc("day", dt)
distributed by hash(dt, table_name) buckets 4
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
