drop table if exists ads.ads_bi_bib_usr_dlg_anal;
create table  ads.ads_bi_bib_usr_dlg_anal (
     dt              date       not null    comment "数据日期"
    ,usr_id          bigint     not null    comment "用户Id"
    ,ust             int                    comment "用户活跃时长"
    ,dlg_num_d       bigint                 comment "当日对话次数"
    ,etl_time        datetime               comment "数据清洗时间"
)
primary key (dt, usr_id)
comment "BI-圣经用户对话分析"
PARTITION BY DATE_TRUNC("month",dt)
DISTRIBUTED BY HASH (dt)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;