create or replace view ads.ads_sensors_cd_video_rechargeexposure_view (
     dt
    ,id
    ,track_id
    ,rid
    ,event_tm
    ,device_id
    ,login_id
    ,identity_login_id
    ,device_lang
    ,event
    ,distinct_id
    ,identity_user_id
    ,app_product_id
    ,send_id
    ,app_core_ver
    ,app_channel
    ,app_product_x
    ,app_lang_id
    ,page_name
    ,page_id
    ,element_name
    ,element_id
    ,recharge_type
    ,book_id
    ,chapter_id
    ,recharge_amount
    ,present_gift
    ,countdown
    ,real_recharge
    ,list_sort
    ,is_available
    ,event_strategy_id
    ,app_module
    ,element_type
    ,czlx
    ,subscription_days
    ,programme_id
    ,cz_template_id
    ,cz_template_name
    ,task_current_progress
    ,task_max_progress
    ,app_id
    ,app_version
    ,product_id
    ,os
    ,core                 comment "core 版本，目前有 1，2，3"
    ,current_language2    comment "注册时语言"
    ,ip
    ,city
    ,province
    ,country
    ,lib
    ,lib_version
    ,project_id
    ,shortplay_id         comment "短剧 id"
    ,episode_id           comment "剧集 id"
    ,activity_link        comment "活动链路"
    ,pay_link             comment "支付链路"
    ,activity_id          comment "活动 id"
    ,parent_group_id      comment "用户集合 ID"
    ,ad_group_id          comment "广告人群包 ID"
    ,ad_strategy_id       comment "广告策略 ID"
    ,main_strategy_id     comment "主策略 ID"
    ,recharge_index       comment "档位位序"
    ,zffs_list            comment "支付方式列表"
    ,etl_tm
)
comment "event=rechargeExposure 充值档位曝光事件"
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
     , a.page_name
     , a.page_id
     , a.element_name
     , a.element_id
     , a.recharge_type
     , a.book_id
     , a.chapter_id
     , a.recharge_amount
     , a.present_gift
     , a.countdown
     , a.real_recharge
     , a.list_sort
     , a.is_available
     , a.event_strategy_id
     , a.app_module
     , a.element_type
     , a.czlx
     , a.subscription_days
     , a.programme_id
     , a.cz_template_id
     , a.cz_template_name
     , a.task_current_progress
     , a.task_max_progress
     , a.app_id
     , a.app_version
     , a.product_id
     , a.os
     , cast((substring(a.app_id, 4, 3)) as int)    as core
     , ods.b.CurrentLanguage2                      as current_language2
     , a.ip
     , a.city
     , a.province
     , a.country
     , a.lib
     , a.lib_version
     , a.project_id
     , a.shortplay_id
     , a.episode_id
     , a.activity_link
     , a.pay_link
     , a.activity_id
     , a.parent_group_id
     , a.ad_group_id
     , a.ad_strategy_id
     , a.main_strategy_id
     , a.recharge_index
     , a.zffs_list
     , a.etl_tm
  from ods_log.ods_sensors_cd_video_production_rechargeexposure as a
  left join ods.ods_tidb_short_video_accountinfo                as b
    on a.login_id = b.Id
 where a.project_id = 8
   and coalesce(a.login_id, '') not in ('0', 'null', '')
;