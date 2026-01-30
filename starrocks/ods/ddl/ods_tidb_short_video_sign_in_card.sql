----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_sign_in_card
-- 来源实例： old_tidb_source
-- 来源表： short_video.sign_in_card
-- 来源负责：
-- 采集工具： 极光-定时链路
-- 开发人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_sign_in_card;
create table ods.ods_tidb_short_video_sign_in_card (
     Id            bigint       not null                          comment '主键'
    ,AccountId     bigint                                         comment '用户id'
    ,ExpireTime    bigint                                         comment '过期时间'
    ,Bonus         int                                            comment '奖励券'
    ,CreateTime    bigint                                         comment '创建时间'
    ,ProductId     bigint                                         comment '支付配置表Id'
    ,regionId      smallint(6)                                    comment '归属区域 id，1：香港，2：北美；'
    ,Type          int                                            comment '1 月卡  4 周卡'
    ,Price         varchar(50)                                    comment '价格'
    ,GoodsOptionId bigint                                         comment '商品价值方案ID'
    ,ItemId        varchar(100)                                   comment '申请ID'
    ,Mt            int                                            comment '支付渠道，区分ios 1， android 4'
    ,OrderMark     int          not null                          comment '订单标识1正常2取消续订'
    ,PayOrderId    bigint                                         comment '订单号'
    ,PayInfo       string                                         comment '自定义数据，PayInfo快照，json格式'
    ,GainCoin      int                                            comment '获得的币'
    ,GainBonus     int                                            comment '获得的券'
    ,sr_createtime datetime     default current_timestamp         comment 'starrocks数据注入时间'
    ,sr_updatetime datetime     default current_timestamp         comment 'starrocks数据更新时间'
    ,ExpireTimeDt  datetime     as str_to_jodatime(from_unixtime(ExpireTime/1000), 'yyyy-MM-dd HH:mm:ss') comment '过期时间datetime格式'
    ,CreateTimeDt  datetime     as str_to_jodatime(from_unixtime(CreateTime/1000), 'yyyy-MM-dd HH:mm:ss') comment '创建时间datetime格式'
)
primary key(Id)
comment "签到卡记录表"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;