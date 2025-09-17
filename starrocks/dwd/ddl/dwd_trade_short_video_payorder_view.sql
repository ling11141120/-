create or replace view dwd.dwd_trade_short_video_payorder_view (
     dt
    ,product_id
    ,id
    ,status
    ,type
    ,user_id
    ,used
    ,order_id
    ,flag
    ,create_time
    ,get_time
    ,item_count
    ,system_type
    ,receive_date
    ,mt
    ,coupon_id
    ,package_id
    ,shop_item
    ,extinfo
    ,vip_expire_time
    ,real_money
    ,give_money
    ,amount
    ,prod_id
    ,pay_config_id
    ,corever
    ,unique_guid
    ,test_flag
    ,buy_token
    ,base_amount
    ,version
    ,subpay_type
    ,gift_money
    ,order_init_time
    ,cooorder_extinfo
    ,custom_data
    ,ScheduleTime
    ,etl_tm
)
as
select a.dt
      ,a.product_id
      ,a.id
      ,a.status
      ,a.type
      ,a.userid             as user_id
      ,a.used
      ,a.orderid            as order_id
      ,a.flag
      ,a.createtime         as create_time
      ,a.gettime            as get_time
      ,a.itemcount          as item_count
      ,a.systemtype         as system_type
      ,a.receivedate        as receive_date
      ,a.MT
      ,a.CouponId           as coupon_id
      ,a.PackageId          as package_id
      ,a.ShopItem           as shop_item
      ,a.ExtInfo
      ,a.VipExpireTime      as vip_expire_time
      ,a.RealMoney          as real_money
      ,a.GiveMoney          as give_money
      ,a.Amount
      ,a.ProdId             as prod_id
      ,a.PayConfigId        as pay_config_id
      ,a.CoreVer
      ,a.UniqueGuid         as unique_guid
      ,a.TestFlag           as test_flag
      ,a.BuyToken           as buy_token
      ,a.BaseAmount         as base_amount
      ,a.Version
      ,a.SubPayType         as subpay_type
      ,a.GiftMoney          as gift_money
      ,a.OrderInitTime      as order_init_time
      ,a.CooOrderExtInfo    as cooorder_extinfo
      ,a.CustomData         as custom_data
      ,a.ScheduleTime
      ,a.etl_tm
  from (select dt
              ,6833    as product_id
              ,id
              ,0       as Status
              ,type
              ,userid
              ,used
              ,orderid
              ,flag
              ,createtime
              ,gettime
              ,itemcount
              ,systemtype
              ,receivedate
              ,MT
              ,CouponId
              ,PackageId
              ,ShopItem
              ,ExtInfo
              ,VipExpireTime
              ,RealMoney
              ,GiveMoney
              ,Amount
              ,ProdId
              ,PayConfigId
              ,CoreVer
              ,UniqueGuid
              ,TestFlag
              ,BuyToken
              ,BaseAmount
              ,Version
              ,SubPayType
              ,GiftMoney
              ,OrderInitTime
              ,CooOrderExtInfo
              ,CustomData
              ,null    as ScheduleTime
              ,now()   as etl_tm
          from ods.ods_tidb_short_video_payorder
         where dt >= '2024-09-01'
         union ALL
        select date(c.ScheduleTime)                as dt
              ,6833                                as product_id
              ,b.id
              ,1                                   as Status
              ,b.type
              ,b.userid
              ,b.used
              ,b.orderid
              ,b.flag
              ,b.createtime
              ,b.gettime
              ,b.itemcount * -1                    as itemcount
              ,b.systemtype
              ,b.receivedate
              ,b.MT
              ,b.CouponId
              ,b.PackageId
              ,b.ShopItem
              ,b.ExtInfo
              ,b.VipExpireTime
              ,b.RealMoney
              ,b.GiveMoney
              ,b.Amount
              ,b.ProdId
              ,b.PayConfigId
              ,b.CoreVer
              ,b.UniqueGuid
              ,b.TestFlag
              ,b.BuyToken
              ,b.BaseAmount * -1                   as BaseAmount
              ,b.Version
              ,b.SubPayType
              ,b.GiftMoney
              ,b.OrderInitTime
              ,b.CooOrderExtInfo
              ,b.CustomData
              ,c.ScheduleTime
              ,now()                                as etl_tm
          from ods.ods_tidb_short_video_payorder    as b
          join (select Id
                      ,ClassType
                      ,get_json_string(Args,'$.OrderId')    as orderid
                      ,ScheduleTime
                      ,Status
                      ,ExecCount
                      ,ExecTime
                  from ods.ods_short_video_commandtask
                 where ScheduleTime >= '2024-09-01'
               )                                    as c
            ON b.orderid = c.orderid
       )                                            as a
;