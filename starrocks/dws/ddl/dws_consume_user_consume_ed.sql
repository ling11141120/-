DROP TABLE IF EXISTS dws.dws_consume_user_consume_ed;
CREATE TABLE dws.dws_consume_user_consume_ed (
     dt                   DATE          NOT NULL                COMMENT "createtime 分区"
    ,product_id           INT(11)       NOT NULL                COMMENT "产品id"
    ,user_id              BIGINT(20)    NOT NULL                COMMENT "用户ID"
    ,book_id              BIGINT(20)    NOT NULL                COMMENT "书籍ID"
    ,types                INT(11)       NOT NULL                COMMENT "1:阅币,2:礼券,3:赠送币,4:vip"
    ,site_id              INT(11)                               COMMENT "语言id"
    ,corever              INT(11)                               COMMENT "core的版本号"
    ,mt                   INT(11)                               COMMENT "平台 0未知 1iphone 4安卓 9书城"
    ,ver                  INT(11)                               COMMENT "客户端版本号"
    ,current_language     INT(11)                               COMMENT "当前语言"
    ,current_language2    INT(11)                               COMMENT "注册时语言"
    ,reg_date             DATETIME                              COMMENT "注册时间"
    ,reg_days             INT(11)                               COMMENT "距离注册时间时长"
    ,reg_country          VARCHAR(65533)                        COMMENT "注册国家"
    ,appver               VARCHAR(65533)                        COMMENT "app版本"
    ,sex                  INT(11)                               COMMENT "性别0未知 1男 2女 3保密"
    ,app_id               INT(11)                               COMMENT "项目id，core，语言"
    ,con_chapter_nums     INT(11)                               COMMENT "消费章节数"
    ,amount               INT(11)                               COMMENT "消费金额"
    ,fst_tm               DATETIME                              COMMENT "当日首次消费时间"
    ,lst_tm               DATETIME                              COMMENT "当日末次消费时间"
    ,etl_time             DATETIME DEFAULT CURRENT_TIMESTAMP    COMMENT "处理时间"
    ,INDEX index_product_id (product_id) USING BITMAP           COMMENT '产品id索引'
    ,INDEX index_types (types) USING BITMAP                     COMMENT '消费类型索引'
)
PRIMARY KEY (dt, product_id, user_id, book_id, types)
COMMENT "消耗域用户书籍消费一日汇总表"
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (product_id, user_id, book_id, types) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "reg_date, types, book_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;