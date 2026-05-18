----------------------------------------------------------------
-- 目标表：ods_tidb_readernovel_tidb_userdata
-- 来源实例：xx-mysql-slave
-- 来源表：
--         readernovel_tidb_fr.userdata
--         readernovel_tidb_pt.userdata
--         readernovel_tidb_ft.userdata
--         readernovel_tidb_en.userdata
--         readernovel_tidb_ru.userdata
--         readernovel_tidb_sp.userdata
--         readernovel_tidb_jp.userdata
--         readernovel_tidb_id.userdata
--         readernovel_tidb_th.userdata
--         readernovel_tidb_and2.userdata
--         readernovel_tidb_cd2.userdata
-- 来源负责人：未知
-- 开发人：050239
-- 开发日期：2026-05-15
----------------------------------------------------------------

create table if not exists ods.ods_tidb_readernovel_tidb_userdata (
     product_id                   int            not null                  comment "产品id"
    ,Id                           bigint         not null                  comment "用户id"
    ,HasDeviceCharge              tinyint                                  comment "设备是否充值"
    ,FirstChargeTime              datetime                                 comment "首次充值时间"
    ,ChargeCount                  int                                      comment "充值次数"
    ,LastBuyBookId                bigint                                   comment "最后一次购买的书籍id"
    ,LastChapterId                bigint                                   comment "最后一次获取的章节id"
    ,HasSendGift                  tinyint                                  comment "是否已赠送复充优惠券"
    ,GiftExpireTime               datetime                                 comment "复充优惠券过期时间"
    ,VipExpireTime                datetime                                 comment "会员过期时间"
    ,IsContinuityVip              tinyint                                  comment "是否为连续包月会员"
    ,GetGiftTime                  datetime                                 comment "会员领取礼券时间"
    ,VipType                      int                                      comment "会员类型"
    ,VipType2                     int                                      comment "会员类型"
    ,NextVipTypeRetryTime         datetime                                 comment "下次会员类型重算时间"
    ,SmallInviteAwardExpireTime   datetime                                 comment "小程序邀请奖励过期时间"
    ,ExchangeNewUserTime          datetime                                 comment "新用户免费的到期时间"
    ,TotalSignCount               int                                      comment "累计签到次数"
    ,NoAdExpireTime               datetime                                 comment "无广告过期时间"
    ,Device                       string                                   comment "设备号"
    ,SysReleaseVer                string                                   comment "固件版本"
    ,VipDeviceGuid                string                                   comment "会员号设备"
    ,VipFirstBuyTime              datetime                                 comment "首次购买会员的时间"
    ,BlockDevices                 string                                   comment "黑名单设备号"
    ,Coin                         int                                      comment "金币"
    ,TodayReadTime                int                                      comment "今日阅读时间"
    ,TotalReadTime                bigint                                   comment "总计阅读时长"
    ,FreeNovelNoAdTime            datetime                                 comment "免广告时间"
    ,Today                        datetime                                 comment "今天"
    ,TodayCharge                  int                                      comment "今日充值"
    ,HeadFrame                    varchar(512)                             comment "新人福利头像框"
    ,ReadPageLastTime             datetime                                 comment "阅读页上一次弹出新人福利时间"
    ,LastAddBookshelfTime         datetime                                 comment "上一次加入书到书架的时间"
    ,LowVipExpireTime             datetime                                 comment "会员过期时间"
    ,NextLowVipTypeRetryTime      datetime                                 comment "下次普通会员类型重算时间"
    ,LastBuySvipTime              datetime                                 comment "上一次购买正常无限畅享svip会员卡时间"
    ,LastAllFreeShowTime          datetime                                 comment "上一次新人免费期间半屏弹窗的时间"
    ,SVipCardPrice                int            not null                  comment "购买的svip卡价格"
    ,VipExpireTimeSeconds         bigint                                   comment "会员过期时间,Svip活动赠送的剩余秒数"
    ,LowVipExpireTimeSeconds      bigint                                   comment "会员过期时间,VIP活动赠送的剩余秒数"
    ,NewVipModel                  int                                      comment "普通vip是否转换成新的模式"
    ,NewSvipModel                 int                                      comment "Svip是否转换成新的模式"
    ,LastVipToken                 varchar(512)                             comment "上次购买的vip或者svip的token"
    ,LastItemId                   varchar(512)                             comment "上次购买的vip或者svip的itemid"
    ,LowVipSecondsStartTime       datetime                                 comment "vip活动赠送开始时间"
    ,VipSecondsStartTime          datetime                                 comment "SVIP活动赠送开始时间"
    ,VipDeviceId                  bigint                                   comment "vip设备id"
    ,BlockedDeviceIdList          varchar(1024)                            comment "黑名单设备id列表"
    ,VipCardPrice                 int            not null                  comment "购买的vip卡价格"
    ,DeepLinkPlatform             int                                      comment "DeepLink来源平台：-1不是动态链接，0：FB，1：firebase，2：appsflyer"
    ,AdjustId                     varchar(250)                             comment "Adjustid"
    ,TodayItemCount               int                                      comment "今日充值美元"
    ,EnergyRipeRemind             tinyint                                  comment "能量成熟提醒"
    ,EnergyStolenRemind           tinyint                                  comment "能量被偷提醒"
    ,EnergyExpireRemind           tinyint                                  comment "能量过期提醒"
    ,EnergyWeekRankTimes          int                                      comment "周公益大使获取次数"
    ,EnergyMedalWear              varchar(512)                             comment "能量勋章佩戴"
    ,BonusSignCardTime            datetime                                 comment "阅币福利包到期时间"
    ,BonusSignCardPlusTime        datetime                                 comment "阅币福利包plus到期时间"
    ,UserShopType                 int                                      comment "用户商城类型：0旧商城，1新商城"
    ,LastBuyBonusSignCardTime     datetime                                 comment "上次购买福利包时间"
    ,LastBuyBonusSignCardPlusTime datetime                                 comment "上次购买plus福利包时间"
    ,UserMaxChargeAmount          decimal(10, 0) not null                  comment "最高充值档位"
    ,LastPaymentId                varchar(50)                              comment "上一次 第三方支付信息"
    ,ActHeadFrame                 varchar(500)                             comment "活动头像框"
    ,LastChargeTime               datetime                                 comment "上一次充值时间"
    ,row_update_time              datetime                                 comment "更新时间"
    ,IsNewJiFenUser               tinyint                                  comment "是否进入过新积分UI"
    ,UserUseHeadFrame             varchar(512)                             comment "用户当前佩戴的头像框"
    ,UserUseHeadFrameExpireTime   datetime                                 comment "用户当前佩戴的头像框的过期时间"
    ,UserUseHeadFrameType         varchar(50)                              comment "用户当前佩戴的头像框类型"
    ,Ram                          int                                      comment "手机内存"
    ,Brand                        varchar(255)                             comment "手机品牌"
    ,row_create_time              datetime                                 comment "创建时间"
    ,VipCardType                  int                                      comment "最后购买的vip卡的类型，1：周，2：月，3：季，4：年"
    ,VipCardActualPrice           decimal(18, 2)                           comment "vip卡的上次购买价格，精准价格"
    ,SVipCardActualPrice          decimal(18, 2)                           comment "svip卡的上次购买价格，精准价格"
    ,Device2                      varchar(765)                             comment "设备2"
    ,sr_createtime                datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime                datetime       default current_timestamp comment "starrocks数据更新时间"
    ,UserSource                   int                                      comment "海剧pwa用户来源标签：0 否，1 是"
    ,index index_product_id (product_id) using bitmap comment '产品id索引'
)
primary key(product_id, id)
comment "OLAP"
distributed by hash(product_id, id) buckets 20
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "row_create_time, Id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
