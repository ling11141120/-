----------------------------------------------------------------
-- 目标表： ods.ods_edit_shuangwen_chapter
-- 来源实例： old_tidb_source
-- 来源表：
--        uploadbook_tidb_en.shuangwen_chapter
--        uploadbook_tidb_sp.shuangwen_chapter
--        uploadbook_tidb_fr.shuangwen_chapter
--        uploadbook_tidb_pt.shuangwen_chapter
-- 来源负责：
-- 采集工具：定时-批量
-- 开发人：wx
-- 开发日期： 2025-10-27
----------------------------------------------------------------
drop table if exists ods.ods_edit_shuangwen_chapter;
create table ods.ods_edit_shuangwen_chapter (
     productid          int(11)       not null        comment "产品id"
    ,book_id            bigint(20)    not null        comment "书籍id"
    ,chapter_id         bigint(20)    not null        comment "章节id"
    ,site_id            int(11)       not null        comment "siteid"
    ,chapter_name       varchar(200)                  comment "章节名称"
    ,chapter_length     int(11)                       comment "章节字数"
    ,chapter_content    varchar(65533)                comment "章节内容"
    ,status             int(11)                       comment "状态"
    ,vip                int(11)                       comment " 是否收费"
    ,create_time        datetime                      comment "创建时间"
    ,update_time        datetime                      comment "更新时间"
    ,timer              datetime                      comment "更新时间（例如章节字数有发生变化，时间会更新）"
    ,public_time        datetime                      comment "发布时间"
    ,serial_number      int(11)                       comment "章节号"
    ,m_flag             int(11)                       comment "是否立即更新"
    ,is_lock            int(11)                       comment ""
    ,translator         varchar(500)                  comment "翻译者"
    ,editor             varchar(500)                  comment "校对者"
    ,sr_createtime datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp comment "starrocks数据更新时间"
)
primary key(productid, book_id, chapter_id, site_id)
comment "章节信息表"
distributed by hash(productid, book_id) buckets 20
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "create_time, translator, editor",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;