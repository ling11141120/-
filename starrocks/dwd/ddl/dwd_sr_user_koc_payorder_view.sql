create or replace view dwd.dwd_sr_user_koc_payorder_view (
     dt
    ,ProductId
    ,AutoId
    ,UserId
    ,PayChannelidId
    ,Used
    ,OrderId
    ,Flag
    ,CreateTime
    ,GetTime
    ,ItemCount
    ,SystemType
    ,ReceiveDate
    ,MT
    ,CouponId
    ,PackageId
    ,ShopItem
    ,ExtInfo
    ,VipExpireTime
    ,RealMoney
    ,AwardMoney
    ,PayConfigId
    ,CoreVer
    ,DeviceGUID
    ,TestFlag
    ,BaseAmount
    ,Version
    ,SubPayType
    ,GiftMoney
    ,OrderInitTime
    ,CooOrderExtInfo
    ,product_data
    ,etl_time
)
as
select dt                                                                                           as dt
      ,ProductId                                                                                    as ProductId
      ,id                                                                                           as AutoId
      ,if((UserId is null) or (UserId = ''), -99, UserId)                                           as UserId
      ,if((type is null) or (type = ''), -99, type)                                                 as PayChannelidId
      ,if((Used is null) or (Used = ''), -99, Used)                                                 as Used
      ,if((OrderId is null) or (OrderId = ''), -99, OrderId)                                        as OrderId
      ,if((Flag is null) or (Flag = ''), -99, Flag)                                                 as Flag
      ,if((CreateTime is null) or (CreateTime = ''), '1970-01-01 00:00:00', CreateTime)             as CreateTime
      ,if((GetTime is null) or (GetTime = ''), '1970-01-01 00:00:00', GetTime)                      as GetTime
      ,if(ActualAmount > 0, ActualAmount, ItemCount)                                                as ItemCount
      ,if((SystemType is null) or (SystemType = ''), -99, SystemType)                               as SystemType
      ,if((ReceiveDate is null) or (ReceiveDate = ''), '1970-01-01 00:00:00', ReceiveDate)          as ReceiveDate
      ,if((MT is null) or (MT = ''), -99, MT)                                                       as MT
      ,if((CouponId is null) or (CouponId = ''), -99, CouponId)                                     as CouponId
      ,if((PackageId is null) or (PackageId = ''), -99, PackageId)                                  as PackageId
      ,if((ShopItem is null) or (ShopItem = ''), -99, ShopItem)                                     as ShopItem
      ,if((ExtInfo is null) or (ExtInfo = ''), -99, ExtInfo)                                        as ExtInfo
      ,if((VipExpireTime is null) or (VipExpireTime = ''), -99, VipExpireTime)                      as VipExpireTime
      ,if((RealMoney is null) or (RealMoney = ''), -99, RealMoney)                                  as RealMoney
      ,if((GiveMoney is null) or (GiveMoney = ''), -99, GiveMoney)                                  as AwardMoney
      ,if((PayConfigId is null) or (PayConfigId = ''), -99, PayConfigId)                            as PayConfigId
      ,if((CoreVer is null) or (CoreVer = ''), -99, CoreVer)                                        as CoreVer
      ,if((UniqueGuid is null) or (UniqueGuid = ''), -99, UniqueGuid)                               as DeviceGUID
      ,if((TestFlag is null) or (TestFlag = ''), -99, TestFlag)                                     as TestFlag
      ,if((BaseAmount is null) or (BaseAmount = ''), -99, BaseAmount)                               as BaseAmount
      ,if((Version is null) or (Version = ''), -99, Version)                                        as Version
      ,if((SubPayType is null) or (SubPayType = ''), -99, SubPayType)                               as SubPayType
      ,if((GiftMoney is null) or (GiftMoney = ''), -99, GiftMoney)                                  as GiftMoney
      ,if((OrderInitTime is null) or (OrderInitTime = ''), '1970-01-01 00:00:00', OrderInitTime)    as OrderInitTime
      ,if((CooOrderExtInfo is null) or (CooOrderExtInfo = ''), -99, CooOrderExtInfo)                as CooOrderExtInfo
      ,ProductData                                                                                  as product_data
      ,now()                                                                                        as etl_time
  from ods.ods_book_user_payorder
 where (   (    dt >= '2024-09-01'
            and (    PackageId like '%Ps_Half%'
                  OR PackageId like '%Ps_Shop_half%'
                )
           )
        or dt >= '2025-03-06'
       )
   and TestFlag = 0
;
