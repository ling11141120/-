drop table if exists ads.ads_ad_user_space_conversion_detail_west5;
create table ads.ads_ad_user_space_conversion_detail_west5 (
     dt                  date           not null                  comment "时间"
    ,user_id             bigint(20)     not null                  comment "登录id"
    ,ad_position_id      varchar(60)    not null                  comment "广告位id"
    ,ad_strategy_id      varchar(60)    not null                  comment "策略id"
    ,main_strategy_id    varchar(60)    not null                  comment "主策略id"
    ,ad_type             varchar(60)    not null                  comment "广告类型"
    ,period_type         varchar(60)    not null                  comment "周期类型"
    ,user_type           varchar(60)                              comment "用户类型"
    ,put_language        varchar(60)                              comment "投放语言"
    ,country_leve        varchar(60)                              comment "国家等级"
    ,mt                  varchar(60)                              comment "终端"
    ,corever             varchar(60)                              comment "core"
    ,impression_pv       int(11)                                  comment "曝光pv"
    ,click_pv            int(11)                                  comment "点击pv"
    ,watch_completion_pv int(11)                                  comment "观看完成pv"
    ,ad_revenue_amount   decimal(12, 6)                           comment "广告收益"
    ,etl_time            datetime       default current_timestamp comment "清洗时间"
)
primary key (dt, user_id, ad_position_id, ad_strategy_id, main_strategy_id, ad_type, period_type)
comment "用户广告位转化明细_西五区"
partition by date_trunc("day", dt)
distributed by hash(user_id)
properties
(
    "replication_num" = "2",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
    )
;
