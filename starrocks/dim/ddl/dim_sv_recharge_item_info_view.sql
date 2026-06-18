create or replace view dim.dim_sv_recharge_item_info_view (
     id                    comment "唯一ID"
    ,goods_type            comment "商品类型：0普通充值，1vip充值，2签到卡充值"
    ,usage_scenario        comment "应用场景"
    ,price                 comment "价格"
    ,decimal_price         comment "价格(小数)"
    ,effective_time        comment "有效时间"
    ,shop_item_id          comment "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包）"
    ,vip_type              comment "1 月卡 2 季卡 3 年卡 4 周卡"
    ,first_vip_type        comment "首充周期:1 月卡 2 季卡 3 年卡 4 周卡 5 天卡"
    ,first_effective_time  comment "首充有效期"
    ,first_price           comment "首充价格"
    ,first_decimal_price   comment "首充价格(小数)"
    ,goods_attribute       comment "商品属性"
    ,price_title           comment "展示价格Price-0.01后的价格"
    ,ori_title             comment "原价格"
    ,pay_config_id         comment "支付配置表ID"
    ,item_id               comment "申请ID"
    ,mt                    comment "客户端，区分ios 1， android 4"
    ,is_on_off             comment "是否启用，启用：1，禁用：0"
    ,create_time           comment "创建时间"
    ,update_time           comment "修改时间"
    ,is_remove             comment "标识是否删除：1删除，0正常"
    ,pay_type              comment "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外））"
    ,lang_id               comment "App语言"
    ,product_id            comment "充值产品ID，阅读每种语言对应一个APP"
    ,is_show               comment "审核期间是否显示 (0否，1是)"
    ,core                  comment "Core (1core1,2core2,3core3,4core4)"
    ,app_type              comment "1：阅读，2：短剧"
    ,apply_type            comment "应用场景（1App,2Edm）"
    ,priority              comment "优先级，暂时就aca有"
    ,coupon_money          comment "优惠券金额"
    ,to_aca_item_id        comment "aca原档位itemID"
    ,coupon_id             comment "优惠券id"
    ,subscription_model    comment "订阅模式 0普通自动续订、1分期付款订阅"
    ,total_price           comment "总价，目前分期价格使用此字段"
    ,installment_count     comment "分期数"
    ,installment_switch    comment "分期开关：0-关闭，1-开启"
    ,installment_price     comment "分期月付金额"
    ,sr_createtime         comment "starrocks数据注入时间"
    ,sr_updatetime         comment "starrocks数据更新时间"
)
comment "海剧，充值套餐配置表,充值类型"
as
select Id
     , GoodsType
     , UsageScenario
     , Price
     , DecimalPrice      as decimal_price
     , EffectiveTime
     , ShopItemId
     , VipType
     , FirstVipType      as first_vip_type
     , FirstEffectiveTime
     , FirstPrice
     , FirstDecimalPrice as first_decimal_price
     , GoodsAttribute
     , PriceTitle
     , OriTitle
     , PayConfigId
     , ItemId
     , Mt
     , IsOnOff
     , CreateTime
     , UpdateTime
     , IsRemove
     , PayType
     , LangId
     , ProductId
     , IsShow
     , Core
     , AppType
     , ApplyType
     , Priority
     , CouponMoney       as coupon_money
     , ToACAItemId       as to_aca_item_id
     , CouponId          as coupon_id
     , SubscriptionModel as subscription_model
     , TotalPrice        as total_price
     , InstallmentCount  as installment_count
     , InstallmentSwitch as installment_switch
     , InstallmentPrice  as installment_price
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_short_video_goods
;