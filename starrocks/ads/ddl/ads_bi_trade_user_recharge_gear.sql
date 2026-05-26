drop table if exists ads.ads_bi_trade_user_recharge_gear;
create table ads.ads_bi_trade_user_recharge_gear (
     dt                                         date              comment "统计周期"
    ,product_id                                 int               comment "产品id"
    ,user_id                                    bigint            comment "用户id"
    ,period_type                                varchar(20)       comment "统计周期类型,ctt/rmt,rmt(拉活用户)"
    ,user_type                                  varchar(65533)    comment "用户类型"
    ,which_weeks                                int               comment "对应日期的周数"
    ,which_months                               int               comment "对应日期的月份"
    ,current_language2                          int               comment "投放语言（注册语言）"
    ,source_chl                                 varchar(1000)     comment "最新渠道"
    ,reg_country                                varchar(65533)    comment "注册国家"
    ,country_level                              int               comment "国家等级"
    ,mt                                         int               comment "平台"
    ,corever                                    int               comment "core"
    ,source                                     int               comment "3是付费 2是官网  1 是自然和其他 条件：source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3 when source in ('officialsite','(not set)') then 2 else 1'"
    ,shop_item                                  varchar(65533)    comment "充值类型"
    ,recharge_gear                              decimal(18,2)     comment "充值档位（充值金额）"
    ,is_first_charge                            int               comment "是否首次充值 1：是 ，0：否"
    ,charge_cnt                                 bigint            comment "充值次数"
    ,before_charge                              decimal(18,2)     comment "充值金额（分成前）"
    ,after_charge                               decimal(18,2)     comment "充值金额（分成后）"
    ,etl_time                                   datetime          comment "处理时间"
    ,is_valid                                   int               comment "是否有效(1:是,0:否)"
    ,is_first_subscription                      int               comment "是否首次订阅(1:是,0:否)"
    ,autorenew_times                            int               comment "续订次数"
    ,subscribe_status                           int               comment "订阅状态(-1:试用,0:默认值,1:首次购买,2:续订)"
    ,subpay_type                                varchar(65533)    comment "支付渠道"
    ,user_ad_source                             int               comment "广告投流用户：0：正常用户，1：vip投流用户"
    ,item_id                                    varchar(50)       comment "充值商品周期类型-天卡/周卡/月卡/季卡/年卡"
    ,subscribe_mode                             varchar(50)       comment "订阅方式"
    ,index index_which_weeks (which_weeks)      using bitmap      comment 'index_which_weeks'
    ,index index_which_months (which_months)    using bitmap      comment 'index_which_months'
)
duplicate key (dt, product_id, user_id)
comment "用户域登录阅读充值消耗汇总活跃表"
distributed by hash (product_id, user_id) buckets 1 
properties (
    "replication_num" = "3"
   ,"bloom_filter_columns" = "mt, current_language2, reg_country, corever"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;