drop table if exists ads.ads_book_level_info_df;
create table ads.ads_book_level_info_df (
     dt            date           not null    comment "分区"
    ,book_id       bigint(20)     not null    comment "书籍id,无siteid"
    ,site_id       varchar(20)    not null    comment "语言id"
    ,book_level    varchar(50)                comment "书籍等级"
    ,etl_time      datetime                   comment "etl时间"
 )
primary key (dt, book_id, site_id)
comment "长篇孵化-书籍等级"
partition by date_trunc('month',dt)
distributed by hash (dt, book_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;