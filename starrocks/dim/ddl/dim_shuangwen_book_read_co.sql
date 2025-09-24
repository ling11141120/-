drop table if exists dim.dim_shuangwen_book_read_consume_info;
create table if not exists dim.dim_shuangwen_book_read_consume_info (
     product_id              int(11)       not null                     comment "产品id"
    ,book_id                 bigint(20)    not null                     comment "书籍id"
    ,yt                      date not                                   comment "日期"
    ,book_name               varchar(255)                               comment "书籍名称"
    ,create_time             datetime                                   comment "创建时间"
    ,update_time             datetime                                   comment "更新时间"
    ,book_nature             varchar(255)                               comment "书籍来源 1:机翻 2:人工 3:原创 4:cp 5:原创拆章 6:翻译拆章 7:原创图书 8:定制文 9:cp翻译 0:未知"
    ,sign_type               int(11)                                    comment "签约类型  0: 买断（独家）;1: A签(独家);2: B签(非独家);3:解约; -1:未签约"
    ,channel                 int(11)                                    comment "频道0:其他 1:女频 2:男频 9:图书 -99:其他"
    ,is_full                 tinyint(4)                                 comment "是否完本 0 是连载 6是 完本 (有的书籍表中1 是完本）"
    ,site_id                 int(11)                                    comment "语言id"
    ,site_id2                int(11)                                    comment "书籍语言使用site_id2字段;默认 繁体:333 简体:777;两者书籍会有重复部分 "
    ,price_per_thousand      int(11)                                    comment "千字价格"
    ,new_cid                 int(11)                                    comment "书籍分类id"
    ,new_cname               varchar(100)                               comment "分类名称"
    ,sexy2                   int(11)                                    comment "书籍上架、下架判断:字段来源novel_book; Sexy2 >= 4 为下架状态，<4 为上架,其中,Sexy涉黄等级 4软下架 5强制下架 ,0 未涉黄;其他具体数字只是涉黄的分级，没有太多参考意义"
    ,normal_chapter_num_f    int(11)                                    comment "发布总章节数"
    ,build_time              datetime                                   comment "书籍上传时间"
    ,block_name              varchar(50)                                comment "内容方"
    ,font_length             int(11)                                    comment "书籍总字数（包含未发布的）"
    ,book_code               varchar(50)                                comment "书籍代号"
    ,full_time               datetime                                   comment "完本时间"
    ,languageid              int(11)                                    comment "语言"
    ,public_fontlength       int(11)                                    comment "发布的书籍字数(来源nove_book的length)"
    ,author_id               bigint(20)                                 comment "作者Id"
    ,author_name             varchar(500)                               comment "作者名称"
    ,free_chapternum         int(11)                                    comment "免费章节数(已更新）"
    ,latest_update_time      datetime                                   comment "章节最新更新时间"
    ,total_chapter_num       int(11)                                    comment "总章节数"
    ,speed_chapter_num       int(11)                                    comment "超点章节数" 
    ,is_put_down             int(11)                                    comment "是否上架"
    ,put_down_level          int(11)                                    comment "下架等级"
    ,pen_name                varchar(65533)                             comment "作者笔名"
    ,author_type             varchar(65533)                             comment "作者类型"
    ,etl_time                datetime      default current_timestamp    comment "etl清洗时间"
    ,index index_product_id (product_id) using bitmap                   comment 'index_product_id'
)
primary key(product_id, book_id)
comment "爽文库阅读消耗书籍信息表"
distributed by hash(product_id, book_id) buckets 20 
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "create_time, book_id, site_id2",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;