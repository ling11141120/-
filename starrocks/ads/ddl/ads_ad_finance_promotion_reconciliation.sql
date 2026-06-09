create table if not exists ads.ads_ad_finance_promotion_reconciliation (
     dt                  date           not null comment "分区日期"
    ,level2              int                     comment "二级代理商id"
    ,level2_name         varchar(255)            comment "二级代理商名称"
    ,fb_account          varchar(100)            comment "账号id"
    ,country             varchar(50)             comment "国家"
    ,company_id          int                     comment "主体公司id"
    ,company_name        varchar(255)            comment "主体公司名称"
    ,account_source_id   int                     comment "账号来源id"
    ,account_source_name varchar(255)            comment "账号来源名称"
    ,fb_account_name     varchar(255)            comment "账号名称"
    ,product_id          int                     comment "产品id/语言id"
    ,mt                  int                     comment "平台"
    ,core                int                     comment "core"
    ,spend               decimal(12, 2)          comment "花费"
    ,ad_optimizer_uid    varchar(255)            comment "优化师工号"
    ,ads_optimizer       varchar(255)            comment "优化师名称"
    ,etl_time            datetime                comment "etl时间"
)
duplicate key(dt, level2)
comment "广告-财务推广对账"
distributed by hash(dt, level2) buckets 30
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
