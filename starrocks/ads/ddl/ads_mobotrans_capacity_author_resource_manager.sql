DROP TABLE IF EXISTS ads.ads_mobotrans_capacity_author_resource_manager;
CREATE TABLE IF NOT EXISTS ads.ads_mobotrans_capacity_author_resource_manager (
     dt                          date                not null        comment "年分区字段：日期"
    ,site_id                     int(11)             not null        comment "语言id"
    ,role_type                   int(11)             not null        comment "译员角色"
    ,total_num                   int(11)             null            comment "人数"
    ,work_status_coo             int(11)             null            comment "签约状态为合作的人数"
    ,work_status_bre             int(11)             null            comment "签约状态为解约的人数"
    ,work_status_sle             int(11)             null            comment "签约状态为休眠的人数"
    ,active_num_curmonth         int(11)             null            comment "本月活跃人数"
    ,active_rate_curmonth        decimal(18, 4)      null            comment "本月活跃人数占比"
    ,font_length_curmonth        bigint(20)          null            comment "本月总产能"
    ,font_length_tar_curmonth    bigint(20)          null            comment "本月全职总产能"
    ,length_rate_tar_curmonth    decimal(18, 4)      null            comment "本月全职总产能占比"
    ,font_length_par_curmonth    bigint(20)          null            comment "本月非全职总产能"
    ,length_rate_par_curmonth    decimal(18, 4)      null            comment "本月非全职总产能占比"
    ,process_offset              bigint(20)          null            comment "进度偏差"
    ,score_a_num                 int(11)             null            comment "质量分A档人数"
    ,score_b_num                 int(11)             null            comment "质量分B档人数"
    ,score_c_num                 int(11)             null            comment "质量分C档人数"
    ,etl_time                    datetime            not null        comment "数据清洗时间"
    ,index index_site_id (site_id)                   using bitmap    comment '语言id索引'
    ,index index_role_type (role_type)               using bitmap    comment '译员角色索引'
)
primary key(dt, site_id, role_type)
comment "产能人才资源管理看板"
partition by range(dt)
(
     partition p2023 values [("2023-01-01"), ("2024-01-01"))
    ,partition p2024 values [("2024-01-01"), ("2025-01-01"))
    ,partition p2025 values [("2025-01-01"), ("2026-01-01"))
    ,partition p2026 values [("2026-01-01"), ("2027-01-01"))
    ,partition p2027 values [("2027-01-01"), ("2028-01-01"))
    ,partition p2028 values [("2028-01-01"), ("2029-01-01"))
    ,partition p2029 values [("2029-01-01"), ("2030-01-01"))
)
distributed by hash(site_id, role_type) buckets 3
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;