----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_book_daily_sale
-- 来源实例： old_tidb_source
-- 来源表： 
--         readernovel_tidb_fr.book_daily_sale
--         readernovel_tidb_pt.book_daily_sale
--         readernovel_tidb_ft.book_daily_sale
--         readernovel_tidb_en.book_daily_sale
--         readernovel_tidb_ru.book_daily_sale
--         readernovel_tidb_sp.book_daily_sale
--         readernovel_tidb_id.book_daily_sale
--         readernovel_tidb_th.book_daily_sale
--         readernovel_tidb_cd2.book_daily_sale
--         readernovel_tidb_and2.book_daily_sale
--         readernovel_tidb_ko.book_daily_sale
--         readernovel_tidb_vi.book_daily_sale
--         readernovel_tidb_jp.book_daily_sale
-- 来源负责： 
-- 采集工具： Seatunnel
-- 开发人： qhr
-- 开发日期： 2025-10-13
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_book_daily_sale;
CREATE TABLE ods.ods_tidb_readernovel_tidb_book_daily_sale (
     dt              DATE        NOT NULL COMMENT "日期"
    ,product_id      INT         NOT NULL COMMENT "产品id"
    ,id              BIGINT      NOT NULL COMMENT "自增id"
    ,bookid          BIGINT      NOT NULL COMMENT "书籍id"
    ,static_date     DATETIME            COMMENT "统计日期"
    ,money_sale      DECIMAL(18, 2) NOT NULL COMMENT "阅币金额"
    ,money_count     BIGINT      NOT NULL COMMENT "阅币消费次数"
    ,money_person    BIGINT      NOT NULL COMMENT "阅毕消费人数"
    ,money_orgin_sale DECIMAL(18, 2) NOT NULL COMMENT "授权书籍阅币金额"
    ,money_orgin_count BIGINT     NOT NULL COMMENT "授权书籍阅币消费次数"
    ,money_orgin_person BIGINT    NOT NULL COMMENT "授权书籍阅币消费人数"
    ,money_pirate_sale DECIMAL(18, 2) NOT NULL COMMENT "非授权书籍阅币金额"
    ,money_pirate_count BIGINT    NOT NULL COMMENT "非授权书籍阅币消费次数"
    ,money_pirate_person BIGINT   NOT NULL COMMENT "非授权书籍阅币消费人数"
    ,gift_sale       DECIMAL(18, 2) NOT NULL COMMENT "礼券金额"
    ,gift_count      BIGINT      NOT NULL COMMENT "礼券消费次数"
    ,gift_person     BIGINT      NOT NULL COMMENT "礼券消费人数"
    ,reward          DECIMAL(18, 2) NOT NULL COMMENT "打赏阅币"
    ,tick_total      BIGINT      NOT NULL COMMENT "月票数"
    ,award_money     DECIMAL(18, 2) NOT NULL COMMENT "赠送币金额"
    ,award_person    BIGINT      NOT NULL COMMENT "赠送币消费人数"
    ,award_count     BIGINT      NOT NULL COMMENT "赠送币消费次数"
    ,award_reward    DECIMAL(18, 2) NOT NULL COMMENT "打赏赠送币"
    ,cps_money       DECIMAL(18, 2) NOT NULL COMMENT "Cps金额"
    ,money_package   DECIMAL(18, 2)      COMMENT "money_package"
    ,size_package    BIGINT      NOT NULL COMMENT "size_package"
    ,free_package    DECIMAL(18, 2) NOT NULL COMMENT "free_package"
    ,sr_createtime   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime   DATETIME            COMMENT "starrocks数据更新时间"
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT '产品id索引'
)
PRIMARY KEY(dt, product_id, id, bookid)
COMMENT "书籍日常销售情况表"
PARTITION BY RANGE(dt)
(PARTITION p2025 VALUES LESS THAN ("2026-01-01"))
DISTRIBUTED BY HASH(product_id, id, bookid) BUCKETS 1
PROPERTIES (
    "replication_num" = "3"
    ,"bloom_filter_columns" = "product_id, id, bookid"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "YEAR"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-100"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;