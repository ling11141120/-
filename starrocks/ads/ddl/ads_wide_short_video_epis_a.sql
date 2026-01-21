drop table if exists ads.ads_wide_short_video_epis_a;
create table ads.ads_wide_short_video_epis_a (
     dt                        date           not null comment "统计日期，昨日"
    ,series_id                 bigint         not null comment "剧id"
    ,epis_num                  smallint       not null comment "剧集序号"
    ,epis_id                   bigint                  comment "最新剧集id"
    ,series_name               varchar(200)            comment "剧名名称"
    ,series_language           smallint                comment "剧语言"
    ,series_tp                 varchar(90)             comment "短剧分类"
    ,cooperate_type            smallint                comment "合作方式(1买断、2分成、3保底分成)"
    ,series_code               varchar(20)             comment "代码"
    ,is_free                   smallint                comment "是否免费 1：是 0： 否"
    ,epis_length               bigint                  comment "视频长度"
    ,epis_amount               bigint                  comment "剧集价位(代币/赠币)"
    ,consume_user_bitmap       bitmap                  comment "累计消费用户bitmap"
    ,consume_amt               decimal(17, 7)          comment "总消耗数量"
    ,consume_cnt               bigint                  comment "总消耗次数"
    ,consume_money_user_bitmap bitmap                  comment "累计观看币消耗用户bitmap"
    ,consume_money_amt         decimal(17, 7)          comment "累计观看币消耗数量"
    ,consume_money_cnt         bigint                  comment "累计观看币消耗次数"
    ,consume_cert_user_bitmap  bitmap                  comment "累计观看券消耗用户bitmap"
    ,consume_cert_amt          decimal(17, 7)          comment "累计观看券消耗数量"
    ,consume_cert_cnt          bigint                  comment "累计观看券消耗次数"
    ,watch_user_bitmap         bitmap                  comment "累计观看用户bitmap"
    ,watch_cnt                 bigint                  comment "剧集有效观看数据(一次观看开始、结束各产生一条，计算次数需要除以2并上浮取整,值会有误差)"
    ,is_like_user_bitmap       bitmap                  comment "累计点赞用户bitmap"
    ,etl_time                  datetime       not null comment "数据清洗时间"
)
primary key(dt, series_id, epis_num)
comment "海外短剧剧集粒度业务累计指标表"
partition by date_trunc('day', dt)
distributed by hash(dt, series_id, epis_num)
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "series_tp",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;