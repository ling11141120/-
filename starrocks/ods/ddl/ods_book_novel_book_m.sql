----------------------------------------------------------------
-- 目标表： ods.ods_book_novel_book_m
-- 来源实例： old_tidb_source
-- 来源表： 
--        readernovel_tidb_fr.novel_book
--        readernovel_tidb_pt.novel_book
--        readernovel_tidb_ft.novel_book
--        readernovel_tidb_en.novel_book
--        readernovel_tidb_ru.novel_book
--        readernovel_tidb_sp.novel_book
--        readernovel_tidb_jp.novel_book
--        readernovel_tidb_id.novel_book
--        readernovel_tidb_th.novel_book
--        readernovel_tidb_and2.novel_book
--        readernovel_tidb_cd2.novel_book
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2023-06-15
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_book_novel_book_m;
CREATE TABLE ods.ods_book_novel_book_m (
     productid               INT(11)        NOT NULL                  COMMENT "产品id"
    ,BookID                  BIGINT(20)     NOT NULL                  COMMENT "书籍id"
    ,yt                      DATE           NOT NULL                  COMMENT "BuildTime年分区"
    ,SiteID                  INT(11)                                  COMMENT "语言id"
    ,CID                     INT(11)                                  COMMENT "分类id"
    ,CName                   VARCHAR(100)                             COMMENT "分类名称"
    ,BookName                VARCHAR(300)                             COMMENT "书名"
    ,AuthorName              VARCHAR(100)                             COMMENT "作者名字"
    ,Length                  INT(11)                                  COMMENT "书籍字数"
    ,UpdateTime              DATETIME                                 COMMENT "更新时间"
    ,LatestUpdateTime        DATETIME                                 COMMENT "章节最新更新时间"
    ,UpdateChapterID         BIGINT(20)                               COMMENT "最后更新的章节Id"
    ,UpdateChapterName       VARCHAR(512)                             COMMENT "更新后章节名字"
    ,LatestUpdateChapterName VARCHAR(512)                             COMMENT "最新更新的章节名字"
    ,ImgSrc                  VARCHAR(250)                             COMMENT "图片地址(和阅读)"
    ,Introduce               VARCHAR(65533)                           COMMENT "简介"
    ,Status                  INT(11)                                  COMMENT "书籍状态"
    ,BuildTime               DATETIME                                 COMMENT "书籍上传时间"
    ,normalchapternum        INT(11)                                  COMMENT "章节数"
    ,vipchapternum           INT(11)        NOT NULL                  COMMENT "出版图书总章节数"
    ,normalchapternum_f      INT(11)                                  COMMENT "发布章节数"
    ,vipchapternum_f         INT(11)        NOT NULL                  COMMENT "出版图书总章节数"
    ,CollectCount            INT(11)        NOT NULL                  COMMENT "vip章节数"
    ,AuthorID                BIGINT(20)     NOT NULL                  COMMENT "作者Id"
    ,Size                    INT(11)        NOT NULL                  COMMENT "大小"
    ,isFull                  INT(11)                                  COMMENT "完本状态 0连载 1合作商通知完本 3完本打包队列 4打包成功 5打包失败 6完本不打包 7图书打包"
    ,Channel                 INT(11)                                  COMMENT "渠道"
    ,PricePerThousand        INT(11)        NOT NULL                  COMMENT "千字价"
    ,Source                  INT(11)        NOT NULL                  COMMENT "来源 0:盗版 1:正版"
    ,NewCID                  INT(11)                                  COMMENT "分类id"
    ,NewCName                VARCHAR(100)                             COMMENT "分类名称"
    ,Sexy2                   INT(11)                                  COMMENT "涉黄等级"
    ,FullPrice               INT(11)                                  COMMENT "完本价格"
    ,VoiceChapterNum         INT(11)        NOT NULL                  COMMENT "音频章节数目"
    ,url                     VARCHAR(512)                             COMMENT "百度百科链接地址"
    ,isEpub                  TINYINT(4)                               COMMENT "是否为出版图书"
    ,epub_path               VARCHAR(500)                             COMMENT "出版图书下载地址"
    ,epub_price              INT(11)                                  COMMENT "出版图书价格(阅币)"
    ,FreeChapterNum          INT(11)                                  COMMENT "免费章节数"
    ,BookNo                  BIGINT(20)     NOT NULL                  COMMENT "书号"
    ,VoiceBookId             BIGINT(20)                               COMMENT "关联有声书籍Id"
    ,IsEighteen              TINYINT(4)     NOT NULL                  COMMENT "是否18禁"
    ,Alias                   VARCHAR(500)                             COMMENT "Tag列表"
    ,NCartoonId              BIGINT(20)                               COMMENT "漫画id"
    ,VCartoonId              BIGINT(20)                               COMMENT "有声漫画id"
    ,Translator              VARCHAR(255)                             COMMENT "翻译者"
    ,Verifier                VARCHAR(255)                             COMMENT "校验者"
    ,ChapterGiftBuyHour      INT(11)        NOT NULL                  COMMENT ""
    ,KeyWord                 VARCHAR(2000)                            COMMENT "SEO关键字"
    ,TitleWord               VARCHAR(2000)                            COMMENT "SEO标题"
    ,DescriptionWord         VARCHAR(2000)                            COMMENT "SEO描述"
    ,Language                INT(11)                                  COMMENT "语言"
    ,FullTime                DATETIME                                 COMMENT "完本时间"
    ,BookNature              TINYINT(4)     NOT NULL                  COMMENT "书籍类型"
    ,IsStop                  TINYINT(4)     NOT NULL                  COMMENT "是否停更"
    ,StopTime                DATETIME                                 COMMENT "停更时间"
    ,SignType                INT(11)                                  COMMENT "签约状态"
    ,row_create_time         DATETIME                                 COMMENT "行创建时间"
    ,StoryType               INT(11)                                  COMMENT "类型  0长篇小说 1短篇小说"
    ,sr_createtime           DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime           DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    ,INDEX index_productid (productid) USING BITMAP                   COMMENT 'index_productid'
    ,INDEX index_siteid (SiteID) USING BITMAP                         COMMENT 'index_siteid'
)
PRIMARY KEY(productid, BookID)
COMMENT "readernovel书籍信息表"
DISTRIBUTED BY HASH(productid, BookID) BUCKETS 20
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "BookID, BuildTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;