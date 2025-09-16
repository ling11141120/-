----------------------------------------------------------------
-- 程序功能： 短剧用户注册信息维度表
-- 程序名： P_dim_short_video_user_accountinfo
-- 目标表： dim.dim_short_video_user_accountinfo
-- 负责人： qhr
-- 开发日期： 2025-09-15
----------------------------------------------------------------

insert into dim.dim_short_video_user_accountinfo
select date(a.createtime)                                        as dt
      ,a.id                                                      as user_id
      ,6833                                                      as product_id
      ,a.account
      ,a.nick
      ,a.sex
      ,a.createtime                                              as create_time
      ,a.lastlogintime                                           as last_login_time
      ,a.chl2
      ,a.chl
      ,coalesce(device.mt, device_other.Mt, a.mt)                as mt
      ,a.mt2
      ,a.uniquecdreaderid                                        as unique_cdreader_id
      ,a.currentlanguage2                                        as current_language2
      ,a.currentlanguage                                         as current_language
      ,a.corever
      ,a.corever2
      ,a.adid
      ,a.status
      ,a.regcountry                                              as reg_country
      ,a.row_update_time
      ,a.version
      ,a.isdelete                                                as is_delete
      ,a.avatar
      ,a.installdate                                             as install_date
      ,a.sourcechl                                               as source_chl
      ,coalesce(device.idfa, a.idfa)                             as idfa
      ,a.email
      ,a.isofficial                                              as is_official
      ,a.uniqueid                                                as unique_id
      ,a.thirdpartyid                                            as third_party_id
      ,coalesce(device.signnotify, a.signnotify)                 as sign_notify
      ,a.lastactivetime                                          as last_active_time
      ,coalesce(device.appnotify, a.appnotify)                   as app_notify
      ,a.level
      ,a.expiretime                                              as expire_time
      ,a.vipstatus                                               as vip_status
      ,a.changedl                                                as change_dl
      ,coalesce(device.regionId, a.regionid)                     as region_id
      ,a.banshopping                                             as ban_shopping
      ,a.moneyfirstdate                                          as money_first_date
      ,a.giftfirstdate                                           as gift_first_date
      ,a.hasdelete                                               as has_delete
      ,a.latestattributionts                                     as latest_attributionts
      ,a.dropattributionts                                       as drop_attributionts
      ,a.adseriesid                                              as ad_series_id
      ,a.adquality                                               as ad_quality
      ,a.LoginBonusGetted                                        as login_bonus_getted
      ,a.CommentBonusGetted                                      as comment_bonus_getted
      ,a.pass_word
      ,a.BindEmail                                               as bind_email
      ,coalesce(device.Appver, device_other.Appver, a.Appver)    as app_ver
      ,a.Ip                                                      as ip
      ,b.FontSize                                                as font_size
      ,b.CreatePasswordTime                                      as create_password_time
      ,b.ThirdLoginTime                                          as third_login_time
      ,device.Locale
      ,device.Langid                                             as lang_id
      ,device.Timestamp
      ,device.Ver
      ,IFNULL(device.Device2, device_other.Device2)              as Device2
      ,device.Syslanguage                                        as sys_language
      ,IFNULL(device.Osver, device_other.Osver)                  as os_ver
      ,device.Appid                                              as app_id
      ,device.X
      ,device.utcoffset                                          as utc_offset
      ,device.Guid
      ,device.Supportutctime                                     as support_utc_time
      ,device.Device
      ,device.Androidid                                          as android_id
      ,device.DeviceToken                                        as device_token
      ,now()                                                     as etl_time
  from ods.ods_tidb_short_video_accountinfo                      as a
  left join ods.ods_tidb_short_video_account_extend              as b
    on a.id = b.AccountId
  left join (select product_id
                   ,id
                   ,Appver
                   ,Sign
                   ,Corever
                   ,Locale
                   ,Userid
                   ,Sid
                   ,Sh
                   ,Langid
                   ,UniqueCdReaderId
                   ,Timestamp
                   ,Ver
                   ,Sendid
                   ,Device2
                   ,Sw
                   ,Chl
                   ,Syslanguage
                   ,Mt
                   ,Idfa
                   ,Osver
                   ,Build
                   ,Appid
                   ,X
                   ,Utcoffset
                   ,Guid
                   ,Supportutctime
                   ,Device
                   ,Androidid
                   ,DeviceToken
                   ,SignNotify
                   ,AppNotify
                   ,regionId
                   ,sr_createtime
                   ,sr_updatetime
               from (select 6833                  as product_id
                           ,id
                           ,Appver
                           ,Sign
                           ,Corever
                           ,Locale
                           ,Userid
                           ,Sid
                           ,Sh
                           ,Langid
                           ,UniqueCdReaderId
                           ,Timestamp
                           ,Ver
                           ,Sendid
                           ,Device2
                           ,Sw
                           ,Chl
                           ,Syslanguage
                           ,Mt
                           ,Idfa
                           ,Osver
                           ,Build
                           ,Appid
                           ,X
                           ,Utcoffset
                           ,Guid
                           ,Supportutctime
                           ,Device
                           ,Androidid
                           ,DeviceToken
                           ,SignNotify
                           ,AppNotify
                           ,regionId
                           ,sr_createtime
                           ,sr_updatetime
                           ,row_number() over(partition by Userid
                                                  order by Timestamp desc
                                             )    as rn
                       from ods.ods_tidb_short_video_device_info
                    )    as d1
               where rn = 1
            )            as device
    on device.product_id = 6833
   and a.id = device.userid
  left join (select a.AccountId
                   ,a.DeviceId
                   ,b.Appver
                   ,b.Device
                   ,b.Device2
                   ,b.OSver
                   ,b.mt
               from ods.ods_tidb_short_video_device_account      as a
               left join ods.ods_tidb_short_video_device_info    as b
                 on a.DeviceId = b.UniqueCdReaderId
            ) device_other
    on a.id = device_other.AccountId
;