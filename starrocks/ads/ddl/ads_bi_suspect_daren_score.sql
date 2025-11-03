drop table if exists ads.ads_bi_suspect_star_score;
create table ads.ads_bi_suspect_star_score (
     dt                         date          not null     comment "日期"
    ,user_id                    bigint(20)    not null     comment "用户id"
    ,prj_type                   int(11)                    comment "项目类型"
    ,prj_type_name              varchar(20)                comment "项目类型名称"
    ,avg_view_num               decimal(8,2)               comment "平均观看集数"
    ,payment_method             varchar(100)                comment "支付方式"
    ,tp_prd                     varchar(20)                comment "充值产品"
)
primary key (dt, user_id)
comment "嫌疑达人分值表"
partition by date_trunc('month', dt)
distributed by hash(dt, user_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;