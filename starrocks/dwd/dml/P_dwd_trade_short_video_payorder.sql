insert into dwd.dwd_trade_short_video_payorder
  with ref_ord as (select Id
                        , ClassType
                        , get_json_string(Args, '$.OrderId') as orderid
                        , ScheduleTime
                        , Status
                        , ExecCount
                        , ExecTime
                     from ods.ods_short_video_commandtask
                    where ScheduleTime >= '${bf_1_dt}'
                   )
select dt
     , product_id
     , id
     , status
     , `type`
     , userid
     , used
     , orderid
     , flag
     , createtime
     , gettime
     , itemcount
     , systemtype
     , receivedate
     , MT
     , CouponId
     , PackageId
     , ShopItem
     , ExtInfo
     , VipExpireTime
     , RealMoney
     , GiveMoney
     , Amount
     , ProdId
     , PayConfigId
     , CoreVer
     , UniqueGuid
     , TestFlag
     , BuyToken
     , BaseAmount
     , version
     , SubPayType
     , GiftMoney
     , OrderInitTime
     , CooOrderExtInfo
     , CustomData
     , ScheduleTime
     , etl_tm
  from (select dt
             , 6833  as product_id
             , id
             , 0     as Status
             , `type`
             , userid
             , used
             , orderid
             , flag
             , createtime
             , gettime
             , itemcount
             , systemtype
             , receivedate
             , MT
             , CouponId
             , PackageId
             , ShopItem
             , ExtInfo
             , VipExpireTime
             , RealMoney
             , GiveMoney
             , Amount
             , ProdId
             , PayConfigId
             , CoreVer
             , UniqueGuid
             , TestFlag
             , BuyToken
             , BaseAmount
             , version
             , SubPayType
             , GiftMoney
             , OrderInitTime
             , CooOrderExtInfo
             , CustomData
             , null  as ScheduleTime
             , now() as etl_tm
          from ods.ods_tidb_short_video_payorder
         where dt >= '${bf_1_dt}'
         union all
        select date(ScheduleTime) as dt
             , 6833               as product_id
             , b.id
             , 1                  as Status
             , b.`type`
             , b.userid
             , b.used
             , b.orderid
             , b.flag
             , b.createtime
             , b.gettime
             , b.itemcount * -1
             , b.systemtype
             , b.receivedate
             , b.MT
             , b.CouponId
             , b.PackageId
             , b.ShopItem
             , b.ExtInfo
             , b.VipExpireTime
             , b.RealMoney
             , b.GiveMoney
             , b.Amount
             , b.ProdId
             , b.PayConfigId
             , b.CoreVer
             , b.UniqueGuid
             , b.TestFlag
             , b.BuyToken
             , b.BaseAmount * -1
             , b.Version
             , b.SubPayType
             , b.GiftMoney
             , b.OrderInitTime
             , b.
            CooOrderExtInfo
             , b.CustomData
             , ScheduleTime
             , NOW()              as etl_tm
          from ods.ods_tidb_short_video_payorder b
          join ref_ord
          on b.orderid = ref_ord.orderid
        ) a;