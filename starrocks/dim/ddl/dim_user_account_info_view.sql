create or replace view dim.dim_user_account_info_view (
     dt                               comment "分区-注册时间"
    ,product_id                       comment "产品id"
    ,id                               comment "用户id"
    ,account                          comment "账户id"
    ,nick                             comment "昵称"
    ,sex                              comment "性别0未知 1男 2女 3保密"
    ,head_id                          comment "头像图片序号"
    ,create_time                      comment "用户的注册时间"
    ,last_login_time                  comment "上次登录时间"
    ,chl                              comment "渠道值"
    ,mt                               comment "平台 0未知 1iphone 4安卓 9书城"
    ,imei                             comment "国际移动设备识别码"
    ,imsi                             comment "国际移动用户识别码"
    ,mac                              comment "硬件地址"
    ,money                            comment "当前剩余阅币"
    ,phone                            comment "手机号"
    ,last_sign_time                   comment "最后签到时间"
    ,continue_sign_num                comment "连续签到天数"
    ,continue_login_num               comment "ContinueLoginNum"
    ,device_guid                      comment "设备GUID"
    ,consume_level                    comment "消费等级"
    ,last_stat_time                   comment "最后签到时间"
    ,send_reward_num                  comment "打赏金额剩余值"
    ,ticket                           comment "月票数量"
    ,ticket_time                      comment "月票时间"
    ,curmonth_consume                 comment "本月消费"
    ,last_month_consume               comment "上月消费"
    ,curmonth_reward                  comment "本月打赏"
    ,last_month_reward                comment "上月打赏"
    ,device_token                     comment "关联的设备推送token"
    ,curmonth_ticket                  comment "本月获得月票"
    ,acc                              comment "积分"
    ,email                            comment "电子邮箱"
    ,client_id                        comment '客户id'
    ,is_auto_account                  comment "是否是自动分配的账号"
    ,has_charge                       comment "是否充过值"
    ,has_sent_welcome                 comment "是否已发送私信欢迎信息"
    ,exp                              comment "经验值"
    ,money_first_date                 comment "首充的时间"
    ,province                         comment "省份"
    ,city                             comment "城市"
    ,birthday                         comment "生日"
    ,country                          comment "国家，会变化，从用户最新ip地址解析而来"
    ,prod_id                          comment "产品Id"
    ,send_gift_consume_total          comment "消费送礼物活动剩余消费总额"
    ,is_first                         comment "是否设备首账号"
    ,benefit_send                     comment "新手福利结束时间"
    ,code                             comment "邀请码,邀请新用户注册的"
    ,operate_over                     comment "是否操作过绑定手机"
    ,gift_money                       comment "礼券数量"
    ,gift_money_ex                    comment "礼券数需要重算的时间"
    ,award_money                      comment "赠送币数量"
    ,award_money_ex                   comment "赠送币需要重算的时间"
    ,chl2                             comment "初始渠道值"
    ,ip                               comment "用户最后一次使用IP"
    ,total_coin                       comment "历史获得礼券"
    ,head_image_url                   comment "头像地址Url"
    ,need_push_shelf_book             comment "壳版本迁移用户是否需要下发书架上的书"
    ,read_num                         comment "阅读数"
    ,recharge_type                    comment "充值类型 0:未定义，1:包年"
    ,recharge_type_expire_time        comment "充值类型过期时间"
    ,point                            comment "积分"
    ,appver                           comment "app版本"
    ,ver                              comment "服务端版本号"
    ,is_special_consumer              comment "是否先扣礼券用户"
    ,is_can_consume                   comment "是否禁止用户消费0:不禁止 1:禁止"
    ,idfa                             comment "广告主标识符"
    ,month_card_expire_date           comment "原签到卡的过期时间"
    ,sales_man_type                   comment "推广员类型"
    ,voice_inviter_id                 comment "有声推广员类型"
    ,voice_sales_man_type             comment "有声推广员类型"
    ,phone_bind_time                  comment "手机绑定时间"
    ,ut_coff_set                      comment "用户时区和UTC时间偏移秒数"
    ,voice_sales_man_expire_time      comment "有声推广员过期时间（针对非普通推广员）"
    ,sales_man_expire_time            comment "推广员过期时间（针对非普通推广员）"
    ,last_buy_month_card_date         comment "最近订购签到卡的日期"
    ,last_buy_month_card_id           comment "最近订购签到卡的ID"
    ,introduction                     comment "个人简介"
    ,ad_id                            comment "Deeplink 统计需要： 广告ID"
    ,ad_type                          comment "Deeplink 统计需要： 广告类型 0=facebook 1=adwords"
    ,android_id                       comment "Deeplink 统计需要 安卓id"
    ,install_date                     comment "安装日期"
    ,reg_ip                           comment "注册IP"
    ,reg_country                      comment "注册时国家，不会变化"
    ,plat_form                        comment "平台"
    ,has_bound_email                  comment "是否绑定过邮箱"
    ,email_bound_status               comment "邮箱绑定状态 true 已绑定 false 未绑定"
    ,has_buy_old_card                 comment "是否买过旧的签到卡"
    ,jifen                            comment "积分"
    ,last_report_time                 comment "上次上报启动世间，一个小时内只记录一次"
    ,corever                          comment "包体"
    ,back_gound_img_url               comment "个人中心背景图片"
    ,has_charge_before                comment "Core2首冲活动时间点之前是否有充值 0:未初始化 1:有充值 2:无充值 "
    ,config_ver                       comment "充值配置版本号"
    ,is_fire_base                     comment "Deeplink 是否是firebase数据"
    ,has_buy_old_vip_card             comment "是否购买过旧的会员卡"
    ,app_id                           comment "项目id，core，语言"
    ,app_id2                          comment "首次登陆的appid"
    ,current_language                 comment "用户当前语言"
    ,month_card_plus_expire_date      comment "签到卡Plus的过期时间"
    ,last_buy_month_card_plus_date    comment "最近订购签到卡Plus的日期"
    ,last_buy_month_card_plus_id      comment "最近订购签到卡Plus的ID"
    ,row_update_timestamp             comment "行数据更新了就会变更时间"
    ,android_id_for_device_guid       comment "安卓设备id"
    ,last_item_price                  comment "上一次普通充值的金额"
    ,mt2                              comment "注册时的终端"
    ,corever2                         comment "注册时的corever"
    ,deeplink_plat_form               comment "DeepLink来源平台：-1不是动态链接，0：FB，1：firebase，2：appsflyer"
    ,reg_country2                     comment "注册国家，从华总的kochava来的，if_user_installreferrer,会变化"
    ,energy                           comment "能量"
    ,total_energy                     comment "总能量"
    ,book_id                          comment "广告bookid"
    ,screen_lock_time                 comment "锁屏时间"
    ,real_last_login_time             comment "真正的最后登录时间"
    ,unique_cdreader_id               comment "注册时设备号"
    ,current_language2                comment "注册时语言"
    ,has_change_lang                  comment "是否修改过，注册时候的语言"
    ,medal                            comment "勋章数"
    ,medal_min_expire_time            comment "勋章最早过期时间"
    ,daily_jifen_to_gift_flag         comment "每日积分自动兑换礼券标记"
    ,continue_sign_num2               comment "连续签到28天"
    ,continue_sign_num3               comment "连续签到45天"
    ,sign_round                       comment "签到轮数"
    ,bengin_sign_round_time           comment "开始签到轮数时间"
    ,bengin_sign_time3                comment "新版开始签到时间45"
    ,bengin_sign_time2                comment "新版开始签到时间28"
    ,sr_createtime                    comment "starrocks数据注入时间"
    ,sr_updatetime                    comment "starrocks数据更新时间"
)
comment "阅读：用户注册信息表"
as
select date(createtime)                as dt
      ,productid                       as product_id
      ,Id
      ,Account
      ,Nick
      ,Sex
      ,HeadId                          as head_id
      ,CreateTime                      as create_time
      ,LastLoginTime                   as last_login_time
      ,Chl
      ,MT
      ,IMEI
      ,IMSI
      ,MAC
      ,Money
      ,Phone
      ,LastSignTime                    as last_sign_time
      ,ContinueSignNum                 as continue_sign_num
      ,ContinueLoginNum                as continue_login_num
      ,DeviceGUID                      as device_guid
      ,ConsumeLevel                    as consume_level
      ,LastStatTime                    as last_stat_time
      ,SendRewardNum                   as send_reward_num
      ,Ticket
      ,TicketTime                      as ticket_time
      ,CurMonthConsume                 as curmonth_consume
      ,LastMonthConsume                as last_month_consume
      ,CurMonthReward                  as curmonth_reward
      ,LastMonthReward                 as last_month_reward
      ,DeviceToken                     as device_token
      ,CurMonthTicket                  as curmonth_ticket
      ,Acc
      ,EMail
      ,ClientId                        as client_id
      ,IsAutoAccount                   as is_auto_account
      ,HasCharge                       as has_charge
      ,HasSentWelcome                  as has_sent_welcome
      ,Exp
      ,MoneyFirstDate                  as money_first_date
      ,Province
      ,City
      ,Birthday
      ,Country
      ,ProdId                          as prod_id
      ,SendGiftConsumeTotal            as send_gift_consume_total
      ,IsFirst                         as is_first
      ,BenefitsEnd                     as benefit_send
      ,Code
      ,OperateOver                     as operate_over
      ,GiftMoney                       as gift_money
      ,GiftMoneyEx                     as gift_money_ex
      ,AwardMoney                      as award_money
      ,AwardMoneyEx                    as award_money_ex
      ,Chl2
      ,IP
      ,TotalCoin                       as total_coin
      ,HeadImageUrl                    as head_image_url
      ,NeedPushShelfBook               as need_push_shelf_book
      ,ReadNum                         as read_num
      ,RechargeType                    as recharge_type
      ,RechargeTypeExpireTime          as recharge_type_expire_time
      ,Point
      ,AppVer
      ,Ver
      ,IsSpecialConsumer               as is_special_consumer
      ,IsCanConsume                    as is_can_consume
      ,IDFA
      ,MonthCardExpireDate             as month_card_expire_date
      ,SalesManType                    as sales_man_type
      ,VoiceInviterId                  as voice_inviter_id
      ,VoiceSalesManType               as voice_sales_man_type
      ,PhoneBindTime                   as phone_bind_time
      ,UtcOffset                       as ut_coff_set
      ,VoiceSalesManExpireTime         as voice_sales_man_expire_time
      ,SalesManExpireTime              as sales_man_expire_time
      ,LastBuyMonthCardDate            as last_buy_month_card_date
      ,LastBuyMonthCardId              as last_buy_month_card_id
      ,Introduction
      ,ADID                            as ad_id
      ,AdType                          as ad_type
      ,AndroidId                       as android_id
      ,InstallDate                     as install_date
      ,RegIP                           as reg_ip
      ,RegCountry                      as reg_country
      ,Platform                        as plat_form
      ,HasBoundEmail                   as has_bound_email
      ,EmailBoundStatus                as email_bound_status
      ,HasBuyOldCard                   as has_buy_old_card
      ,JiFen                           as jifen
      ,LastReportTime                  as last_report_time
      ,if (CoreVer = 0,1,CoreVer)      as CoreVer
      ,BackGoundImgUrl                 as back_gound_img_url
      ,HasChargeBefore                 as has_charge_before
      ,ConfigVer                       as config_ver
      ,IsFirebase                      as is_fire_base
      ,HasBuyOldVipCard                as has_buy_old_vip_card
      ,AppId                           as app_id
      ,AppId2                          as app_id2
      ,CurrentLanguage                 as current_language
      ,MonthCardPlusExpireDate         as month_card_plus_expire_date
      ,LastBuyMonthCardPlusDate        as last_buy_month_card_plus_date
      ,LastBuyMonthCardPlusId          as last_buy_month_card_plus_id
      ,RowUpdateTimestamp              as row_update_timestamp
      ,AndroidIdForDeviceGUID          as android_id_for_device_guid
      ,LastItemPrice                   as last_item_price
      ,MT2
      ,if (CoreVer2 = 0,1,CoreVer2)    as CoreVer2
      ,DeepLinkPlatform                as deeplink_plat_form
      ,RegCountry2                     as reg_country2
      ,Energy
      ,TotalEnergy                     as total_energy
      ,BookId                          as book_id
      ,ScreenLockTime                  as screen_lock_time
      ,RealLastLoginTime               as real_last_login_time
      ,UniqueCdReaderId                as unique_cdreader_id
      ,CurrentLanguage2                as current_language2
      ,HasChangeLang                   as has_change_lang
      ,Medal
      ,MedalMinExpireTime              as medal_min_expire_time
      ,DailyJiFenToGiftFlag            as daily_jifen_to_gift_flag
      ,ContinueSignNum2                as continue_sign_num2
      ,ContinueSignNum3                as continue_sign_num3
      ,SignRound                       as sign_round
      ,BenginSignRoundTime             as bengin_sign_round_time
      ,BenginSignTime3                 as bengin_sign_time3
      ,BenginSignTime2                 as bengin_sign_time2
      ,sr_createtime
      ,sr_updatetime
  from ods.ods_book_user_accountinfo
 where productid not in (3521, 3531)
;