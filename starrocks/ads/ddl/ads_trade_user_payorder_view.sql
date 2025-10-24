create or replace view ads.ads_trade_user_payorder_view (
     dt                   comment "日期"
    ,product_id          comment "产品id"
    ,auto_id             comment "自增id"
    ,user_id             comment "用户id"
    ,pay_channel_id      comment "支付渠道id"
    ,used                comment "订单是否处理过 0:未处理 1:处理"
    ,order_id            comment "订单id"
    ,flag                comment "标识 0：阅读；1：游戏"
    ,create_time         comment "发起时间"
    ,get_time            comment "入账时间"
    ,item_count          comment "金额数"
    ,system_type         comment "系统类型"
    ,receive_date        comment "被接收时间"
    ,mt                  comment "平台"
    ,coupon_id           comment "礼券id"
    ,package_id          comment "存放充值页面来源"
    ,shop_item           comment "充值类型（0，普通充值，800，801，802月卡，810vip，830新签到卡)"
    ,extinfo             comment "扩展字段"
    ,vipexpire_time      comment "充值订阅卡时，谷歌和苹果返回的过期时间"
    ,real_money          comment "给的阅币数"
    ,award_money         comment "赠送币数量"
    ,pay_config_id       comment "新支付配置id"
    ,corever             comment "core的版本号"
    ,device_guid         comment "当前设备id"
    ,test_flag           comment "是否是测试号充值（0正式，1测试）"
    ,base_amount         comment "分成后的数量（除以100为分成后的金额）"
    ,version             comment "购买时，用户客户端的版本号"
    ,subpay_type         comment "子支付渠道"
    ,gift_money          comment "充值赠送的礼券数(不准确，部分活动赠送未记录)"
    ,order_init_time     comment "用户订单创建时间"
    ,cooorder_extinfo    comment "合作方订单扩展"
    ,product_data        comment "商品数据 发货成功后回写 json格式"
    ,sensorsdata         comment "埋点信息"
    ,corever2            comment "当前core"
) 
as
select a.dt
      ,a.productid             as product_id
      ,a.autoid                as auto_id
      ,a.userid                as user_id
      ,a.paychannelidid        as pay_channel_id
      ,a.used
      ,a.orderid               as order_id
      ,a.flag
      ,a.createtime            as create_time
      ,a.gettime               as get_time
      ,a.itemcount             as item_count
      ,a.systemtype            as system_type
      ,a.receivedate           as receive_date
      ,a.mt, dwd.a.couponid    as coupon_id
      ,a.packageid             as package_id
      ,a.shopitem              as shop_item
      ,a.extinfo
      ,a.vipexpiretime         as vipexpire_time
      ,a.realmoney             as real_money
      ,a.awardmoney            as award_money
      ,a.payconfigid           as pay_config_id
      ,a.corever
      ,a.deviceguid            as device_guid
      ,a.testflag              as test_flag
      ,a.baseamount            as base_amount
      ,a.version
      ,a.subpaytype            as subpay_type
      ,a.giftmoney             as gift_money
      ,a.orderinittime         as order_init_time
      ,a.cooorderextinfo       as cooorder_extinfo
      ,a.product_data
      ,a.sensorsdata
      ,b.corever2
  from dwd.dwd_trade_user_payorder            as a
  left join dim.dim_user_account_info_view    as b
    on a.productid = b.product_id
   and a.userid = b.id
;
