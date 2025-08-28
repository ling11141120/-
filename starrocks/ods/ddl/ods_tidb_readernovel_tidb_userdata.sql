----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_userdata
-- 来源实例： xx-mysql-slave
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
-- 采集工具： SeaTunnel
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_userdata;
CREATE TABLE ods.ods_tidb_readernovel_tidb_userdata (
     product_id                      INT(11)        NOT NULL                   COMMENT "产品id"
    ,Id                              BIGINT(20)     NOT NULL                   COMMENT "用户id"
    ,HasDeviceCharge                 TINYINT(4)                                COMMENT "设备是否充值"
    ,FirstChargeTime                 DATETIME                                  COMMENT "首次充值时间"
    ,ChargeCount                     INT(11)                                   COMMENT "充值次数"
    ,LastBuyBookId                   BIGINT(20)                                COMMENT "最后一次购买的书籍id"
    ,LastChapterId                   BIGINT(20)                                COMMENT "最后一次获取的章节id"
    ,HasSendGift                     TINYINT(4)                                COMMENT "是否已赠送复充优惠券"
    ,GiftExpireTime                  DATETIME                                  COMMENT "复充优惠券过期时间"
    ,VipExpireTime                   DATETIME                                  COMMENT "会员过期时间"
    ,IsContinuityVip                 TINYINT(4)                                COMMENT "是否为连续包月会员"
    ,GetGiftTime                     DATETIME                                  COMMENT "会员领取礼券时间"
    ,VipType                         INT(11)                                   COMMENT "会员类型"
    ,VipType2                        INT(11)                                   COMMENT "会员类型"
    ,NextVipTypeRetryTime            DATETIME                                  COMMENT "下次会员类型重算时间"
    ,SmallInviteAwardExpireTime      DATETIME                                  COMMENT "小程序邀请奖励过期时间"
    ,ExchangeNewUserTime             DATETIME                                  COMMENT "新用户免费的到期时间"
    ,TotalSignCount                  INT(11)                                   COMMENT "累计签到次数"
    ,NoAdExpireTime                  DATETIME                                  COMMENT "无广告过期时间"
    ,Device                          VARCHAR(65533)                            COMMENT "设备号"
    ,SysReleaseVer                   VARCHAR(65533)                            COMMENT "固件版本"
    ,VipDeviceGuid                   VARCHAR(65533)                            COMMENT "会员号设备"
    ,VipFirstBuyTime                 DATETIME                                  COMMENT "首次购买会员的时间"
    ,BlockDevices                    VARCHAR(65533)                            COMMENT "黑名单设备号"
    ,Coin                            INT(11)                                   COMMENT "金币"
    ,TodayReadTime                   INT(11)                                   COMMENT "今日阅读时间"
    ,TotalReadTime                   BIGINT(20)                                COMMENT "总计阅读时长"
    ,FreeNovelNoAdTime               DATETIME                                  COMMENT "免广告时间"
    ,Today                           DATETIME                                  COMMENT "今天"
    ,TodayCharge                     INT(11)                                   COMMENT "今日充值"
    ,HeadFrame                       VARCHAR(512)                              COMMENT "新人福利头像框"
    ,ReadPageLastTime                DATETIME                                  COMMENT "阅读页上一次弹出新人福利时间"
    ,LastAddBookshelfTime            DATETIME                                  COMMENT "上一次加入书到书架的时间"
    ,LowVipExpireTime                DATETIME                                  COMMENT "会员过期时间"
    ,NextLowVipTypeRetryTime         DATETIME                                  COMMENT "下次普通会员类型重算时间"
    ,LastBuySvipTime                 DATETIME                                  COMMENT "上一次购买正常无限畅享svip会员卡时间"
    ,LastAllFreeShowTime             DATETIME                                  COMMENT "上一次新人免费期间半屏弹窗的时间"
    ,SVipCardPrice                   INT(11)         NOT NULL                  COMMENT "购买的svip卡价格"
    ,VipExpireTimeSeconds            BIGINT(20)                                COMMENT "会员过期时间,Svip活动赠送的剩余秒数"
    ,LowVipExpireTimeSeconds         BIGINT(20)                                COMMENT "会员过期时间,VIP活动赠送的剩余秒数"
    ,NewVipModel                     INT(11)                                   COMMENT "普通vip是否转换成新的模式"
    ,NewSvipModel                    INT(11)                                   COMMENT "Svip是否转换成新的模式"
    ,LastVipToken                    VARCHAR(512)                              COMMENT "上次购买的vip或者svip的token"
    ,LastItemId                      VARCHAR(512)                              COMMENT "上次购买的vip或者svip的itemid"
    ,LowVipSecondsStartTime          DATETIME                                  COMMENT "vip活动赠送开始时间"
    ,VipSecondsStartTime             DATETIME                                  COMMENT "SVIP活动赠送开始时间"
    ,VipDeviceId                     BIGINT(20)                                COMMENT "vip设备id"
    ,BlockedDeviceIdList             VARCHAR(1024)                             COMMENT "黑名单设备id列表"
    ,VipCardPrice                    INT(11)         NOT NULL                  COMMENT "购买的vip卡价格"
    ,DeepLinkPlatform                INT(11)                                   COMMENT "DeepLink来源平台：-1不是动态链接，0：FB，1：firebase，2：appsflyer"
    ,AdjustId                        VARCHAR(250)                              COMMENT "Adjustid"
    ,TodayItemCount                  INT(11)                                   COMMENT "今日充值美元"
    ,EnergyRipeRemind                TINYINT(4)                                COMMENT "能量成熟提醒"
    ,EnergyStolenRemind              TINYINT(4)                                COMMENT "能量被偷提醒"
    ,EnergyExpireRemind              TINYINT(4)                                COMMENT "能量过期提醒"
    ,EnergyWeekRankTimes             INT(11)                                   COMMENT "周公益大使获取次数"
    ,EnergyMedalWear                 VARCHAR(512)                              COMMENT "能量勋章佩戴"
    ,BonusSignCardTime               DATETIME                                  COMMENT "阅币福利包到期时间"
    ,BonusSignCardPlusTime           DATETIME                                  COMMENT "阅币福利包plus到期时间"
    ,UserShopType                    INT(11)                                   COMMENT "用户商城类型：0旧商城，1新商城"
    ,LastBuyBonusSignCardTime        DATETIME                                  COMMENT "上次购买福利包时间"
    ,LastBuyBonusSignCardPlusTime    DATETIME                                  COMMENT "上次购买plus福利包时间"
    ,UserMaxChargeAmount             DECIMAL(10, 0)  NOT NULL                  COMMENT "最高充值档位"
    ,LastPaymentId                   VARCHAR(50)                               COMMENT "上一次 第三方支付信息"
    ,ActHeadFrame                    VARCHAR(500)                              COMMENT "活动头像框"
    ,LastChargeTime                  DATETIME                                  COMMENT "上一次充值时间"
    ,row_update_time                 DATETIME                                  COMMENT "更新时间"
    ,IsNewJiFenUser                  TINYINT(4)                                COMMENT "是否进入过新积分UI"
    ,UserUseHeadFrame                VARCHAR(512)                              COMMENT "用户当前佩戴的头像框"
    ,UserUseHeadFrameExpireTime      DATETIME                                  COMMENT "用户当前佩戴的头像框的过期时间"
    ,UserUseHeadFrameType            VARCHAR(50)                               COMMENT "用户当前佩戴的头像框类型"
    ,Ram                             INT(11)                                   COMMENT "手机内存"
    ,Brand                           VARCHAR(255)                              COMMENT "手机品牌"
    ,row_create_time                 DATETIME                                  COMMENT "创建时间"
    ,VipCardType                     INT(11)                                   COMMENT "最后购买的vip卡的类型，1：周，2：月，3：季，4：年"
    ,VipCardActualPrice              DECIMAL(18, 2)                            COMMENT "vip卡的上次购买价格，精准价格"
    ,SVipCardActualPrice             DECIMAL(18, 2)                            COMMENT "svip卡的上次购买价格，精准价格"
    ,Device2                         VARCHAR(765)                              COMMENT "设备2"
    ,sr_createtime                   DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime                   DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    ,INDEX INDEX_PRODUCT_ID (product_id) USING BITMAP COMMENT '产品id索引'
)
PRIMARY KEY (product_id, Id)
COMMENT "OLAP"
DISTRIBUTED BY HASH (product_id, Id) BUCKETS 20
PROPERTIES ("replication_num" = "3",
            "bloom_filter_columns" = "row_create_time, Id",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;