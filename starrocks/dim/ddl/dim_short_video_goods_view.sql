create view dim_short_video_goods_view (
     id                      comment "唯一ID"
    ,goods_type              comment "商品类型：0普通充值，1vip充值，2签到卡充值"
    ,usage_scenario          comment "应用场景"
    ,price                   comment "价格"
    ,effective_time          comment "有效时间"
    ,shop_item_id            comment "区分不同充值类型：（0：充值，800：签到卡，810：SVIP，830:福利包，840：新福利包）"
    ,vip_type                comment "1 月卡 2 季卡 3 年卡 4 周卡"
    ,first_effective_time    comment "首充有效期"
    ,first_price             comment "首充价格"
    ,goods_attribute         comment "商品属性"
    ,price_title             comment "展示价格Price-0.01后的价格"
    ,ori_title               comment "原价格"
    ,pay_config_id           comment "支付配置表ID"
    ,item_id                 comment "申请ID"
    ,mt                      comment "客户端，区分ios 1， android 4"
    ,is_on_off               comment "是否启用，启用：1，禁用：0"
    ,create_time             comment "创建时间"
    ,update_time             comment "修改时间"
    ,is_remove               comment "标识是否删除：1删除，0正常"
    ,pay_type                comment "支付渠道（1AppStore,2GooglePay，5华为_鸿蒙（海外））"
    ,lang_id                 comment "App语言"
    ,product_id              comment "充值产品ID，阅读每种语言对应一个APP"
    ,is_show                 comment "审核期间是否显示 (0否，1是)"
    ,core                    comment "Core (1core1,2core2,3core3,4core4)"
    ,app_type                comment "1：阅读，2：短剧"
    ,apply_type              comment "应用场景（1App,2Edm）"
    ,sr_createtime           comment "sr入库时间"
    ,sr_updatetime           comment "sr更新时间"
)
as
select Id                 as id
     , GoodsType          as goods_type
     , UsageScenario      as usage_scenario
     , Price              as price
     , EffectiveTime      as effective_time
     , ShopItemId         as shop_item_id
     , VipType            as vip_type
     , FirstEffectiveTime as first_effective_time
     , FirstPrice         as first_price
     , GoodsAttribute     as goods_attribute
     , PriceTitle         as price_title
     , OriTitle           as ori_title
     , PayConfigId        as pay_config_id
     , ItemId             as item_id
     , Mt                 as mt
     , IsOnOff            as is_on_off
     , CreateTime         as create_time
     , UpdateTime         as update_time
     , IsRemove           as is_remove
     , PayType            as pay_type
     , LangId             as lang_id
     , ProductId          as product_id
     , IsShow             as is_show
     , Core               as core
     , AppType            as app_type
     , ApplyType          as apply_type
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_short_video_admin_goods;