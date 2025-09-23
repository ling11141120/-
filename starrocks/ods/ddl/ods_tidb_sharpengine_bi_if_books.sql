----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_bi_if_books
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_bi.if_books
-- 来源负责： 
-- 采集工具： 极光-定时链路
-- 开发人： qhr
-- 创建日期： 2025-09-23
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_bi_if_books;
CREATE TABLE ods.ods_tidb_sharpengine_bi_if_books (
      id                     BIGINT(20)    NOT NULL    COMMENT ""
     ,productid              INT(11)       DEFAULT "0" COMMENT ""
     ,bookid                 BIGINT(20)    DEFAULT "1" COMMENT ""
     ,newcid                 INT(11)       DEFAULT "0" COMMENT ""
     ,bookname               VARCHAR(128)              COMMENT ""
     ,authorname             VARCHAR(128)              COMMENT ""
     ,channel                INT(11)       DEFAULT "0" COMMENT ""
     ,booknature             INT(11)       DEFAULT "0" COMMENT ""
     ,Length                 INT(11)                   COMMENT ""
     ,bookno                 VARCHAR(1000)             COMMENT "书号"
     ,booknoseries           VARCHAR(128)              COMMENT "书号系列"
     ,SpeedChapterNum        INT(11)       DEFAULT "0" COMMENT "超前点播章节数"
     ,BookReaderPush         INT(11)       DEFAULT "0" COMMENT "是否设置书籍推送 0=否|1=是"
     ,PricePerThousandCfg    INT(11)       DEFAULT "0" COMMENT "是否设置阶梯涨价 0=否|1=是"
     ,PublishLength          INT(11)       DEFAULT "0" COMMENT "发布字数"
     ,IsFull                 INT(11)       DEFAULT "0" COMMENT "是否完本 0=否|1=是"
     ,RemunerationTime       VARCHAR(50)               COMMENT "首次翻译日期"
     ,PublishChapterNum      INT(11)       DEFAULT "0" COMMENT "已发布章节数"
     ,IosReduceNum           INT(11)       DEFAULT "0" COMMENT "IOS前N章降价开关 0=关闭|1=开启"
     ,AndroidReduceNum       INT(11)       DEFAULT "0" COMMENT "安卓前N章降价开关 0=关闭|1=开启"
     ,FreeChapterNum         INT(11)       DEFAULT "0" COMMENT "免费章节数配置"
     ,VipChapterNo           INT(11)       DEFAULT "0" COMMENT "首个Vip章节号"
     ,BookLanguage           INT(11)       DEFAULT "0" COMMENT "书籍语言"
     ,BookLanguageCode       VARCHAR(300)              COMMENT "书籍语言编码"
     ,PricePerThousandCfgTag INT(11)       DEFAULT "0" COMMENT "是否设置阶梯涨价 0=否|1=是"
     ,IosReduceNumTag        INT(11)       DEFAULT "0" COMMENT "IOS前N章降价开关 0=关闭|1=开启"
     ,AndroidReduceNumTag    INT(11)       DEFAULT "0" COMMENT "安卓前N章降价开关 0=关闭|1=开启"
     ,PlanContentType        INT(11)                   COMMENT "方案内容类型 1001=女频现言|1002=女频古言|1003=女频狼人|1004=男频|2001=女频译制|2002=女频本土|2003=男频译制|2004=男频本土"
     ,newcidname             VARCHAR(200)              COMMENT "分类名称"
     ,sr_createtime          DATETIME                  COMMENT "sr入库时间"
     ,sr_updatetime          DATETIME                  COMMENT "sr更新时间"
) ENGINE=OLAP
PRIMARY KEY(id)
COMMENT "内容域--书籍信息表"
DISTRIBUTED BY HASH(id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "bookid",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;