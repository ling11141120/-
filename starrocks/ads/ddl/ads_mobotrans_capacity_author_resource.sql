DROP TABLE IF EXISTS ads.ads_mobotrans_capacity_author_resource;
CREATE TABLE IF NOT EXISTS ads.ads_mobotrans_capacity_author_resource (
     dt                     date                    not null        comment "年分区字段：日期"
    ,site_id                int(11)                 not null        comment "语言id"
    ,author_id              bigint(20)              not null        comment "译员id"
    ,role_type              int(11)                 not null        comment "译员角色"
    ,pen_name               varchar(65533)          null            comment "笔名"
    ,real_name              varchar(65533)          null            comment "译员真实姓名"
    ,occupation             int(11)                 null            comment "职业状态：0其他   1学生   3教师   4自由职业 "
    ,work_type              smallint(6)             null            comment "全/兼职：0全职 1兼职"
    ,country                varchar(65533)          null            comment "国籍"
    ,phone                  varchar(65533)          null            comment "电话"
    ,qq                     varchar(65533)          null            comment "qq"
    ,e_mail                 varchar(65533)          null            comment "邮箱"
    ,avg_score              decimal(18, 4)          null            comment "质量评分"
    ,delay_rate             decimal(18, 4)          null            comment "超时占比"
    ,low_score_rate         decimal(18, 4)          null            comment "低分占比"
    ,alter_err_rate         decimal(18, 4)          null            comment "修改比例异常占比"
    ,font_length_7d         bigint(20)              null            comment "近7天产能"
    ,avg_font_length_30d    bigint(20)              null            comment "近30天日均产能"
    ,font_length_curmonth   bigint(20)              null            comment "本月产能"
    ,latest_remuneration    datetime                null            comment "最近提稿时间"
    ,median_num             bigint(20)              null            comment "近90天更新字数中位数"
    ,first_audit            int(11)                 null            comment "是否通过初译(-1 无记录 0、未审核，1、通过，2、不通过 3再修改 4 加译)"
    ,work_status            smallint(6)             null            comment "签约合作状态（1解约；2休眠；3合作）"
    ,remarks                varchar(65533)          null            comment "人员合作备注"
    ,etl_time               datetime                not null        comment "数据清洗时间"
    ,index index_site_id (site_id)                  using bitmap    comment '语言id索引'
    ,index index_role_type (role_type)              using bitmap    comment '译员角色索引'
)
primary key(dt, site_id, author_id, role_type)
comment "产能人才资源库"
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
distributed by hash(site_id, author_id, role_type) buckets 3
properties (
    "replication_num" = "3"
    ,"bloom_filter_columns" = "author_id"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;