drop table if exists dwd.dwd_trade_user_payorder;
create table dwd.dwd_trade_user_payorder (
     dt                    DATE             not null                  comment "日期"
    ,ProductId             INT(11)          not null                  comment "产品id"
    ,AutoId                BIGINT(20)       not null                  comment "自增id"
    ,UserId                BIGINT(20)                                 comment "用户id"
    ,PayChannelidId        INT(11)                                    comment "支付渠道id"
    ,Used                  INT(11)                                    comment "订单是否处理过 0:未处理 1:处理"
    ,OrderId               VARCHAR(128)                               comment "订单id"
    ,Flag                  INT(11)                                    comment "标识 0：阅读；1：游戏"
    ,CreateTime            DATETIME                                   comment "发起时间"
    ,GetTime               DATETIME                                   comment "入账时间"
    ,ItemCount             DECIMAL(18, 2)                             comment "金额数"
    ,SystemType            INT(11)                                    comment "系统类型"
    ,ReceiveDate           DATETIME                                   comment "被接收时间"
    ,MT                    INT(11)                                    comment "平台"
    ,CouponId              VARCHAR(128)                               comment "优惠券id"
    ,PackageId             VARCHAR(255)                               comment "存放充值页面来源"
    ,ShopItem              VARCHAR(128)                               comment "充值类型（0，普通充值，800，801，802月卡，810vip，830新签到卡)"
    ,ExtInfo               VARCHAR(128)                               comment "扩展字段"
    ,VipExpireTime         VARCHAR(20)                                comment "充值订阅卡时，谷歌和苹果返回的过期时间"
    ,RealMoney             INT(11)                                    comment "给的阅币数"
    ,AwardMoney            INT(11)                                    comment "赠送币数量"
    ,PayConfigId           INT(11)                                    comment "新支付配置id"
    ,CoreVer               INT(11)                                    comment "core的版本号"
    ,DeviceGUID            VARCHAR(255)                               comment "当前设备id"
    ,TestFlag              INT(11)                                    comment "是否是测试号充值（0正式，1测试）"
    ,BaseAmount            INT(11)                                    comment "分成后的数量（除以100为分成后的金额）"
    ,Version               VARCHAR(255)                               comment "购买时，用户客户端的版本号"
    ,SubPayType            VARCHAR(50)                                comment "子支付渠道"
    ,GiftMoney             INT(11)                                    comment "充值赠送的礼券数(不准确，部分活动赠送未记录)"
    ,OrderInitTime         DATETIME                                   comment "用户订单创建时间"
    ,CooOrderExtInfo       VARCHAR(1000)                              comment "合作方订单扩展"
    ,product_data          VARCHAR(1048576)                           comment "商品数据 发货成功后回写 json格式"
    ,SensorsData           VARCHAR(65533)                             comment "埋点信息"
    ,etl_time              DATETIME         default current_timestamp comment "etl清洗时间"
    ,subscribe_mode        varchar(50)                                comment "订阅方式"
)
primary key(dt, ProductId, AutoId)
comment "交易域用户充值事实表"
partition by date_trunc('day', dt)
distributed by hash(ProductId, AutoId)
properties ("replication_num" = "3",
            "bloom_filter_columns" = "UserId, CreateTime",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;