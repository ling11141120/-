DROP TABLE IF EXISTS dwm.dwm_consume_user_consume_mild_ed;
CREATE TABLE IF NOT EXISTS dwm.dwm_consume_user_consume_mild_ed (
     dt                 DATE           NOT NULL       COMMENT "createtime 分区"
    ,md5_key            STRINGN        NOT NULL       COMMENT "kd5 key"
    ,product_id         INT(11)                       COMMENT "产品id"
    ,user_id            BIGINT(20)                    COMMENT "用户ID"
    ,types              INT(11)                       COMMENT "1：阅币，2：礼券,3：赠送币,4:vip"
    ,pay_type           INT(11)                       COMMENT "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,site_id            BIGINT(20)                    COMMENT "语言id"
    ,book_id            BIGINT(20)                    COMMENT "书籍ID"
    ,chapter_ids        STRING                        COMMENT "章节id组，存在多个ID，以【逗号】分割"
    ,Chapter_id         STRING                        COMMENT "章节id"
    ,corever            BIGINT(20)                    COMMENT "core的版本号"
    ,mt                 INT(11)                       COMMENT "平台 0未知 1iphone 4安卓 9书城"
    ,ver                BIGINT(20)                    COMMENT "服务端版本号"
    ,current_language   BIGINT(20)                    COMMENT "当前语言"
    ,current_language2  BIGINT(20)                    COMMENT "注册时语言"
    ,reg_date           DATETIME                      COMMENT "注册时间"
    ,reg_days           BIGINT(20)                    COMMENT "距离注册时间时长"
    ,reg_country        STRING                        COMMENT "注册国家"
    ,appver             STRING                        COMMENT "app版本"
    ,sex                BIGINT(20)                    COMMENT "性别0未知 1男 2女 3保密"
    ,is_negative_user   SMALLINT(6)                   COMMENT "是否白嫖用户"
    ,ads_type           VARCHAR(60)                   COMMENT "用户广告标签ADSTYPE"
    ,ads_quality        INT(11)                       COMMENT "广告用户质量"
    ,app_id             INT(11)                       COMMENT "项目id，core，语言"
    ,con_chp_amount     DECIMAL(18, 6)                COMMENT "章节消费数额"
    ,con_chp_cnt        BIGINT(20)                    COMMENT "章节消费次数"
    ,con_book_cnt       DECIMAL(18, 6)                COMMENT "消费次数，（1/章节个数）,用于统计用户实际消费次数,即对书的消费次数"
    ,fst_time           DATETIME                      COMMENT "首次消费时间"
    ,lst_time           DATETIME                      COMMENT "末次消费时间"
    ,etl_time           DATETIME                      COMMENT "处理时间"
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT '产品id索引'
    ,INDEX index_types (types) USING BITMAP           COMMENT '消费类型索引'
    ,INDEX index_pay_type (pay_type) USING BITMAP     COMMENT '支付类型汇总索引'
    ,INDEX index_site_id (site_id) USING BITMAP       COMMENT '语言id索引'
)
PRIMARY KEY(dt, md5_key)
COMMENT "dwm消耗域用户消耗轻度汇总表"
PARTITION BY RANGE(dt)
(PARTITION p20250923 VALUES LESS THAN ("2025-09-24"))
DISTRIBUTED BY HASH(dt, md5_key) BUCKETS 2
PROPERTIES (
    "replication_num" = "2",
    "bloom_filter_columns" = "user_id, Chapter_id, book_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "7",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;