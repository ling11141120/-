drop table if exists ads_content_author_book_capacity_stat_di;
create table if not exists ads_content_author_book_capacity_stat_di (
    md5_key             varchar(65533)      not null     comment "md5_key唯一值"
   ,dt                  date                not null     comment "日期"
   ,author_id           varchar(65533)      not null     comment "译员id"
   ,book_id             bigint(20)          not null     comment "书籍id"
   ,language_id         int(11)             not null     comment "目标语言id"
   ,language_name       varchar(150)        null         comment "目标语言名称"
   ,type_id             int(11)             not null     comment "类型: 1 短剧翻译、2 短剧审核抽查&初译审核、3 测试稿审核、4 素材翻译、5 词条翻译、6 词典字数"
   ,pen_name            varchar(200)        null         comment "译名"
   ,real_name           varchar(200)        null         comment "姓名"
   ,book_name           varchar(500)        null         comment "书名"
   ,capacity_value      decimal(20,2)       null         comment "产能"
   ,etl_time            datetime            null         comment "数据生成时间"
)
primary key(md5_key)
comment "内容域--译员书籍语言--按天统计字数"
distributed by hash(md5_key) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, type_id, book_id, language_id, author_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
);