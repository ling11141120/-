DROP TABLE IF EXISTS tmp.dim_koc_anom_usr_info;
CREATE TABLE IF NOT EXISTS tmp.dim_koc_anom_usr_info (
     usr_id              BIGINT       NOT NULL    COMMENT '用户id'
    ,anom_type_cd        TINYINT      NOT NULL    COMMENT '异常类型编码'
    ,anom_type_name      VARCHAR(50)  NOT NULL    COMMENT '异常类型名称'
    ,anom_status_cd      TINYINT      NOT NULL    COMMENT '异常状态编码'
    ,anom_status_name    VARCHAR(50)  NOT NULL    COMMENT '异常状态名称'
    ,anom_start_time     DATETIME     NOT NULL    COMMENT '异常开始时间'
    ,anom_end_time       DATETIME                 COMMENT '异常结束时间'
    ,manl_rmk            VARCHAR(765)             COMMENT '人工备注'
    ,create_time         DATETIME     NOT NULL    COMMENT '创建时间'
    ,update_time         DATETIME     NOT NULL    COMMENT '更新时间'
    ,etl_time            DATETIME                 COMMENT 'etl时间'
)
PRIMARY KEY (usr_id)
COMMENT "koc异常用户信息"
DISTRIBUTED BY HASH(usr_id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;