drop table if exists ads.ads_srsv_trade_koc_payorderinfo_di;
create table ads.ads_srsv_trade_koc_payorderinfo_di (
     ref_order_id        varchar(128)   not null                  comment "订单号"
    ,status              int            not null                  comment "订单状态 0 正常订单 1 退款订单"
    ,dt                  date           not null                  comment "日期"
    ,code                string         not null                  comment "口令词"
    ,story_id            bigint         not null                  comment "故事 ID"
    ,story_name          string                                   comment "故事名称"
    ,amount              decimal(16, 4)                           comment "金额数"
    ,base_amount         decimal(16, 4)                           comment "分成后金额数"
    ,project_type        int                                      comment "项目类型 1=网文|2=短剧"
    ,institution_user_id string                                   comment "机构用户ID"
    ,star_user_id        string                                   comment "达人用户ID"
    ,create_time         datetime                                 comment "创建时间"
    ,etl_time            datetime       default current_timestamp comment "etl清洗时间"
    ,core                int                                      comment "core"
    ,current_language    int                                      comment "投放语言"
    ,user_id             bigint                                   comment "用户id"
    ,mt                  int                                      comment "mt"
    ,sub_pay_type        varchar(100)                             comment "支付方式"
    ,shop_item           int                                      comment "权益类型"
    ,activation_time     datetime                                 comment "激活时间"
    ,country             varchar(100)                             comment "国家"
    ,is_anom_ord         int            default "0"               comment "是否异常订单"
    ,reg_dev_id          string                                   comment "注册时设备id"
    ,reg_ip              string                                   comment "注册IP"
)
primary key(ref_order_id, status)
comment "KOC订单信息"
distributed by hash(status, ref_order_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;