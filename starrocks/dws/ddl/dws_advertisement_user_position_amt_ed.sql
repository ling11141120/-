drop table if exists dws.dws_advertisement_user_position_amt_ed;
create table dws.dws_advertisement_user_position_amt_ed (
     dt                   date           not null                     comment "事件时间"
    ,md5_key              varchar(32)    not null                     comment "md5唯一键"
    ,product_id           int(11)        not null                     comment "产品id"
    ,user_id              bigint(20)                                  comment "用户id"
    ,core                 int(11)                                     comment "core"
    ,mt                   int(11)                                     comment "终端"
    ,current_language2    varchar(255)                                comment "投放语言"
    ,appver               varchar(255)                                comment "版本号"
    ,ad_show_type         int(11)                                     comment "广告类型"
    ,positions            int(11)                                     comment "广告位置"
    ,ads_name             varchar(255)                                comment "广告来源-广告平台 (adomob,topon,max)"
    ,ads_source           varchar(655)                                comment "admob广告源,可通过这个反推是哪家具体的广告"
    ,main_strategy_id     varchar(255)                                comment "主策略id"
    ,event_strategy_id    varchar(255)                                comment "策略id"
    ,programme_id         varchar(1000)                               comment "频道方案id"
    ,book_id              bigint(20)                                  comment "书籍id/剧id"
    ,fst_amt              decimal(38, 9)                              comment "首次广告收益"
    ,lst_amt              decimal(38, 9)                              comment "末次广告收益"
    ,cnt                  int(11)                                     comment "次数"
    ,amt                  decimal(38, 9)                              comment "广告收益"
    ,etl_tm               datetime       default current_timestamp    comment "清洗时间"
)
primary key(dt, md5_key)
comment "阅读及海外短剧--分广告类型、位置用户粒度广告展现收益表（海外短剧暂时没有分位置）"
partition by date_trunc("month", dt)
distributed by hash(dt, md5_key) buckets 5
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;
