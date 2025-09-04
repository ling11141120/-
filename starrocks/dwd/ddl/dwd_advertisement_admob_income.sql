DROP TABLE IF EXISTS dwd.dwd_advertisement_admob_income;
CREATE TABLE dwd.dwd_advertisement_admob_income (
     dt               DATE             NOT NULL COMMENT "日期，来自DATE字段"
    ,id               BIGINT(20)       NOT NULL COMMENT "自增id"
    ,time_types       SMALLINT(6)      NOT NULL COMMENT "时区类型 1北京 2洛杉矶"
    ,ad_unit          VARCHAR(65533)            COMMENT "广告单元id"
    ,plat_form        VARCHAR(65533)            COMMENT "系统"
    ,ad_source        VARCHAR(65533)            COMMENT "广告来源"
    ,name             VARCHAR(65533)            COMMENT "广告来源名字"
    ,app              VARCHAR(65533)            COMMENT "appid"
    ,ad_requests      BIGINT(20)                COMMENT "请求的数量。该值是一个整数。"
    ,clicks           BIGINT(20)                COMMENT "用户点击广告的次数。该值是一个整数。"
    ,ad_amount        DECIMAL(24, 8)            COMMENT "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,impressions      BIGINT(20)                COMMENT "向用户展示的广告总数。该值是一个整数。"
    ,matched_requests BIGINT(20)                COMMENT "响应请求而返回广告的次数。该值是一个整数。"
    ,match_rate       DOUBLE                    COMMENT "匹配的广告请求与总广告请求的比率。该值是双精度（近似）十进制值。"
    ,observed_ecpm    BIGINT(20)                COMMENT "第三方广告网络的估计平均 eCPM 例如，$2.30 将表示为 2300000"
    ,account          VARCHAR(65533)            COMMENT "广告账户"
    ,create_time      DATETIME                  COMMENT "创建时间"
    ,update_time      DATETIME                  COMMENT "更新时间"
    ,etl_time         DATETIME         NOT NULL COMMENT "数据清洗时间"
    ,appver           VARCHAR(50)               COMMENT ""
)
PRIMARY KEY (dt, id, time_types)
COMMENT "广告语admob广告收入事实表"
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (id, time_types) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;