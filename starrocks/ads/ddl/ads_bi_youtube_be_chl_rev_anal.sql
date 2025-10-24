drop table if exists ads.ads_bi_youtube_be_chl_rev_anal;
create table if not exists ads.ads_bi_youtube_be_chl_rev_anal (
    dt                    date               not null    comment "日期"
   ,chl_id                varchar(255)       not null    comment "渠道id"
   ,chl_name              varchar(1020)                  comment "渠道名称"
   ,chl_name_api          varchar(1020)                  comment "api获取渠道名称"
   ,ttl_sub_num           bigint                         comment "总订阅人数"
   ,ttl_view_num          bigint                         comment "总观看次数"
   ,d_ttl_rev             decimal(18,2)                  comment "当日总收入"
   ,d_ad_rev              decimal(18,2)                  comment "当日广告收入"
   ,d_mbr_apx_rev         decimal(18,2)                  comment "当日会员近似收入"
   ,d_view_time           bigint                         comment "当日观看时长(单位：分钟)"
   ,d_rev_etl_time        datetime                       comment "当日收入etl时间"
   ,chl_info_etl_time     datetime                       comment "渠道信息etl时间"
)
primary key (dt, chl_id)
comment "BI-youtube后台频道收入分析"
partition by date_trunc("year",dt)
distributed by hash (dt)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;