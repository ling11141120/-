drop table if exists dws.dws_ad_product_user_income_h;
create table dws.dws_ad_product_user_income_h (
     dt         datetime       not null                  comment "日期（北京时间-13小时）"
    ,product_id int(11)        not null                  comment "产品id"
    ,core       int(11)        not null                  comment "core"
    ,mt         int(11)        not null                  comment "平台"
    ,user_id    bigint(20)     not null                  comment "用户id"
    ,ads_name   varchar(255)   not null                  comment "广告来源"
    ,amount     decimal(38, 9)                           comment "广告收益"
    ,etl_tm     datetime       default current_timestamp comment "清洗时间"
)
primary key(dt, product_id, core, mt, user_id, ads_name)
comment "广告域-产品用户广告收益-小时统计"
partition by date_trunc('day', dt)
distributed by hash(user_id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;