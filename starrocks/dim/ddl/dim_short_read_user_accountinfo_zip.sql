DROP TABLE IF EXISTS dim.dim_short_read_user_accountinfo_zip;
CREATE TABLE dim.dim_short_read_user_accountinfo_zip (
     product_id            INT(11)      NOT NULL COMMENT "产品id"
    ,user_id               BIGINT(20)   NOT NULL COMMENT "用户id"
    ,start_dt              DATE         NOT NULL COMMENT "开始日期"
    ,end_dt                DATE         NOT NULL COMMENT "结束日期"
    ,mt                    INT(11)               COMMENT "最新平台号,1为ios 4为安卓"
    ,corever               INT(11)               COMMENT "core,默认1"
    ,app_ver               VARCHAR(200)          COMMENT "版本号"
    ,current_language      INT(11)               COMMENT "最新用户使用语言"
    ,app_id                INT(11)               COMMENT "应用id"
    ,app_notify            INT(11)               COMMENT "app_notify"
    ,dynamic_island_switch INT(11)               COMMENT "灵动岛开关，0未知，1：开启，2：关闭"
    ,etl_time              DATETIME              COMMENT "处理时间"
)
PRIMARY KEY(product_id, user_id, start_dt)
COMMENT "海阅-用户基本信息按天拉链表"
DISTRIBUTED BY HASH(product_id, user_id) BUCKETS 20
PROPERTIES (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;