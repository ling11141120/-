DROP TABLE IF EXISTS dim.dim_shuangwen_book_read_consume_info;
CREATE TABLE IF NOT EXISTS dim.dim_shuangwen_book_read_consume_info (
     product_id           INT(11)      NOT NULL                           COMMENT "产品id"
    ,book_id              BIGINT(20)   NOT NULL                           COMMENT "书籍id"
    ,yt                   DATE         NOT NULL                           COMMENT "日期"
    ,book_name            VARCHAR(255)                                    COMMENT "书籍名称"
    ,create_time          DATETIME                                        COMMENT "创建时间"
    ,update_time          DATETIME                                        COMMENT "更新时间"
    ,book_nature          VARCHAR(255)                                    COMMENT "书籍来源 1：机翻 2：人工 3：原创 4：cp 5：原创拆章 6：翻译拆章 7：原创图书 8：定制文 9：cp翻译 0：未知"
    ,sign_type            INT(11)                                         COMMENT "签约类型  0： 买断（独家）；1： A签（独家）；2： B签（非独家）；3：解约； -1：未签约"
    ,channel              INT(11)                                         COMMENT "频道0:其他 1:女频 2：男频 9：图书 -99：其他"
    ,is_full              TINYINT(4)                                      COMMENT "是否完本 0 是连载 6是 完本 （有的书籍表中1 是完本）"
    ,site_id              INT(11)                                         COMMENT "语言id"
    ,site_id2             INT(11)                                         COMMENT "书籍语言使用site_id2字段；默认 繁体：333 简体：777；两者书籍会有重复部分 "
    ,price_per_thousand   INT(11)                                         COMMENT "千字价格"
    ,new_cid              INT(11)                                         COMMENT "书籍分类id"
    ,new_cname            VARCHAR(100)                                    COMMENT "分类名称"
    ,sexy2                INT(11)                                         COMMENT "书籍上架、下架判断：字段来源novel_book; Sexy2 >= 4 为下架状态，<4 为上架，其中，Sexy涉黄等级 4软下架 5强制下架 ,0 未涉黄;其他具体数字只是涉黄的分级，没有太多参考意义"
    ,normal_chapter_num_f INT(11)                                         COMMENT "发布总章节数"
    ,build_time           DATETIME                                        COMMENT "书籍上传时间"
    ,block_name           VARCHAR(50)                                     COMMENT "内容方"
    ,font_length          INT(11)                                         COMMENT "书籍总字数（包含未发布的）"
    ,book_code            VARCHAR(50)                                     COMMENT "书籍代号"
    ,full_time            DATETIME                                        COMMENT "完本时间"
    ,languageid           INT(11)                                         COMMENT "语言"
    ,public_fontlength    INT(11)                                         COMMENT "发布的书籍字数（来源nove_book的length)"
    ,author_id            BIGINT(20)                                      COMMENT "作者Id"
    ,author_name          VARCHAR(500)                                    COMMENT "作者名称"
    ,Free_ChapterNum      INT(11)                                         COMMENT "免费章节数(已更新）"
    ,latest_update_time   DATETIME                                        COMMENT "章节最新更新时间"
    ,total_chapter_num    INT(11)                                         COMMENT "总章节数"
    ,speed_chapter_num    INT(11)                                         COMMENT "超点章节数"
    ,is_put_down          INT(11)                                         COMMENT "是否上架"
    ,put_down_level       INT(11)                                         COMMENT "下架等级"
    ,pen_name             STRING                                          COMMENT "作者笔名"
    ,author_type          STRING                                          COMMENT "作者类型"
    ,etl_time             DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT 'index_product_id'
)
PRIMARY KEY(product_id, book_id)
COMMENT "爽文库阅读消耗书籍信息表"
DISTRIBUTED BY HASH(product_id, book_id) BUCKETS 20
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "create_time, book_id, site_id2",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;