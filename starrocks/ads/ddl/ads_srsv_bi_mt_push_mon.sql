DROP TABLE IF EXISTS ads.ads_srsv_bi_mt_push_mon;
CREATE TABLE ads.ads_srsv_bi_mt_push_mon (
     stat_time                DATETIME          NOT NULL    COMMENT '统计时间'
    ,product_id               INT               NOT NULL    COMMENT 'product_id'
    ,core                     INT               NOT NULL    COMMENT 'core'
    ,mt                       INT               NOT NULL    COMMENT '移动终端'
    ,mt_name                  VARCHAR(15)                   COMMENT '移动终端名称'
    ,svr_push_tsk_num         DECIMAL(20, 0)                COMMENT '服务端下发任务数'
    ,svr_push_uv              BITMAP                        COMMENT '服务端下发UV'
    ,svr_push_succ_tsk_num    DECIMAL(20, 0)                COMMENT '服务端下发成功任务数'
    ,push_cli_arr_dev_num     BITMAP                        COMMENT '下发到达客户端设备数'
    ,cli_push_uv              BITMAP                        COMMENT '客户端下发UV'
    ,cli_clk_uv               BITMAP                        COMMENT '客户端点击UV'
    ,cli_dau                  BITMAP                        COMMENT '客户端dau'
    ,cli_push_act_uv          BITMAP                        COMMENT '客户端下发活跃UV'
)
PRIMARY KEY (stat_time, product_id, core, mt)
COMMENT 'BI-海剧海阅移动终端Push监控'
PARTITION BY DATE_TRUNC('year',stat_time)
DISTRIBUTED BY HASH (stat_time, product_id, core, mt)
PROPERTIES(
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;