create or replace view dwd.dwd_sr_ad_install_referrer_log_view (
     dt                 comment "createtime时间"
    ,product_id         comment "产品id"
    ,id                 comment "自增id"
    ,create_time        comment "活动时间"
    ,appid              comment "应用程序id"
    ,appver             comment "版本号"
    ,chl                comment "渠道值"
    ,mt                 comment "平台（终端）"
    ,core               comment "corever包体"
    ,row_data           comment "存放广告信息"
    ,decrypt_data       comment "存放广告信息"
    ,unique_cdreader_id comment "唯一id"
    ,current_language   comment "投放语言"
    ,send_toads
    ,sdk_type           comment "sdk类型"
    ,uac_status         comment "uac状态"
)
comment "海阅-记录在站外针对全量用户进行推书，用户点击链接（UTM链接中带有渠道名和BOOKID）的log数据"
as
select date(createtime) as dt
     , product_id
     , id
     , createtime       as create_time
     , appid
     , appver
     , chl
     , mt
     , core
     , rowdata          as row_data
     , decryptdata      as decrypt_data
     , uniquecdreaderid as unique_cdreader_id
     , currentlanguage  as current_language
     , sendtoads        as send_toads
     , sdktype          as sdk_type
     , uacstatus        as uac_status
  from ods_log.ods_tidb_readerlog_log_installreferrerlog
;