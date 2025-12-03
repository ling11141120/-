----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_payorder
-- 来源实例： old_tidb_source
-- 来源表： hallow.payorder
-- 来源负责： chh
-- 采集工具： SeaTunnel
-- 开发人：qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_payorder;
create table ods.ods_tidb_hallow_payorder (
     dt               date           not null comment '分区日期'
    ,Id               int            not null comment 'id'
    ,type             int                     comment '类型'
    ,userid           bigint                  comment '用户id'
    ,used             int                     comment '是否处理'
    ,orderid          varchar(384)            comment '订单id'
    ,flag             int                     comment 'flag'
    ,createtime       datetime                comment '创建时间'
    ,gettime          datetime                comment '获取时间'
    ,itemcount        decimal(18, 2)          comment '订单金额'
    ,systemtype       int                     comment '渠道类型'
    ,receivedate      datetime                comment '接受时间'
    ,MT               int                     comment '安卓还是iOS'
    ,CouponId         varchar(384)            comment '礼券id'
    ,PackageId        varchar(765)            comment 'PackageId'
    ,ShopItem         varchar(384)            comment '充值类型'
    ,ExtInfo          varchar(384)            comment '额外信息'
    ,VipExpireTime    varchar(60)             comment '会员到期时间'
    ,RealMoney        int                     comment '订单阅币'
    ,GiveMoney        int                     comment '订单赠送币'
    ,Amount           int                     comment 'Amount'
    ,ProdId           int                     comment 'ProdId'
    ,PayConfigId      int                     comment 'PayConfigId'
    ,CoreVer          int                     comment 'CoreVer'
    ,UniqueGuid       varchar(765)            comment '用户设备id'
    ,TestFlag         int                     comment '是否测试账号'
    ,BuyToken         varchar(765)            comment '购买时候的google的token'
    ,BaseAmount       int                     comment 'BaseAmount'
    ,Version          varchar(765)            comment '购买时，用户客户端的版本号'
    ,SubPayType       varchar(150)            comment '子渠道'
    ,GiftMoney        int                     comment '发放礼券'
    ,OrderInitTime    datetime                comment '用户订单创建时间'
    ,CooOrderExtInfo  varchar(3000)           comment '合作方订单扩展'
    ,CustomData       string                  comment '自定义数据，透传，json格式'
    ,OrderStatus      int                     comment '0：正常，1：发起退款，2：退款成功，3：退款失败'
    ,StatusUpdateTime datetime                comment 'orderstatus更新时间，author：350625'
    ,ProductData      string                  comment '商品数据，发货成功后回写，json格式'
    ,ActualAmount     decimal(18, 2)          comment '总支付金额，小数类型'
    ,SensorsData      string                  comment '埋点信息'
    ,sr_createtime    datetime                comment "starrocks入库时间"
    ,sr_updatetime    datetime                comment "starrocks数据更新时间"
)
primary key (dt, Id)
comment "圣经订单表"
partition by date_trunc('month', dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;