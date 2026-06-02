drop table if exists ads.ads_sv_third_payment_realtime_mon;
create table ads.ads_sv_third_payment_realtime_mon (
     stat_time              datetime     not null comment '统计时间(精确到小时,0点至该小时累计)'
    ,product_id             int          not null comment 'product_id(6833=海剧,其他=海阅各语言)'
    ,user_type              varchar(10)  not null comment '用户类型(D0/非D0)'
    ,core                   int          not null comment 'core版本'
    ,mt                     int          not null comment '移动终端(1=iOS,4=Android)'
    ,exposure_uv            bitmap                comment '曝光UV'
    ,third_exposure_uv      bitmap                comment '三方曝光UV'
    ,enter_group_uv         bitmap                comment '入包UV'
    ,third_recharge_uv      bitmap                comment '三方充值UV'
    ,third_recharge_amount  decimal(20,2)          comment '三方充值金额'
    ,native_recharge_amount decimal(20,2)          comment '原生充值金额'
)
primary key (stat_time, product_id, user_type, core, mt)
comment '三方支付实时监控'
partition by date_trunc('year', stat_time)
distributed by hash (stat_time, product_id, core, mt)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
