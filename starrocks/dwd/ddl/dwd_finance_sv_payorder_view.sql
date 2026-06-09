create or replace view dwd.dwd_finance_sv_payorder_view (
     dt                 comment "createtime分区"
    ,product_id         comment "产品id 6833海外短剧"
    ,id                 comment "自增id"
    ,type               comment "类型"
    ,user_id            comment "用户id"
    ,used               comment "是否执行"
    ,order_id           comment "订单id"
    ,flag               comment "标识"
    ,create_time        comment "创建时间"
    ,get_time           comment "获取时间"
    ,item_count         comment "金额数"
    ,system_type        comment "系统类型"
    ,receive_date       comment "被接收时间"
    ,mt                 comment "终端"
    ,coupon_id          comment "礼券id"
    ,package_id         comment "存放充值页面来源"
    ,shop_item          comment "充值类型"
    ,extinfo            comment "信息"
    ,vip_expire_time    comment "充值订阅卡时,过期时间"
    ,real_money         comment "给的阅币数"
    ,give_money         comment "暂时无用"
    ,amount             comment "暂时无用"
    ,prod_id            comment "暂时无用"
    ,pay_config_id      comment "充值项的Id,可能不准确"
    ,corever            comment "包体"
    ,unique_guid        comment "用户设备id"
    ,test_flag          comment "是否是测试号充值(0正式,1测试)"
    ,buy_token          comment "购买时候的google的token"
    ,base_amount        comment "分成后的数量"
    ,version            comment "购买时,用户客户端的版本号"
    ,subpay_type        comment "充值渠道"
    ,gift_money         comment "充值赠送的礼券数(可能不准确)"
    ,order_init_time    comment "用户订单创建时间"
    ,cooorder_extinfo   comment "合作方订单扩展"
    ,custom_data        comment "自定义数据,透传,json格式"
    ,actual_amount      comment "总支付金额，小数类型"
    ,order_status       comment "订单状态，0：正常，1：发起退款，2：退款成功，3：退款失败"
    ,status_update_time comment "订单状态修改时间"
    ,snapshot_time      comment "快照时间"
)
comment "财务短剧用户订单清洗视图"
as
select a1.dt                 as dt                 -- createtime分区
      ,6833                  as product_id         -- 产品id 6833海外短剧
      ,a1.id                 as id                 -- 自增id
      ,a1.type               as type               -- 类型
      ,a1.userid             as user_id            -- 用户id
      ,a1.used               as used               -- 是否执行
      ,a1.orderid            as order_id           -- 订单id
      ,a1.flag               as flag               -- 标识
      ,a1.createtime         as create_time        -- 创建时间
      ,a1.gettime            as get_time           -- 获取时间
      ,a1.itemcount          as item_count         -- 金额数
      ,a1.systemtype         as system_type        -- 系统类型
      ,a1.receivedate        as receive_date       -- 被接收时间
      ,a1.MT                 as mt                 -- 终端
      ,a1.CouponId           as coupon_id          -- 礼券id
      ,a1.PackageId          as package_id         -- 存放充值页面来源
      ,a1.ShopItem           as shop_item          -- 充值类型
      ,a1.ExtInfo            as extinfo            -- 信息
      ,a1.VipExpireTime      as vip_expire_time    -- 充值订阅卡时,过期时间
      ,a1.RealMoney          as real_money         -- 给的阅币数
      ,a1.GiveMoney          as give_money         -- 暂时无用
      ,a1.Amount             as amount             -- 暂时无用
      ,a1.ProdId             as prod_id            -- 暂时无用
      ,a1.PayConfigId        as pay_config_id      -- 充值项的Id,可能不准确
      ,a1.CoreVer            as corever            -- 包体
      ,a1.UniqueGuid         as unique_guid        -- 用户设备id
      ,a1.TestFlag           as test_flag          -- 是否是测试号充值(0正式,1测试)
      ,a1.BuyToken           as buy_token          -- 购买时候的google的token
      ,a1.BaseAmount         as base_amount        -- 分成后的数量
      ,a1.Version            as version            -- 购买时,用户客户端的版本号
      ,a1.SubPayType         as subpay_type        -- 充值渠道
      ,a1.GiftMoney          as gift_money         -- 充值赠送的礼券数(可能不准确)
      ,a1.OrderInitTime      as order_init_time    -- 用户订单创建时间
      ,a1.CooOrderExtInfo    as cooorder_extinfo   -- 合作方订单扩展
      ,a1.CustomData         as custom_data        -- 自定义数据,透传,json格式
      ,a1.ActualAmount       as actual_amount      -- 总支付金额，小数类型
      ,a1.OrderStatus        as order_status       -- 订单状态，0：正常，1：发起退款，2：退款成功，3：退款失败
      ,a1.StatusUpdateTime   as status_update_time -- 订单状态修改时间
      ,a1.snapshot_time      as snapshot_time      -- 快照时间
  from ods.ods_tidb_finance_snapshot_short_video_payorder    as a1
;
