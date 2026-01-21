drop table if exists dws.dws_user_first_read_book_est_ed;
create table dws.dws_user_first_read_book_est_ed (
     dt             date         not null comment "阅读时间分区"
    ,product_id     int          not null comment "产品id"
    ,user_id        bigint                comment "用户id"
    ,book_id        bigint                comment "书籍id"
    ,fst_read_tm    datetime              comment "首次阅读时间"
    ,h12_time       datetime              comment "首次阅读时间+12h"
    ,h24_time       datetime              comment "首次阅读时间+24"
    ,d3_time        datetime              comment "首次阅读时间+3d"
    ,d7_time        datetime              comment "首次阅读时间+7d"
    ,d30_time       datetime              comment "首次阅读时间+30d"
    ,mt             int                   comment "平台"
    ,corever        int                   comment "包体"
    ,user_tp        int                   comment "用户类型：1 新用户；2新增观看老用户；3 观看老用户"
    ,source_user_tp int                   comment "媒体用户类型:1 注册当天 2 再营销安装 3 其它"
    ,source         varchar(255)          comment "媒体值（广告投放平台,取首次的媒体值）"
    ,etl_tm         datetime              comment "清洗时间"
)
duplicate key(dt, product_id, user_id, book_id)
comment "阅读-西五区-用户书籍首次阅读数据"
partition by range(dt)
(partition p20251230 values less than ("2025-12-31"))
distributed by hash(dt, product_id, user_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id",
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