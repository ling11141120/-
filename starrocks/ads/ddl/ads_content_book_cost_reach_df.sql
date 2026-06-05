drop table if exists ads.ads_content_book_cost_reach_df;
create table ads.ads_content_book_cost_reach_df (
     dt                  date             not null comment "日期"
    ,book_id             bigint           not null comment "书籍id"
    ,site_id             int              not null comment "语言id"
    ,total_cost_amount   decimal(16, 2)            comment "累计花费"
    ,avg_3d_cost_amount  decimal(16, 2)            comment "近三日日均花费"
    ,today_amount        decimal(16, 2)            comment "当日花费，口径为d0收入"
    ,today_std_amount    decimal(16, 2)            comment "当日标准花费"
    ,d0_reach_rate       decimal(16, 4)            comment "d0达标率"
    ,etl_tm              datetime                  comment "清洗时间"
)
primary key(dt, book_id, site_id)
comment "内容域-孵化书籍花费与d0达标率"
partition by date_trunc("month", dt)
distributed by hash(dt, book_id, site_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;