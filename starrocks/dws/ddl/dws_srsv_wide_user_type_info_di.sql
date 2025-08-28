drop table if exists dws.dws_srsv_wide_user_type_info_di;
create table dws.dws_srsv_wide_user_type_info_di (
     dt                    date               not null comment "统计时间分区,用户活跃时间"
    ,product_id            int(11)            not null comment "产品id"
    ,user_id               bigint(20)         not null comment "用户id"
    ,user_period           int(11)            not null comment "用户类型 1：新用户 2：活跃用户 3：rmt(拉活用户)"
    ,corever               int(11)                     comment "corever"
    ,mt                    int(11)                     comment "终端"
    ,reg_country           varchar(512)                comment "国家"
    ,country_level         int(11)                     comment "国家等级"
    ,current_language2     int(11)                     comment "注册语言"
    ,source                int(11)                     comment "3是付费 2是官网  1 是自然和其他 条件：source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3 when source in ('officialsite','(not set)') then 2 else 1"
    ,is_pay                int(11)                     comment "1:付费,0:非付费（历史是否付费，充值）"
    ,chl2                  varchar(512)                comment "初始渠道值"
    ,chl                   varchar(512)                comment "最新渠道值"
    ,group_id_list         varchar(655330)             comment "在包用户集合"
    ,position_name_list    varchar(65533)              comment "触发资源位集合"
    ,etl_tm                datetime           not null comment "数据清洗时间"
    ,index index_current_language2 (current_language2) using bitmap comment '注册语言索引'
)
primary key(dt, product_id, user_id, user_period)
comment "海阅sr、海剧sv不同用户类型活跃表"
partition by range(dt)
(partition p202006 values [("2020-06-01"), ("2020-07-01")],
 partition p202007 values [("2020-07-01"), ("2020-08-01")],
 partition p202008 values [("2020-08-01"), ("2020-09-01")],
 partition p202009 values [("2020-09-01"), ("2020-10-01")],
 partition p202010 values [("2020-10-01"), ("2020-11-01")],
 partition p202011 values [("2020-11-01"), ("2020-12-01")],
 partition p202012 values [("2020-12-01"), ("2021-01-01")],
 partition p202101 values [("2021-01-01"), ("2021-02-01")],
 partition p202102 values [("2021-02-01"), ("2021-03-01")],
 partition p202103 values [("2021-03-01"), ("2021-04-01")],
 partition p202104 values [("2021-04-01"), ("2021-05-01")],
 partition p202105 values [("2021-05-01"), ("2021-06-01")],
 partition p202106 values [("2021-06-01"), ("2021-07-01")],
 partition p202107 values [("2021-07-01"), ("2021-08-01")],
 partition p202108 values [("2021-08-01"), ("2021-09-01")],
 partition p202109 values [("2021-09-01"), ("2021-10-01")],
 partition p202110 values [("2021-10-01"), ("2021-11-01")],
 partition p202111 values [("2021-11-01"), ("2021-12-01")],
 partition p202112 values [("2021-12-01"), ("2022-01-01")],
 partition p202201 values [("2022-01-01"), ("2022-02-01")],
 partition p202202 values [("2022-02-01"), ("2022-03-01")],
 partition p202203 values [("2022-03-01"), ("2022-04-01")],
 partition p202204 values [("2022-04-01"), ("2022-05-01")],
 partition p202205 values [("2022-05-01"), ("2022-06-01")],
 partition p202206 values [("2022-06-01"), ("2022-07-01")],
 partition p202207 values [("2022-07-01"), ("2022-08-01")],
 partition p202208 values [("2022-08-01"), ("2022-09-01")],
 partition p202209 values [("2022-09-01"), ("2022-10-01")],
 partition p202210 values [("2022-10-01"), ("2022-11-01")],
 partition p202211 values [("2022-11-01"), ("2022-12-01")],
 partition p202212 values [("2022-12-01"), ("2023-01-01")],
 partition p202301 values [("2023-01-01"), ("2023-02-01")],
 partition p202302 values [("2023-02-01"), ("2023-03-01")],
 partition p202303 values [("2023-03-01"), ("2023-04-01")],
 partition p202304 values [("2023-04-01"), ("2023-05-01")],
 partition p202305 values [("2023-05-01"), ("2023-06-01")],
 partition p202306 values [("2023-06-01"), ("2023-07-01")],
 partition p202307 values [("2023-07-01"), ("2023-08-01")],
 partition p202308 values [("2023-08-01"), ("2023-09-01")],
 partition p202309 values [("2023-09-01"), ("2023-10-01")],
 partition p202310 values [("2023-10-01"), ("2023-11-01")],
 partition p202311 values [("2023-11-01"), ("2023-12-01")],
 partition p202312 values [("2023-12-01"), ("2024-01-01")],
 partition p202401 values [("2024-01-01"), ("2024-02-01")],
 partition p202402 values [("2024-02-01"), ("2024-03-01")],
 partition p202403 values [("2024-03-01"), ("2024-04-01")],
 partition p202404 values [("2024-04-01"), ("2024-05-01")],
 partition p202405 values [("2024-05-01"), ("2024-06-01")],
 partition p202406 values [("2024-06-01"), ("2024-07-01")],
 partition p202407 values [("2024-07-01"), ("2024-08-01")],
 partition p202408 values [("2024-08-01"), ("2024-09-01")],
 partition p202409 values [("2024-09-01"), ("2024-10-01")],
 partition p202410 values [("2024-10-01"), ("2024-11-01")],
 partition p202411 values [("2024-11-01"), ("2024-12-01")],
 partition p202412 values [("2024-12-01"), ("2025-01-01")],
 partition p202501 values [("2025-01-01"), ("2025-02-01")],
 partition p202502 values [("2025-02-01"), ("2025-03-01")],
 partition p202503 values [("2025-03-01"), ("2025-04-01")],
 partition p202504 values [("2025-04-01"), ("2025-05-01")],
 partition p202505 values [("2025-05-01"), ("2025-06-01")],
 partition p202506 values [("2025-06-01"), ("2025-07-01")],
 partition p202507 values [("2025-07-01"), ("2025-08-01")],
 partition p202508 values [("2025-08-01"), ("2025-09-01")],
 partition p202509 values [("2025-09-01"), ("2025-10-01")],
 partition p202510 values [("2025-10-01"), ("2025-11-01")],
 partition p202511 values [("2025-11-01"), ("2025-12-01")]
)
distributed by hash(dt, product_id, user_id) buckets 10 
properties ("replication_num" = "3",
            "dynamic_partition.enable" = "true",
            "dynamic_partition.time_unit" = "Month",
            "dynamic_partition.time_zone" = "Asia/Shanghai",
            "dynamic_partition.start" = "-360",
            "dynamic_partition.end" = "3",
            "dynamic_partition.prefix" = "p",
            "dynamic_partition.buckets" = "70",
            "dynamic_partition.history_partition_num" = "0",
            "dynamic_partition.start_day_of_month" = "1",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "storage_medium" = "SSD",
            "compression" = "ZSTD"
)
;