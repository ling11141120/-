drop table if exists dim.dim_book_chapter_info_di;
create table dim.dim_book_chapter_info_di (
    dt                  date          not null    comment "日期"
   ,book_id             bigint(20)    not null    comment "书籍id"
   ,site_id             int(11)       not null    comment "语言id"
   ,serial_number       int(11)       not null    comment "章节序号"
   ,chapter_id          bigint(20)    not null    comment "章节id"
   ,chapter_name        varchar(65533)            comment "章节名称"
   ,chapter_length      int(11)                   comment "章节字数"
   ,public_time         datetime                  comment "发布时间"
   ,timer               datetime                  comment "更新时间（例如章节字数有发生变化，时间会更新）"
   ,book_name           varchar(765)              comment "书籍名称"
   ,new_cid             int(11)                   comment "书籍分类id"
   ,new_cname           varchar(100)              comment "分类名称"
   ,language_id         int(11)                   comment "书籍语言"
   ,is_full             tinyint(4)                comment "是否完本  0:连载（未完本） 1：完本 3:完本打包队列 4:完本打包成功 5：完本打包失败 6：完本不打包 7：图书打包 "
   ,sexy2               int(11)                   comment "涉黄等级"
   ,Free_Chapter_Num    int(11)                   comment "是否收费章节，1：是 0：否"
   ,create_time         datetime                  comment "创建时间"
   ,if_delete           int                       comment "数据是否被删除，1删除，0未删除"
   ,etl_time            datetime                  comment "数据更新时间"
   ,index index_site_id (site_id) using bitmap    comment "index_site_id"
)
primary key(book_id, site_id, serial_number, chapter_id)
comment "书籍章节信息表"
partition by date_trunc("month",dt)
distributed by hash(book_id, site_id, serial_number, chapter_id)
properties (
    "replication_num" = "3"
   ,"bloom_filter_columns" = "book_id"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;