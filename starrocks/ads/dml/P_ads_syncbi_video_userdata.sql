----------------------------------------------------------------
-- 程序功能： 海阅PWA用户阅读时长数据同步至海剧
-- 程序名： P_ads_syncbi_video_userdata
-- 目标表： ads.syncbi_video_userdata
-- 负责人：lwbl
-- 开发日期： 2026-06-22
----------------------------------------------------------------
insert overwrite ads.syncbi_video_userdata (
     product_id
    ,Id
    ,HasDeviceCharge
    ,FirstChargeTime
    ,ChargeCount
    ,LastBuyBookId
    ,LastChapterId
    ,HasSendGift
    ,GiftExpireTime
    ,VipExpireTime
    ,IsContinuityVip
    ,GetGiftTime
    ,VipType
    ,VipType2
    ,NextVipTypeRetryTime
    ,SmallInviteAwardExpireTime
    ,ExchangeNewUserTime
    ,TotalSignCount
    ,NoAdExpireTime
    ,Device
    ,SysReleaseVer
    ,VipDeviceGuid
    ,VipFirstBuyTime
    ,BlockDevices
    ,Coin
    ,TodayReadTime
    ,TotalReadTime
    ,FreeNovelNoAdTime
    ,Today
    ,TodayCharge
    ,HeadFrame
    ,ReadPageLastTime
    ,LastAddBookshelfTime
    ,LowVipExpireTime
    ,NextLowVipTypeRetryTime
    ,LastBuySvipTime
    ,LastAllFreeShowTime
    ,SVipCardPrice
    ,VipExpireTimeSeconds
    ,LowVipExpireTimeSeconds
    ,NewVipModel
    ,NewSvipModel
    ,LastVipToken
    ,LastItemId
    ,LowVipSecondsStartTime
    ,VipSecondsStartTime
    ,VipDeviceId
    ,BlockedDeviceIdList
    ,VipCardPrice
    ,DeepLinkPlatform
    ,AdjustId
    ,TodayItemCount
    ,EnergyRipeRemind
    ,EnergyStolenRemind
    ,EnergyExpireRemind
    ,EnergyWeekRankTimes
    ,EnergyMedalWear
    ,BonusSignCardTime
    ,BonusSignCardPlusTime
    ,UserShopType
    ,LastBuyBonusSignCardTime
    ,LastBuyBonusSignCardPlusTime
    ,UserMaxChargeAmount
    ,LastPaymentId
    ,ActHeadFrame
    ,LastChargeTime
    ,row_update_time
    ,IsNewJiFenUser
    ,UserUseHeadFrame
    ,UserUseHeadFrameExpireTime
    ,UserUseHeadFrameType
    ,Ram
    ,Brand
    ,row_create_time
    ,VipCardType
    ,VipCardActualPrice
    ,SVipCardActualPrice
    ,Device2
    ,UserSource
    ,etl_tm
)
with video_user_device as (
    select Id               as video_user_id
         , UniqueCdReaderId as device_id
      from ods.ods_tidb_short_video_accountinfo
     where Id > 0
       and UniqueCdReaderId is not null
       and UniqueCdReaderId != ''

    union

    select Id                as video_user_id
         , UniqueCdReaderId2 as device_id
      from ods.ods_tidb_short_video_accountinfo
     where Id > 0
       and UniqueCdReaderId2 is not null
       and UniqueCdReaderId2 != ''

    union

    select AccountId as video_user_id
         , DeviceId  as device_id
      from ods.ods_tidb_short_video_device_account
     where AccountId > 0
       and DeviceId is not null
       and DeviceId != ''
       and IsBind = 1
       and coalesce(IsDelete, 0) = 0
)
, valid_read_user_mapping as (
    select read_user_id
         , video_user_id
         , mapping_time
      from (
          select pwa.user_id        as read_user_id
               , pwa.video_user_id  as video_user_id
               , pwa.create_time    as mapping_time
               , row_number() over (
                     partition by pwa.user_id
                     order by pwa.create_time desc, pwa.id desc
                 ) as rn
      from ods.ods_tidb_readerlog_en_log_pwaseriesIdlog pwa
      join video_user_device device_map
        on pwa.video_user_id = device_map.video_user_id
       and pwa.unique_cd_reader_id = device_map.device_id
     where pwa.user_id > 0
       and pwa.video_user_id > 0
       and pwa.unique_cd_reader_id is not null
       and pwa.unique_cd_reader_id != ''
      ) t
     where rn = 1
)
, matched_userdata as (
    select *
      from (
          select u.*
               , mapping.video_user_id
               , row_number() over (
                     partition by u.product_id, mapping.video_user_id
                     order by mapping.mapping_time desc, mapping.read_user_id desc
                 ) as rn
            from ods.ods_tidb_readernovel_tidb_userdata u
            join valid_read_user_mapping mapping
              on mapping.read_user_id = u.Id
      ) t
     where rn = 1
)
select u.product_id
     , u.video_user_id as Id
     , u.HasDeviceCharge
     , u.FirstChargeTime
     , u.ChargeCount
     , u.LastBuyBookId
     , u.LastChapterId
     , u.HasSendGift
     , u.GiftExpireTime
     , u.VipExpireTime
     , u.IsContinuityVip
     , u.GetGiftTime
     , u.VipType
     , u.VipType2
     , u.NextVipTypeRetryTime
     , u.SmallInviteAwardExpireTime
     , u.ExchangeNewUserTime
     , u.TotalSignCount
     , u.NoAdExpireTime
     , u.Device
     , u.SysReleaseVer
     , u.VipDeviceGuid
     , u.VipFirstBuyTime
     , u.BlockDevices
     , u.Coin
     , u.TodayReadTime
     , u.TotalReadTime
     , u.FreeNovelNoAdTime
     , u.Today
     , u.TodayCharge
     , u.HeadFrame
     , u.ReadPageLastTime
     , u.LastAddBookshelfTime
     , u.LowVipExpireTime
     , u.NextLowVipTypeRetryTime
     , u.LastBuySvipTime
     , u.LastAllFreeShowTime
     , u.SVipCardPrice
     , u.VipExpireTimeSeconds
     , u.LowVipExpireTimeSeconds
     , u.NewVipModel
     , u.NewSvipModel
     , u.LastVipToken
     , u.LastItemId
     , u.LowVipSecondsStartTime
     , u.VipSecondsStartTime
     , u.VipDeviceId
     , u.BlockedDeviceIdList
     , u.VipCardPrice
     , u.DeepLinkPlatform
     , u.AdjustId
     , u.TodayItemCount
     , u.EnergyRipeRemind
     , u.EnergyStolenRemind
     , u.EnergyExpireRemind
     , u.EnergyWeekRankTimes
     , u.EnergyMedalWear
     , u.BonusSignCardTime
     , u.BonusSignCardPlusTime
     , u.UserShopType
     , u.LastBuyBonusSignCardTime
     , u.LastBuyBonusSignCardPlusTime
     , u.UserMaxChargeAmount
     , u.LastPaymentId
     , u.ActHeadFrame
     , u.LastChargeTime
     , u.row_update_time
     , u.IsNewJiFenUser
     , u.UserUseHeadFrame
     , u.UserUseHeadFrameExpireTime
     , u.UserUseHeadFrameType
     , u.Ram
     , u.Brand
     , u.row_create_time
     , u.VipCardType
     , u.VipCardActualPrice
     , u.SVipCardActualPrice
     , u.Device2
     , u.UserSource
     , now() as etl_tm
  from matched_userdata u
;
