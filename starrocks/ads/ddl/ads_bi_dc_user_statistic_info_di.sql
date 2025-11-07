drop table if exists ads.ads_bi_dc_user_statistic_info_di;
create table ads.ads_bi_dc_user_statistic_info_di (
     dt                  date              not null comment "统计日期"
    ,md5_key             varchar(65533)    not null comment "主键md5key"
    ,product_id          int(11)                    comment "产品id"
    ,dc_code             bigint(20)                 comment "所属机构"
    ,dc_account          bigint(20)                 comment "机构投放账号"
    ,core                int(11)                    comment "corever"
    ,mt                  int(11)                    comment "终端"
    ,user_type           int(11)                    comment "用户类型:1 新用户 0老用户"
    ,new_user_count      int(11)                    comment "新增用户数"
    ,pay_user_count      int(11)                    comment "新增用户数"
    ,pay_order_count     int(11)                    comment "订单数"
    ,pay_order_amount    decimal(18, 4)             comment "订单金额"
    ,etl_tm              datetime          not null comment "数据清洗时间"
)
primary key(dt, md5_key)
comment "分销机构用户统计报表"
partition by date_trunc('month',dt)
distributed by hash(dt, md5_key) buckets 3
properties (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
)
;