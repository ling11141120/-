create or replace view ads.ads_sensors_production_rechargeexposure_view (
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
    ,mt
    ,programme_id
    ,cz_template_id
    ,cz_template_name
    ,task_current_progress
    ,task_max_progress
    ,app_id
    ,app_version
    ,product_id
    ,os
    ,ip
    ,city
    ,province
    ,country
    ,lib
    ,lib_version
    ,project_id
    ,activity_link        comment "活动链路"
    ,pay_link             comment "支付链路"
    ,activity_id          comment "活动id"
    ,parent_group_id      comment "用户集合ID"
    ,reg_language         comment "注册语言"
    ,ad_group_id          comment "广告人群包ID"
    ,ad_strategy_id       comment "广告策略ID"
    ,main_strategy_id     comment "主策略ID"
    ,module_channel_id    comment "频道id"
    ,recharge_index       comment "档位位序"
    ,zffs_list            comment "支付方式列表"
    ,is_subscription      comment "是否续订"
    ,zffs_id_list         comment "支付方式ID列表"
    ,zffs_strategy_id     comment "支付方式策略ID"
    ,etl_tm
)
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
     , a.mt
     , a.programme_id
     , a.cz_template_id
     , a.cz_template_name
     , a.task_current_progress
     , a.task_max_progress
     , a.app_id
     , a.app_version
     , a.product_id
     , a.os
     , a.ip
     , a.city
     , a.province
     , a.country
     , a.lib
     , a.lib_version
     , a.project_id
     , a.activity_link
     , a.pay_link
     , a.activity_id
     , a.parent_group_id
     , b.current_language2 as reg_language
     , a.ad_group_id
     , a.ad_strategy_id
     , a.main_strategy_id
     , a.module_channel_id
     , a.recharge_index
     , a.zffs_list
     , a.is_subscription
     , a.zffs_id_list
     , a.zffs_strategy_id
     , a.etl_tm
  from ods_log.ods_sensors_cd_video_production_rechargeexposure as a
  left join dim.dim_user_account_info_view                      as b
    on a.app_product_id = b.product_id
   and a.identity_user_id = b.id
 where a.project_id = 5
;