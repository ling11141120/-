----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new
-- 来源实例： old_tidb_source
-- 来源表： 
--        readernovel_tidb_fr.novel_bookcategory_new
--        readernovel_tidb_pt.novel_bookcategory_new
--        readernovel_tidb_ft.novel_bookcategory_new
--        readernovel_tidb_en.novel_bookcategory_new
--        readernovel_tidb_ru.novel_bookcategory_new
--        readernovel_tidb_sp.novel_bookcategory_new
--        readernovel_tidb_jp.novel_bookcategory_new
--        readernovel_tidb_id.novel_bookcategory_new
--        readernovel_tidb_th.novel_bookcategory_new
--        readernovel_tidb_and2.novel_bookcategory_new
--        readernovel_tidb_cd2.novel_bookcategory_new
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2023-06-15
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new;
CREATE TABLE ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new (
     productid       INT(11)        NOT NULL                  COMMENT ""
    ,AutoID          INT(11)        NOT NULL                  COMMENT "自增id"
    ,CID             INT(11)        NOT NULL                  COMMENT "类别id"
    ,Sexy            INT(11)                                  COMMENT "涉黄等级"
    ,CName           VARCHAR(150)                             COMMENT "类别名称"
    ,Sort            INT(11)                                  COMMENT "排序"
    ,CType           INT(11)                                  COMMENT "频道"
    ,KeyWord         VARCHAR(6000)                            COMMENT "SEO 关键字"
    ,TitleWord       VARCHAR(6000)                            COMMENT ""
    ,DescriptionWord VARCHAR(6000)                            COMMENT ""
    ,Cover           VARCHAR(1500)                            COMMENT ""
    ,Language        INT(11)                                  COMMENT ""
    ,NewCover        VARCHAR(1500)                            COMMENT ""
    ,IsDelete        INT(11)        DEFAULT "0"               COMMENT ""
    ,row_update_time DATETIME                                 COMMENT ""
    ,SyncLanguage    VARCHAR(1200)                            COMMENT ""
    ,NewCover2       VARCHAR(1255)                            COMMENT ""
    ,NewCover2Black  VARCHAR(1255)                            COMMENT ""
    ,sr_createtime   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT ""
    ,sr_updatetime   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT ""
)
PRIMARY KEY(productid, AutoID)
DISTRIBUTED BY HASH(AutoID) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

select sum(a) from (
select count(1) a from readernovel_tidb_fr.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_pt.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_ft.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_en.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_ru.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_sp.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_jp.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_id.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_th.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_and2.novel_bookcategory_new  union all
select count(1)   from readernovel_tidb_cd2.novel_bookcategory_new )a
