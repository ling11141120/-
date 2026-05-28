create table if not exists ads.ads_sv_advertisement_optimize_di
(
     dt                  date             not null                  comment "日期"
    ,book_id             bigint           not null                  comment "书籍id"
    ,languageid          int                                        comment "语言ID"
    ,book_language       varchar(50)                                comment "书籍语言"
    ,main_code           varchar(50)                                comment "主编码"
    ,source_series_code  varchar(50)                                comment "来源系列编码"
    ,core                int              not null                  comment "core版本"
    ,source_chl          varchar(128)     not null                  comment "渠道来源"
    ,optimizer_name      varchar(255)                               comment "优化师名称"
    ,optimizer_id        varchar(255)     not null                  comment "优化师id"
    ,cost_amount         decimal(18, 4)                             comment "花费金额"
    ,d0_roi              decimal(18, 4)                             comment "D0 ROI"
    ,d0_standard         decimal(18, 4)                             comment "D0标准"
    ,d0_attainment_rate  decimal(18, 4)                             comment "D0达成率"
    ,register_count      int                                        comment "注册数"
    ,cpi                 decimal(18, 4)                             comment "CPI"
    ,d0_cac              decimal(18, 4)                             comment "D0 CAC"
    ,etl_tm              datetime         default current_timestamp comment "清洗时间"
)
primary key(dt, book_id, core, source_chl, optimizer_id)
comment "海剧优化师每日投放数据"
distributed by hash(dt)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
