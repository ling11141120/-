-- 阅读用户信息
create or replace view dim.dim_user_userdata_view (
     product_id                       comment "产品id"
    ,id                               comment "用户id"
    ,has_device_charge                comment "设备是否充值"
    ,first_charge_tm                  comment "首次充值时间"
    ,charge_count                     comment "充值次数"
    ,last_buy_book_id                 comment "最后一次购买的书籍id"
    ,last_chapter_id                  comment "最后一次获取的章节id"
    ,has_send_gift                    comment "是否已赠送复充优惠券"
    ,gift_expire_tm                   comment "复充优惠券过期时间"
    ,vip_expire_tm                    comment "会员过期时间"
    ,is_continuity_vip                comment "是否为连续包月会员"
    ,get_gift_tm                      comment "会员领取礼券时间"
    ,vip_type                         comment "会员类型"
    ,vip_type2                        comment "会员类型"
    ,next_vip_type_retry_tm           comment "下次会员类型重算时间"
    ,small_inviteaward_expire_tm      comment "小程序邀请奖励过期时间"
    ,exchange_new_user_tm             comment "新用户免费的到期时间"
    ,total_sign_count                 comment "累计签到次数"
    ,noad_expire_tm                   comment "无广告过期时间"
    ,device                           comment "设备号"
    ,sys_releasever                   comment "固件版本"
    ,vip_devicegu_id                  comment "会员号设备"
    ,vip_first_buy_tm                 comment "首次购买会员的时间"
    ,block_devices                    comment "黑名单设备号"
    ,coin                             comment "金币"
    ,today_read_times                 comment "今日阅读时间"
    ,total_read_times                 comment "总计阅读时长"
    ,free_novelnoad_tm                comment "免广告时间"
    ,today                            comment "今天"
    ,today_charge                     comment "今日充值"
    ,head_frame                       comment "新人福利头像框"
    ,read_page_last_tm                comment "阅读页上一次弹出新人福利时间"
    ,last_addbook_shelf_tm            comment "上一次加入书到书架的时间"
    ,low_vip_expire_tm                comment "会员过期时间"
    ,next_lowvip_type_retry_tm        comment "下次普通会员类型重算时间"
    ,last_buy_svip_tm                 comment "上一次购买正常无限畅享svip会员卡时间"
    ,last_allfree_show_tm             comment "上一次新人免费期间半屏弹窗的时间"
    ,svip_card_price                  comment "购买的svip卡价格"
    ,vip_expire_time_seconds          comment "会员过期时间,svip活动赠送的剩余秒数"
    ,low_vip_expire_time_seconds      comment "会员过期时间,vip活动赠送的剩余秒数"
    ,new_vip_model                    comment "普通vip是否转换成新的模式"
    ,new_svip_model                   comment "svip是否转换成新的模式"
    ,last_vip_token                   comment "上次购买的vip或者svip的token"
    ,last_item_id                     comment "上次购买的vip或者svip的itemid"
    ,low_vip_seconds_start_tm         comment "vip活动赠送开始时间"
    ,vip_seconds_start_tm             comment "svip活动赠送开始时间"
    ,vip_device_id                    comment "vip设备id"
    ,blocked_device_id_list           comment "黑名单设备id列表"
    ,vip_card_price                   comment "购买的vip卡价格"
    ,deep_link_platform               comment "deeplink来源平台：-1不是动态链接，0：fb，1：firebase，2：appsflyer"
    ,adjust_id                        comment "adjustid"
    ,today_item_count                 comment "今日充值美元"
    ,energy_ripe_remind               comment "能量成熟提醒"
    ,energy_stolen_remind             comment "能量被偷提醒"
    ,energy_expire_remind             comment "能量过期提醒"
    ,energy_week_rank_times           comment "周公益大使获取次数"
    ,energy_medal_wear                comment "能量勋章佩戴"
    ,bonussign_card_tm                comment "阅币福利包到期时间"
    ,bonussign_cardplus_tm            comment "阅币福利包plus到期时间"
    ,user_shop_type                   comment "用户商城类型：0旧商城，1新商城"
    ,last_buy_bonussign_card_tm       comment "上次购买福利包时间"
    ,last_buybonussign_cardplus_tm    comment "上次购买plus福利包时间"
    ,user_maxcharge_amount            comment "最高充值档位"
    ,last_pay_mentid                  comment "上一次 第三方支付信息"
    ,acthead_frame                    comment "活动头像框"
    ,last_charge_tm                   comment "上一次充值时间"
    ,row_update_tm                    comment "更新时间"
    ,is_new_jifen_user                comment "是否进入过新积分ui"
    ,user_usehead_frame               comment "用户当前佩戴的头像框"
    ,user_usehead_frame_expire_tm     comment "用户当前佩戴的头像框的过期时间"
    ,user_usehead_frame_type          comment "用户当前佩戴的头像框类型"
    ,ram                              comment "手机内存"
    ,brand                            comment "手机品牌"
    ,row_create_tm                    comment "创建时间"
    ,dev_mdl                          comment "设备型号"
)
comment '阅读用户数据视图'
as
select product_id
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
      ,if (SVipCardActualPrice > 0,SVipCardActualPrice,SVipCardPrice) as SVipCardPrice
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
      ,if (VipCardActualPrice > 0,VipCardActualPrice,VipCardPrice) as VipCardPrice
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
      ,Device2    as dev_mdl
  from ods.ods_tidb_readernovel_tidb_userdata
;