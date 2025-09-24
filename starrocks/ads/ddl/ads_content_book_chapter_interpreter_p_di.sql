----------------------------------------------------------------
-- 目标表： ads.ads_content_book_chapter_interpreter_p_di
-- 功能：内容域--书籍章节译员-稿酬表
-- 负责人： xjc
-- 开发日期：2024-08-21
----------------------------------------------------------------



DROP TABLE IF EXISTS ads_content_book_chapter_interpreter_p_di;
CREATE TABLE IF NOT EXISTS ads_content_book_chapter_interpreter_p_di (
     dt              date                not null        comment "统计时间"
    ,author_id       bigint(20)          not null        comment "作者id"
    ,book_id         bigint(20)          not null        comment "书籍id"
    ,chapter_id      bigint(20)          not null        comment "书籍id"         -- 注：原注释与字段名（chapter_id）不一致，已保留原注释
    ,site_id         int(11)             not null        comment "语言id"
    ,project_type    int(11)             null            comment "图书书籍类型,0-网文 1-短剧"
    ,author_name     varchar(200)        null            comment "译名"
    ,role_type       int(11)             null            comment "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查"
    ,book_code       varchar(100)        null            comment "书籍编码"
    ,book_name       varchar(500)        null            comment "书籍名称"
    ,chapter_name    varchar(500)        null            comment "章节名称"
    ,font_length     bigint(20)          null            comment "字数"
    ,create_time     datetime            null            comment "创建时间"
    ,etl_time        datetime            null            comment "etl清洗时间 "
)
primary key(dt, author_id, book_id, chapter_id)
comment "内容域--书籍章节译员-稿酬表"
partition by range(dt)
(
     partition p2020 values [("2020-01-01"), ("2021-01-01"))
    ,partition p2021 values [("2021-01-01"), ("2022-01-01"))
    ,partition p2022 values [("2022-01-01"), ("2023-01-01"))
    ,partition p2023 values [("2023-01-01"), ("2024-01-01"))
    ,partition p2024 values [("2024-01-01"), ("2025-01-01"))
    ,partition p2025 values [("2025-01-01"), ("2026-01-01"))
    ,partition p2026 values [("2026-01-01"), ("2027-01-01"))
    ,partition p2027 values [("2027-01-01"), ("2028-01-01"))
    ,partition p2028 values [("2028-01-01"), ("2029-01-01"))
)
distributed by hash(author_id, book_id) buckets 1
properties (
            "replication_num" = "3"
            ,"dynamic_partition.enable" = "true"
            ,"dynamic_partition.time_unit" = "YEAR"
            ,"dynamic_partition.time_zone" = "Asia/Shanghai"
            ,"dynamic_partition.start" = "-7"
            ,"dynamic_partition.end" = "3"
            ,"dynamic_partition.prefix" = "p"
            ,"dynamic_partition.buckets" = "1"
            ,"dynamic_partition.history_partition_num" = "0"
            ,"in_memory" = "false"
            ,"enable_persistent_index" = "true"
            ,"replicated_storage" = "true"
            ,"compression" = "LZ4"
)
;