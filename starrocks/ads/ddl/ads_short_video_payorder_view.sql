create or replace view ads.ads_short_video_payorder_view (
     dt                  comment "createtime分区"
    ,product_id          comment "产品id 6833海外短剧"
    ,id                  comment "自增id"
    ,type                comment "类型"
    ,user_id             comment "用户id"
    ,used                comment "是否执行"
    ,order_id            comment "订单id"
    ,flag                comment "标识"
    ,create_time         comment "创建时间"
    ,get_time            comment "获取时间"
    ,item_count          comment "金额数"
    ,system_type         comment "系统类型"
    ,receive_date        comment "被接收时间"
    ,mt                  comment "终端"
    ,coupon_id           comment "礼券id"
    ,package_id          comment "存放充值页面来源"
    ,shop_item           comment "充值类型"
    ,extinfo             comment "信息"
    ,vip_expire_time     comment "充值订阅卡时，过期时间"
    ,real_money          comment "给的阅币数"
    ,give_money          comment "暂时无用"
    ,amount              comment "暂时无用"
    ,prod_id             comment "暂时无用"
    ,pay_config_id       comment "充值项的id，可能不准确"
    ,corever             comment "包体"
    ,unique_guid         comment "用户设备id"
    ,test_flag           comment "是否是测试号充值（0正式，1测试）"
    ,buy_token           comment "购买时候的google的token"
    ,base_amount         comment "分成后的数量"
    ,version             comment "购买时，用户客户端的版本号"
    ,subpay_type         comment "充值渠道"
    ,gift_money          comment "充值赠送的礼券数(可能不准确)"
    ,order_init_time     comment "用户订单创建时间"
    ,cooorder_extinfo    comment "合作方订单扩展"
    ,custom_data         comment "自定义数据，透传，json格式"
    ,corever2            comment "当前core"
)
comment "海外短剧-用户充值表"
as
select a.dt
     , 6833                        as product_id
     , a.id
     , a.type
     , a.userid          as user_id
     , a.used
     , a.orderid         as order_id
     , a.flag
     , a.createtime      as create_time
     , a.gettime         as get_time
     , a.itemcount       as item_count
     , a.systemtype      as system_type
     , a.receivedate     as receive_date
     , a.mt
     , a.couponid        as coupon_id
     , a.packageid       as package_id
     , a.shopitem        as shop_item
     , a.extinfo
     , a.vipexpiretime   as vip_expire_time
     , a.realmoney       as real_money
     , a.givemoney       as give_money
     , a.amount
     , a.prodid          as prod_id
     , a.payconfigid     as pay_config_id
     , a.corever
     , a.uniqueguid      as unique_guid
     , a.testflag        as test_flag
     , a.buytoken        as buy_token
     , a.baseamount      as base_amount
     , a.version
     , a.subpaytype      as subpay_type
     , a.giftmoney       as gift_money
     , a.orderinittime   as order_init_time
     , a.cooorderextinfo as cooorder_extinfo
     , a.customdata      as custom_data
     , b.corever2
  from ods.ods_tidb_short_video_payorder                  as a
  left outer join dim.dim_short_video_user_accountinfo    as b
    on a.userid = dim.b.user_id
;