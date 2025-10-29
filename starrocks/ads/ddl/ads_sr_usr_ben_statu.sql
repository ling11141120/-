drop table if exists ads.ads_bi_sr_usr_ben_statu;
create table ads.ads_bi_sr_usr_ben_statu (
     dt                         date          not null     comment "日期"
    ,user_id                    bigint(20)    not null     comment "用户id"
    ,ben_type                   int(11)       not null     comment "权益类型"
    ,ben_type_name              varchar(20)                comment "权益类型名称"
    ,rel_ord                    varchar(500)               comment "关联订单"
    ,ben_ocr_tm                 datetime                   comment "权益生效时间"
    ,ben_end_tm                 datetime                   comment "权益失效时间"
    ,h_alc_amt                  decimal(10,4)              comment "每小时分摊金额"
    ,ulk_chap_num               int(11)                    comment "解锁章节字数"
)
primary key (dt, user_id, ben_type)
comment "海阅用户权益状态表"
partition by date_trunc('day', dt)
distributed by hash(dt, user_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;