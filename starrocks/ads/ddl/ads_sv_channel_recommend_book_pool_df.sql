drop table if exists ads.ads_sv_channel_recommend_book_pool_df;
create table ads.ads_sv_channel_recommend_book_pool_df (
    language_id              int(11)        not null                     comment "语言id（与产品语言体系对应）"
   ,book_id                  bigint(20)     not null                     comment "书籍id"
   ,product_id               int(11)                                     comment "产品id"
   ,book_name                varchar(500)                                comment "书籍名称"
   ,book_code                varchar(50)                                 comment "书籍代号"
   ,channel                  int(11)                                     comment "频道 0:其他 1:女频 2:男频 9:图书"
   ,category_name            varchar(100)                                comment "分类名称"
   ,build_time               datetime                                    comment "书籍上架时间"
   ,is_original_pool         tinyint(4)                                  comment "是否原书池 1:是 0:否"
   ,is_recommend_pool        tinyint(4)                                  comment "是否推荐池 1:是 0:否"
   ,consume_amount_30d       bigint(20)                                  comment "近30天总消费金额"
   ,consume_rank_30d         int(11)                                     comment "近30天总消费排名"
   ,consume_amount_60d       bigint(20)                                  comment "近60天总消费金额"
   ,consume_rank_60d         int(11)                                     comment "近60天总消费排名"
   ,ad_income_30d            decimal(38, 9)                              comment "近30天广告收益"
   ,ad_income_60d            decimal(38, 9)                              comment "近60天广告收益"
   ,has_mutex                tinyint(4)                                  comment "是否有互斥 1:是 0:否"
   ,is_main_push_mutex       tinyint(4)                                  comment "是否互斥主推版本 1:是 0:否"
   ,etl_time                 datetime       default current_timestamp    comment "etl清洗时间"
   ,index index_language_id (language_id) using bitmap comment "语言id索引"
)
primary key(language_id, book_id)
comment "海剧频道推荐算法书池全量快照表，包含原书池与总消费排名前1000推荐池的并集，仅保存最新结果"
distributed by hash(language_id, book_id) buckets 3
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
);
