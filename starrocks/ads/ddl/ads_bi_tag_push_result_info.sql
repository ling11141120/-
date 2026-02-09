drop table if exists ads.ads_bi_tag_push_result_info;
create table ads.ads_bi_tag_push_result_info (
     dt              date           not null         comment "事件分区"
    ,product_id      int            not null         comment "产品id"
    ,push_id         int                             comment "push_id"
    ,push_type       int                             comment "推送类型"
    ,strategy_id     int                             comment "策略id"
    ,book_id         bigint                          comment "书籍id"
    ,actual_push_unt int                             comment "实际推送人数"
    ,send_unt        int                             comment "送达人数"
    ,click_unt       int                             comment "点击人数"
    ,read_unt        int                             comment "阅读人数"
    ,pay_unt         int                             comment "充值人数"
    ,pay_amt         decimal(18, 2)                  comment "充值金额"
    ,money_unt       int                             comment "阅币消耗人数"
    ,money_amt       int                             comment "阅币消耗数额"
    ,total_unt       int                             comment "总消耗人数"
    ,total_amt       int                             comment "总消耗数额"
    ,gift_money_unt  int                             comment "礼券消耗人数"
    ,gift_money_amt  int                             comment "礼券消耗数额"
    ,etl_tm          datetime                        comment "清洗时间"
    ,index index_productid (product_id) using bitmap comment 'index_productid'
)
duplicate key(dt, product_id, push_id)
comment "阅读-tag推送，推送活动归因数据"
distributed by hash(dt, product_id, push_id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;