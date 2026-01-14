drop table if exists ads.ads_bi_read_first_read_consume_est_ed;
create table ads.ads_bi_read_first_read_consume_est_ed (
     dt              date            not null comment "阅读时间分区"
    ,md5_key         string          not null comment "主键key"
    ,lang_id         int             not null comment "书籍语言id"
    ,book_id         bigint                   comment "书籍id"
    ,serial_number   int                      comment "章节序号"
    ,mt              int                      comment "平台"
    ,corever         int                      comment "包体"
    ,user_tp         int                      comment "用户类型：1 新用户；2新增观看老用户；3 观看老用户"
    ,source_user_tp  int                      comment "媒体用户类型:1 注册当天 2 再营销安装 3 其它"
    ,source          varchar(255)             comment "媒体值（广告投放平台,取首次的媒体值）"
    ,chapter_length  int                      comment "章节字数"
    ,read_unt        bitmap                   comment "阅读人数"
    ,tot_csm_unt     bitmap                   comment "总消耗人数"
    ,csm_unt         bitmap                   comment "阅币消耗人数"
    ,tot_csm_amt     decimal(18, 2)           comment "总消耗货币数"
    ,csm_amt         decimal(18, 2)           comment "阅币消耗货币数"
    ,h12_read_unt    bitmap                   comment "h12阅读人数"
    ,h12_tot_csm_unt bitmap                   comment "h12总消耗人数"
    ,h12_csm_unt     bitmap                   comment "h12阅币消耗人数"
    ,h12_tot_csm_amt decimal(18, 2)           comment "h12总消耗货币数"
    ,h12_csm_amt     decimal(18, 2)           comment "h12阅币消耗货币数"
    ,h24_read_unt    bitmap                   comment "h24阅读人数"
    ,h24_tot_csm_unt bitmap                   comment "h24总消耗人数"
    ,h24_csm_unt     bitmap                   comment "h24阅币消耗人数"
    ,h24_tot_csm_amt decimal(18, 2)           comment "h24总消耗货币数"
    ,h24_csm_amt     decimal(18, 2)           comment "h24阅币消耗货币数"
    ,d3_read_unt     bitmap                   comment "d3阅读人数"
    ,d3_tot_csm_unt  bitmap                   comment "d3总消耗人数"
    ,d3_csm_unt      bitmap                   comment "d3阅币消耗人数"
    ,d3_tot_csm_amt  decimal(18, 2)           comment "d3总消耗货币数"
    ,d3_csm_amt      decimal(18, 2)           comment "d3阅币消耗货币数"
    ,d7_read_unt     bitmap                   comment "d7阅读人数"
    ,d7_tot_csm_unt  bitmap                   comment "d7总消耗人数"
    ,d7_csm_unt      bitmap                   comment "d7阅币消耗人数"
    ,d7_tot_csm_amt  decimal(18, 2)           comment "d7总消耗货币数"
    ,d7_csm_amt      decimal(18, 2)           comment "d7阅币消耗货币数"
    ,d30_read_unt    bitmap                   comment "d30阅读人数"
    ,d30_tot_csm_unt bitmap                   comment "d30总消耗人数"
    ,d30_csm_unt     bitmap                   comment "d30阅币消耗人数"
    ,d30_tot_csm_amt decimal(18, 2)           comment "d30总消耗货币数"
    ,d30_csm_amt     decimal(18, 2)           comment "d30阅币消耗货币数"
    ,etl_tm          datetime                 comment "清洗时间"
    ,index index_lang_id (lang_id) using bitmap comment 'index_lang_id'
)
primary key(dt, md5_key)
comment "阅读-西五区-用户书籍首次阅读章节消耗数据"
partition by range(dt)
(partition by p20251230 values less than ("2025-12-31"))
distributed by hash(dt, md5_key) buckets 3
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "dt, book_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;