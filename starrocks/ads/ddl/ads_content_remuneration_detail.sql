DROP TABLE IF EXISTS ads.ads_content_remuneration_detail;
CREATE TABLE IF NOT EXISTS ads.ads_content_remuneration_detail (
     md5_key        varchar(65533)     not null        comment "唯一主键"
    ,dt             date               not null        comment "统计日期（完成时间）"
    ,site_id        bigint(20)         not null        comment "语言ID"
    ,author_id      bigint(20)         not null        comment "译员ID"
    ,role_type      bigint(20)         null            comment "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查  18:词典创建"
    ,pen_name       varchar(765)       null            comment "译名"
    ,book_id        bigint(20)         null            comment "书籍ID"
    ,book_name      varchar(765)       null            comment "书名"
    ,chapter_id     bigint(20)         null            comment "章节ID"
    ,chapter_name   varchar(765)       null            comment "章节名"
    ,etl_time       datetime           not null        comment ""
)
primary key(md5_key)
comment "实时稿酬"
distributed by hash(md5_key) buckets 14
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "false"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;