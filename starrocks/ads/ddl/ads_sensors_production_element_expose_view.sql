create view ads.ads_sensors_production_element_expose_view(
     dt                       comment "分区日期"
    ,id                       comment "nvl(rid,track_id)"
    ,track_id
    ,rid                      comment "记录ID"
    ,event_tm                 comment "事件时间"
    ,device_id                comment "设备id"
    ,login_id                 comment "login_id"
    ,identity_login_id        comment "identity_login_id"
    ,device_lang              comment "设备语言"
    ,event                    comment "事件"
    ,distinct_id              comment "distinct_id"
    ,identity_user_id         comment "identity_userid"
    ,app_product_id           comment "包体ID"
    ,send_id                  comment "转化来源"
    ,app_core_ver             comment "core"
    ,app_channel              comment "渠道编号"
    ,app_product_x            comment "应用程序ID"
    ,app_lang_id              comment "界面语言"
    ,page_name                comment "页面名称"
    ,page_id                  comment "页面ID"
    ,element_name             comment "控件名称"
    ,element_id               comment "控件ID"
    ,payment_method           comment "支付方式"
    ,type                     comment "类型"
    ,activity_id              comment "活动id"
    ,parent_group_id          comment "用户集合ID"
    ,group_id                 comment "用户分组ID"
    ,activity_link            comment "活动链路"
    ,pay_link                 comment "支付链路"
    ,reg_language             comment "注册时语言"
    ,os                       comment "操作系统"
    ,ad_group_id              comment "广告人群包ID"
    ,ad_strategy_id           comment "广告策略ID"
    ,ad_position_id           comment "广告位置ID"
    ,type2                    comment "类型2"
    ,module_channel_id        comment "频道ID"
    ,programme_id             comment "方案ID"
    ,click_content            comment "点击内容"
    ,event_strategy_id        comment "策略ID"
    ,main_strategy_id         comment "主策略ID"
    ,app_module               comment "模块"
    ,book_category_id_list    comment "书籍分类ID列表"
    ,zffs_strategy_id         comment "支付方式策略ID"
    ,zffs_id_list             comment "支付方式ID列表"
    ,etl_tm
)
as
select a.dt
      ,a.id
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
      ,a.page_name
      ,a.page_id
      ,a.element_name
      ,a.element_id
      ,a.payment_method
      ,a.type
      ,a.activity_id
      ,a.parent_group_id
      ,a.group_id
      ,a.activity_link
      ,a.pay_link
      ,b.current_language2 as reg_language
      ,a.os
      ,a.ad_group_id
      ,a.ad_strategy_id
      ,a.ad_position_id
      ,a.type2
      ,a.module_channel_id
      ,a.programme_id
      ,a.click_content
      ,a.event_strategy_id
      ,a.main_strategy_id
      ,a.app_module
      ,a.book_category_id_list
      ,a.zffs_strategy_id
      ,a.zffs_id_list
      ,a.etl_tm
  from ods_log.ods_sensors_production_element_expose as a
  left join dim.dim_user_account_info_view           as b
    on a.app_product_id = b.product_id
   and a.identity_user_id = b.id
;