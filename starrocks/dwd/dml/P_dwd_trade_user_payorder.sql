----------------------------------------------------------------
-- 程序功能： 交易域-支付成功充值订单
-- 程序名： P_dwd_trade_user_payorder
-- 目标表： dwd.dwd_trade_user_payorder
-- 开发人： xjc
-- 开发日期： 2026-05-25
----------------------------------------------------------------

insert into dwd.dwd_trade_user_payorder
select dt
      ,ProductId
      ,id                                                                                    as AutoId
      ,if(UserId is null or UserId = '', -99, UserId)                                        as UserId
      ,if(type is null or type = '', -99, type)                                              as PayChannelidId
      ,if(Used is null or Used = '', -99, Used)                                              as Used
      ,if(OrderId is null or OrderId = '', -99, OrderId)                                     as OrderId
      ,if(Flag is null or Flag = '', -99, Flag)                                              as Flag
      ,if(CreateTime is null or CreateTime = '', '1970-01-01 00:00:00', CreateTime)          as CreateTime
      ,if(GetTime is null or GetTime = '', '1970-01-01 00:00:00', GetTime)                   as GetTime
      ,if(ActualAmount > 0 , ActualAmount, ItemCount)                                        as ItemCount
      ,if(SystemType is null or SystemType = '', -99, SystemType)                            as SystemType
      ,if(ReceiveDate is null or ReceiveDate = '', '1970-01-01 00:00:00', ReceiveDate)       as ReceiveDate
      ,if(MT is null or MT = '', -99, MT)                                                    as MT
      ,if(CouponId is null or CouponId = '', -99, CouponId)                                  as CouponId
      ,if(PackageId is null or PackageId = '', -99, PackageId)                               as PackageId
      ,if(ShopItem is null or ShopItem = '', -99, ShopItem)                                  as ShopItem
      ,if(ExtInfo is null or ExtInfo = '', -99, ExtInfo)                                     as ExtInfo
      ,if(VipExpireTime is null or VipExpireTime = '', -99, VipExpireTime)                   as VipExpireTime
      ,if(RealMoney is null or RealMoney = '', -99, RealMoney)                               as RealMoney
      ,if(GiveMoney is null or GiveMoney = '', -99, GiveMoney)                               as AwardMoney
      ,if(PayConfigId is null or PayConfigId = '', -99, PayConfigId)                         as PayConfigId
      ,if(CoreVer is null or CoreVer = '', -99, CoreVer)                                     as CoreVer
      ,if(UniqueGuid is null or UniqueGuid = '', -99, UniqueGuid)                            as DeviceGUID
      ,if(TestFlag is null or TestFlag = '', -99, TestFlag)                                  as TestFlag
      ,if(BaseAmount is null or BaseAmount = '', -99, BaseAmount)                            as BaseAmount
      ,if(Version is null or Version = '', -99, Version)                                     as Version
      ,if(SubPayType is null or SubPayType = '', -99, SubPayType)                            as SubPayType
      ,if(GiftMoney is null or GiftMoney = '', -99, GiftMoney)                               as GiftMoney
      ,if(OrderInitTime is null or OrderInitTime = '', '1970-01-01 00:00:00', OrderInitTime) as OrderInitTime
      ,if(CooOrderExtInfo is null or CooOrderExtInfo = '', -99, CooOrderExtInfo)             as CooOrderExtInfo
      ,ProductData                                                                           as product_data
      ,SensorsData                                                                           as SensorsData
      ,now()                                                                                 as etl_time
      ,get_json_string(SensorsData, '$.subscribe_mode')                                      as subscribe_mode
from ods.ods_book_user_payorder
where dt >= date_sub('${dt}',interval 1 day)
  and dt < date_add('{dt}',interval 1 day )
  and TestFlag=0;