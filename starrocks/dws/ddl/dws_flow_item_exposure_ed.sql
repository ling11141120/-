DROP TABLE IF EXISTS dws.dws_flow_item_exposure_ed;
CREATE TABLE dws.dws_flow_item_exposure_ed (
     dt                 DATE           NOT NULL                  COMMENT "分区日期"
    ,product_id         INT(11)                                  COMMENT "产品id"
    ,user_id            BIGINT(20)                               COMMENT "用户id"
    ,current_language   INT(11)                                  COMMENT "界面语言"
    ,current_language2  INT(11)                                  COMMENT "注册语言"
    ,reg_country        VARCHAR(255)                             COMMENT "注册国家"
    ,country_level      INT(11)                                  COMMENT "国家等级"
    ,corever            INT(11)                                  COMMENT "corever"
    ,mt                 VARCHAR(255)                             COMMENT "终端"
    ,page_name          VARCHAR(65533)                           COMMENT "页面名称"
    ,page_id            INT(11)                                  COMMENT "页面ID"
    ,element_name       VARCHAR(65533)                           COMMENT "控件名称"
    ,element_id         INT(11)                                  COMMENT "控件ID"
    ,book_id            BIGINT(20)                               COMMENT "小说ID"
    ,is_bookshelf       VARCHAR(65533)                           COMMENT "小说是否已在书架中"
    ,channel_id         INT(11)                                  COMMENT "频道id"
    ,list_id            INT(11)                                  COMMENT "榜单id"
    ,list_style         VARCHAR(65533)                           COMMENT "榜单样式"
    ,list_name          VARCHAR(65533)                           COMMENT "榜单名称"
    ,list_index         INT(11)                                  COMMENT "榜单位序"
    ,parent_group_id    INT(11)                                  COMMENT "用户集合ID"
    ,group_id           INT(11)                                  COMMENT "用户分组ID(人群包id)"
    ,send_id            VARCHAR(65533)                           COMMENT "转化来源"
    ,current_book_id    BIGINT(20)                               COMMENT "当前书籍ID"
    ,ranking_type       VARCHAR(65533)                           COMMENT "排行榜类型"
    ,gender             VARCHAR(65533)                           COMMENT "性别"
    ,period             VARCHAR(65533)                           COMMENT "时间周期"
    ,activity_id        BIGINT(20)                               COMMENT "活动id"
    ,app_module         VARCHAR(65533)                           COMMENT "模块"
    ,event_strategy_id  INT(11)                                  COMMENT "策略id"
    ,cnt                INT(11)                                  COMMENT "pv次数"
    ,etl_tm             DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
    ,INDEX index_product_id (product_id) USING BITMAP            COMMENT 'index_product_id'
    ,INDEX index_page_id (page_id)       USING BITMAP            COMMENT 'index_page_id'
    ,INDEX index_element_id (element_id) USING BITMAP            COMMENT 'index_element_id'
    ,INDEX index_list_id (list_id)       USING BITMAP            COMMENT 'index_list_id'
)
DUPLICATE KEY(dt, product_id, user_id)
COMMENT "小说曝光事件"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, product_id, user_id) BUCKETS 2
PROPERTIES (
    "replication_num" = "2",
    "bloom_filter_columns" = "user_id, group_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "2",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;