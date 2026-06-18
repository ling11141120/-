create table if not exists ods.ods_tidb_short_video_goods (
     Id                 bigint         not null                  comment "唯一ID"
    ,GoodsType          int                                      comment "商品类型：0普通充值，1vip充值，2签到卡充值"
    ,UsageScenario      varchar(500)                             comment "应用场景"
    ,Price              int                                      comment "价格"
    ,EffectiveTime      int                                      comment "有效时间"
    ,ShopItemId         int                                      comment "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包）"
    ,VipType            int                                      comment "1 月卡 2 季卡 3 年卡 4 周卡"
    ,FirstEffectiveTime int                                      comment "首充有效期"
    ,FirstPrice         int                                      comment "首充价格"
    ,GoodsAttribute     int                                      comment "商品属性"
    ,PriceTitle         varchar(500)                             comment "展示价格Price-0.01后的价格"
    ,OriTitle           varchar(500)                             comment "原价格"
    ,PayConfigId        bigint                                   comment "支付配置表ID"
    ,ItemId             varchar(500)                             comment "申请ID"
    ,Mt                 int                                      comment "客户端，区分ios 1， android 4"
    ,IsOnOff            int                                      comment "是否启用，启用：1，禁用：0"
    ,CreateTime         datetime                                 comment "创建时间"
    ,UpdateTime         datetime                                 comment "修改时间"
    ,IsRemove           int            default "0"               comment "标识是否删除：1删除，0正常"
    ,PayType            int                                      comment "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外））"
    ,LangId             bigint                                   comment "App语言"
    ,ProductId          bigint                                   comment "充值产品ID，阅读每种语言对应一个APP"
    ,IsShow             int                                      comment "审核期间是否显示 (0否，1是)"
    ,Core               int            default "1"               comment "Core (1core1,2core2,3core3,4core4)"
    ,AppType            int            default "1"               comment "1：阅读，2：短剧"
    ,ApplyType          int            default "1"               comment "应用场景（1App,2Edm）"
    ,DecimalPrice       decimal(10, 2)                           comment "价格(小数)"
    ,FirstVipType       int                                      comment "首充周期:1 月卡 2 季卡 3 年卡 4 周卡 5 天卡"
    ,FirstDecimalPrice  decimal(10, 2)                           comment "首充价格(小数)"
    ,Priority           int                                      comment "优先级，暂时就aca有"
    ,CouponMoney        decimal(10, 2)                           comment "优惠券金额"
    ,ToACAItemId        varchar(100)                             comment "aca原档位itemID"
    ,CouponId           varchar(100)                             comment "优惠券id"
    ,SubscriptionModel  int                                      comment "订阅模式 0普通自动续订、1分期付款订阅"
    ,TotalPrice         decimal(10, 2)                           comment "总价，目前分期价格使用此字段"
    ,InstallmentCount   int                                      comment "分期数"
    ,InstallmentSwitch  tinyint(4)                               comment "分期开关：0-关闭，1-开启"
    ,InstallmentPrice   decimal(10, 2)                           comment "分期月付金额"
    ,sr_createtime      datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime      datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id)
comment "海剧，充值套餐配置表 Author：135013"
distributed by hash(Id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;