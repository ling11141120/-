CREATE TABLE IF NOT EXISTS ads.ads_mid_read_first_contrib_di
(
    dt              date        NOT NULL  COMMENT '运行日期（贡献落地日期）'
  , anchor_dt       date        NOT NULL  COMMENT '锚点日期（首读日期）'
  , lag_day         int         NOT NULL  COMMENT '事件日期与锚点日期日差'
  , window_type     varchar(16) NOT NULL  COMMENT '窗口类型：base/0d/h12/h24/d3/d7/d30'
  , lang_id         int                   COMMENT '语言ID'
  , book_id         bigint                COMMENT '书籍ID'
  , chapter_id      bigint                COMMENT '章节ID'
  , mt              int                   COMMENT '端标识'
  , corever         int                   COMMENT '包体版本'
  , user_tp         int                   COMMENT '用户类型'
  , source_user_tp  int                   COMMENT '媒体用户类型'
  , source          varchar(255)          COMMENT '媒体来源'
  , read_unt        bitmap                COMMENT '阅读人数位图贡献'
  , tot_csm_unt     bitmap                COMMENT '总消耗人数位图贡献'
  , csm_unt         bitmap                COMMENT '阅币消耗人数位图贡献'
  , tot_csm_amt     decimal(18, 2)        COMMENT '总消耗金额贡献'
  , csm_amt         decimal(18, 2)        COMMENT '阅币消耗金额贡献'
  , etl_tm          DATETIME              COMMENT '入仓时间'
) PRIMARY KEY (dt, anchor_dt, lag_day, window_type, lang_id, book_id, chapter_id, mt, corever, user_tp, source_user_tp, source)
COMMENT '首次阅读章节消费-窗口贡献中间表（按运行日沉淀）'
PARTITION BY date_trunc("day", dt)
DISTRIBUTED BY HASH (dt, anchor_dt, window_type, lang_id, book_id, chapter_id) BUCKETS 10
PROPERTIES (
  "replication_num" = "3"
  , "partition_live_number" = "100"
  , "enable_persistent_index" = "true"
  , "in_memory" = "false"
  , "replicated_storage" = "true"
  , "compression" = "LZ4"
)
;
