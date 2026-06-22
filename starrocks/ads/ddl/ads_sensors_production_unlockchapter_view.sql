create or replace view ads.ads_sensors_production_unlockchapter_view (
     dt                     comment "分区日期"
    ,id                     comment "nvl(rid,track_id)"
    ,track_id
    ,rid                    comment "记录ID"
    ,event_tm               comment "事件时间"
    ,device_id              comment "设备id"
    ,login_id               comment "login_id"
    ,identity_login_id      comment "identity_login_id"
    ,device_lang            comment "设备语言"
    ,event                  comment "事件"
    ,distinct_id            comment "distinct_id"
    ,identity_user_id       comment "identity_userid"
    ,app_product_id         comment "包体ID"
    ,send_id                comment "转化来源"
    ,app_core_ver           comment "core"
    ,app_channel            comment "渠道编号"
    ,app_product_x          comment "应用程序ID"
    ,app_lang_id            comment "界面语言"
    ,book_id                comment "小说ID"
    ,chapter_ids            comment "章节ids"
    ,coin_consume           comment "消耗充值货币"
    ,gift_consume           comment "消耗赠送货币"
    ,current_coin           comment "当前账户付费货币余额"
    ,current_gift           comment "当前账户免费货币余额"
    ,session_id             comment "会话ID"
    ,unlock_type            comment "解锁类型"
    ,excitingpoint_strategy comment "嗨点策略ID"
    ,reg_language           comment "注册语言"
    ,activity_link          comment "activity_link"
    ,os                     comment "操作系统"
    ,etl_tm
)
comment "event=unlockChapter 解锁章节时上报"
as
select a.dt
     , a.id
     , a.track_id
     , a.rid
     , a.event_tm
     , a.device_id
     , a.login_id
     , a.identity_login_id
     , a.device_lang
     , a.event
     , a.distinct_id
     , a.identity_user_id
     , a.app_product_id
     , a.send_id
     , a.app_core_ver
     , a.app_channel
     , a.app_product_x
     , a.app_lang_id
     , a.book_id
     , a.chapter_ids
     , a.coin_consume
     , a.gift_consume
     , a.current_coin
     , a.current_gift
     , a.session_id
     , a.unlock_type
     , a.excitingpoint_strategy
     , b.current_language2
     , a.activity_link
     , a.os
     , a.etl_tm
  from ods_log.ods_sensors_production_unlockchapter as a
  left join dim.dim_user_account_info_view          as b
    on a.app_product_id = b.product_id
   and a.identity_login_id = b.id
;