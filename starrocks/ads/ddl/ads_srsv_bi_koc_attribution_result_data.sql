drop table if exists tmp.ads_srsv_bi_koc_attribution_result_data;
create table tmp.ads_srsv_bi_koc_attribution_result_data (
     dt                     date           not null comment "统计日期"
    ,product_id             int            not null comment "产品id"
    ,ad_id                  varchar(755)   not null comment "koc的广告ID"
    ,is_new_user            int            not null comment "新老用户类型，1 新用户，0 老用户"
    ,reg_country            varchar(50)    not null comment "注册国家"
    ,project_tp             int            not null comment "1：海阅 2：海剧"
    ,book_id                bigint                  comment "书籍id"
    ,mt                     int            not null comment "终端"
    ,core                   int            not null comment "Core"
    ,source_chl             string                  comment "媒体,写死koc"
    ,chl                    varchar(755)   not null comment "渠道"
    ,current_language       int                     comment "投放语言"
    ,koc_code               string                  comment "口令,来源于koc_text"
    ,business_mode          varchar(255)            comment "业务模式"
    ,product                varchar(255)            comment "产品"
    ,institution_id         string                  comment "机构id"
    ,star_id                int                     comment "达人id"
    ,distributor            varchar(755)            comment "分销商"
    ,country_type           int                     comment "国家地区 0无 1国内  2国外"
    ,dev_unt                int                     comment "激活用户数(新用户数+活跃用户数),不去重"
    ,watch_chapters         bitmap                  comment "观看的章节"
    ,watch_user_id          bitmap                  comment "观看的用户"
    ,first_consume_user_num int                     comment "观看至付费节点人数"
    ,pay_user_num           int                     comment "付费用户数"
    ,order_num              int                     comment "订单数"
    ,koc_amt                decimal(16, 4)          comment "充值金额"
    ,koc_amt_after          decimal(16, 4)          comment "扣除渠道费之后的充值金额"
    ,real_income            decimal(16, 4)          comment "收入金额 机构和达人可见的收入金额"
    ,real_distrib_income    decimal(16, 4)          comment "实际分销金额"
    ,etl_tm                 datetime                comment "清洗时间"
)
primary key(dt, product_id, ad_id, is_new_user, reg_country)
comment "海阅海剧，koc用户数据报表"
partition by range(dt)
(partition p202601 values less than ('2026-02-01'))
distributed by hash(dt, product_id, ad_id) buckets 3
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;