drop table if exists dwd.dwd_consume_user_consume;
create table dwd.dwd_consume_user_consume (
     dt            DATE           NOT NULL                 COMMENT "createtime 分区"
    ,product_id    INT(11)        NOT NULL                 COMMENT "产品id"
    ,auto_id       BIGINT(20)     NOT NULL                 COMMENT "自增id"
    ,types         INT(11)        NOT NULL                 COMMENT "1：阅币，2：礼券,3：赠送币,4:vip"
    ,user_id       BIGINT(20)                              COMMENT "用户ID"
    ,amount        INT(11)                                 COMMENT "消费数额"
    ,remain_amount INT(11)                                 COMMENT "剩余数额(阅币、礼券、赠送币、vip)"
    ,book_id       BIGINT(20)                              COMMENT "书籍ID"
    ,chapter_ids   VARCHAR(65533)                          COMMENT "章节id组，存在多个ID，以【逗号】分割"
    ,chapter_num   INT(11)                                 COMMENT "章节数"
    ,createtime    DATETIME                                COMMENT "创建时间"
    ,pay_type      INT(11)                                 COMMENT "付款方式 对应dim_paytype表中类型（注意：paytype<>1103)"
    ,mt            INT(11)                                 COMMENT "平台 0未知 1iphone 4安卓 9书城"
    ,seq           BIGINT(20)                              COMMENT "序号id"
    ,app_id        INT(11)                                 COMMENT "项目id，core，语言"
    ,position_id   VARCHAR(50)                             COMMENT "埋点id"
    ,app_game_id   BIGINT(20)                              COMMENT "游戏id"
    ,send_id       VARCHAR(255)                            COMMENT "发送id"
    ,isFirst       INT(11)                                 COMMENT "是否首次购买"
    ,etl_time      DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
)
PRIMARY KEY (dt, product_id, auto_id, types)
COMMENT "消耗域用户消费事实表"
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (product_id, auto_id) BUCKETS 5
PROPERTIES (
    "replication_num" = "2",
    "bloom_filter_columns" = "createtime, user_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-120",
    "dynamic_partition.end" = "2",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;