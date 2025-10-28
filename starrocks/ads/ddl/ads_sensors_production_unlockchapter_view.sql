drop table if exists ads.ads_sensors_production_unlockchapter_view;
create or replace view ads.ads_sensors_production_unlockchapter_view(
     dt                        comment '分区日期, yyyymmdd'
    ,id                        comment '优先取rid, 为空则取track_id'
    ,track_id                  comment '埋点track_id'
    ,rid                       comment '记录id'
    ,event_tm                  comment '事件时间, 精确到毫秒'
    ,device_id                 comment '设备id'
    ,login_id                  comment '登录id'
    ,identity_login_id         comment '身份登录id'
    ,device_lang               comment '设备系统语言'
    ,event                     comment '事件名, 固定值unlockchapter'
    ,distinct_id               comment 'distinct_id'
    ,identity_user_id          comment '身份用户id'
    ,app_product_id            comment '包体id'
    ,send_id                   comment '转化来源'
    ,app_core_ver              comment 'core版本号'
    ,app_channel               comment '渠道编号'
    ,app_product_x             comment '应用程序id'
    ,app_lang_id               comment '界面语言'
    ,book_id                   comment '小说id'
    ,chapter_ids               comment '解锁章节id列表, 逗号分隔'
    ,coin_consume              comment '消耗充值货币'
    ,gift_consume              comment '消耗赠送货币'
    ,current_coin              comment '当前账户付费货币余额'
    ,current_gift              comment '当前账户免费货币余额'
    ,session_id                comment '会话id'
    ,unlock_type               comment '解锁类型'
    ,excitingpoint_strategy    comment '嗨点策略id'
    ,reg_language              comment '注册语言'
    ,activity_link             comment '活动链接'
    ,os                        comment '操作系统'
    ,etl_tm                    comment 'etl时间'
)
comment '解锁章节事件明细视图, 仅含event=unlockchapter'
as
select a.dt
      ,coalesce(a.rid, a.track_id)    as id
      ,a.track_id
      ,a.rid
      ,a.event_tm
      ,a.device_id
      ,a.login_id
      ,a.identity_login_id
      ,a.device_lang
      ,a.event
      ,a.distinct_id
      ,a.identity_user_id
      ,a.app_product_id
      ,a.send_id
      ,a.app_core_ver
      ,a.app_channel
      ,a.app_product_x
      ,a.app_lang_id
      ,a.book_id
      ,a.chapter_ids
      ,a.coin_consume
      ,a.gift_consume
      ,a.current_coin
      ,a.current_gift
      ,a.session_id
      ,a.unlock_type
      ,a.excitingpoint_strategy
      ,b.current_language2    as reg_language
      ,a.activity_link
      ,a.os
      ,a.etl_tm
  from ods_log.ods_sensors_production_unlockchapter    as a
  left join dim.dim_user_account_info_view             as b
    on a.app_product_id = b.product_id
   and a.identity_login_id = b.id
 where a.dt >= '${bizdate}'
   and a.event = 'unlockchapter'
   and a.book_id is not null
   and a.chapter_ids is not null
;
 