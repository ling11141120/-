drop table if exists ads.ads_ad_new_user_view_retention_df;
create table ads.ads_ad_new_user_view_retention_df (
     dt                  date            not null    comment "分区日期"
    ,md5_key             varchar(50)     not null    comment "md5组合主键"
    ,product_id          int             not null    comment "产品id"
    ,project_id          int             not null    comment "海剧海阅标识"
    ,ad_id               varchar(750)    not null    comment "广告id"
    ,new_user_count      bigint                      comment "新用户数"
    ,view_time           decimal(16,2)               comment "观看剧集/书籍时长-单位秒"
    ,view_unit_cnt       bigint                      comment "观看剧集/书籍集数"
    ,view_content_cnt    bigint                      comment "观看剧集/书籍部数"
    ,d1_retention_num    bigint                      comment "d1留存人数"
    ,d2_retention_num    bigint                      comment "d2留存人数"
    ,d3_retention_num    bigint                      comment "d3留存人数"
    ,d4_retention_num    bigint                      comment "d4留存人数"
    ,d5_retention_num    bigint                      comment "d5留存人数"
    ,d6_retention_num    bigint                      comment "d6留存人数"
    ,d7_retention_num    bigint                      comment "d7留存人数"
    ,etl_tm              datetime                    comment "清洗时间"
)
primary key (dt, md5_key)
comment "广告域-新用户观看，留存统计表"
partition by date_trunc("month", dt)
distributed by hash(dt, md5_key)
properties(
     "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "lz4"
    ,"partition_live_number" = "36"
    ,"bloom_filter_columns" = "ad_id"
)
;

