drop table if exists ads.ads_MarketingPlan;
create table ads.ads_MarketingPlan (
     dt                  date              not null    comment "统计日期",
    ,Id                  bigint(20)        not null    comment "主键ID",
    ,book_id             varchar(128)      not null    comment "书籍ID",
    ,book_code           varchar(128)                  comment "书籍编码",
    ,book_code_xl        varchar(128)                  comment "书籍编码系列",
    ,current_language    varchar(128)      not null    comment "投放语言",
    ,source_chl          varchar(128)                  comment "媒体",
    ,test_status         int(11)           default "0" comment "测试状态 0=未开始|1=测试中|2=已结束 3=停投  -1表示null或者空串",
    ,code_lv             varchar(20)                   comment "最高阶段投放等级 A|S|SS",
    ,code_stage          int(11)                       comment "测试阶段 海阅最大3阶 海剧最大2阶 国剧就1阶",
    ,plan_round          int(11)           not null    comment "测试轮次1|2|3",
    ,begin_date          datetime          not null    comment "开始日期",
    ,end_date            datetime          not null    comment "结束日期",
    ,bf_1_dt_spend       decimal(20, 2)                comment "昨天的花费",
    ,7_day_spend         decimal(20, 2)                comment "近30天的花费",
    ,30_day_spend        decimal(20, 2)                comment "近30天的花费",
    ,360_day_spend       decimal(20, 2)                comment "近360天的花费",
    ,stage3_date         datetime                      comment "进入三阶日期",
    ,stage3_spend        decimal(20, 2)                comment "进入3阶后的累计花费",
    ,etl_time            datetime          not null    comment "数据清洗时间"
)
primary key(`dt`,`Id`)
comment "市场测推表"
partition by range(`dt`)
(partition p202401 values [("2024-01-01"), ("2024-02-01")),
 partition p202402 values [("2024-02-01"), ("2024-03-01")),
 partition p202403 values [("2024-03-01"), ("2024-04-01")),
 partition p202404 values [("2024-04-01"), ("2024-05-01")),
 partition p202405 values [("2024-05-01"), ("2024-06-01")),
 partition p202406 values [("2024-06-01"), ("2024-07-01")),
 partition p202407 values [("2024-07-01"), ("2024-08-01")),
 partition p202408 values [("2024-08-01"), ("2024-09-01")),
 partition p202409 values [("2024-09-01"), ("2024-10-01")),
 partition p202410 values [("2024-10-01"), ("2024-11-01")),
 partition p202411 values [("2024-11-01"), ("2024-12-01")),
 partition p202412 values [("2024-12-01"), ("2025-01-01")),
 partition p202501 values [("2025-01-01"), ("2025-02-01")),
 partition p202502 values [("2025-02-01"), ("2025-03-01")),
 partition p202503 values [("2025-03-01"), ("2025-04-01")),
 partition p202504 values [("2025-04-01"), ("2025-05-01")),
 partition p202505 values [("2025-05-01"), ("2025-06-01")),
 partition p202506 values [("2025-06-01"), ("2025-07-01")),
 partition p202507 values [("2025-07-01"), ("2025-08-01")),
 partition p202508 values [("2025-08-01"), ("2025-09-01")),
 partition p202509 values [("2025-09-01"), ("2025-10-01")),
 partition p202510 values [("2025-10-01"), ("2025-11-01"))
)
distributed by hash(`dt`,`Id`) buckets 7
properties ("replication_num" = "3",
            "bloom_filter_columns" = "book_id",
            "dynamic_partition.enable" = "true",
            "dynamic_partition.time_unit" = "MONTH",
            "dynamic_partition.time_zone" = "Asia/Shanghai",
            "dynamic_partition.start" = "-120",
            "dynamic_partition.end" = "3",
            "dynamic_partition.prefix" = "p",
            "in_memory" = "false",
            "storage_format" = "DEFAULT",
            "enable_persistent_index" = "true",
            "compression" = "LZ4"
)
;