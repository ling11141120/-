drop table if exists ads.ads_sr_usr_ben_statu;
create table ads.ads_sr_usr_ben_statu (
     dt                         date          not null     comment "日期"
    ,user_id                    bigint(20)    not null     comment "用户id"
    ,ben_type                   int(11)       not null     comment "权益类型(810svip,840新福利包,850vip)"
    ,rel_ord                    varchar(200)               comment "关联订单"
    ,ben_ocr_tm                 datetime                   comment "权益生效时间"
    ,ben_end_tm                 datetime                   comment "权益失效时间"
    ,h_alc_amt                  decimal(10,4)              comment "每小时分摊金额"
    ,ulk_chap_num               int(11)                    comment "解锁章节字数"
)
primary key (dt, user_id)
comment "海阅读用户权益状态表"
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